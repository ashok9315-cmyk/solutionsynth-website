# Deploy Synth AI Solution Website to AWS
# This script deploys the static website to S3 and CloudFront

param(
    [Parameter(Mandatory=$false)]
    [string]$Environment = "production",
    
    [Parameter(Mandatory=$false)]
    [string]$DomainName = "solutionsynth.cloud",
    
    [Parameter(Mandatory=$false)]
    [string]$HostedZoneId = "Z02373041SS8TKQHXZLAR",
    
    [Parameter(Mandatory=$false)]
    [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

Write-Host "Deploying Synth AI Solution Website" -ForegroundColor Green
Write-Host "Domain: $DomainName" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Cyan
Write-Host "Region: $Region" -ForegroundColor Cyan

# Check if AWS CLI is installed
try {
    aws --version | Out-Null
    Write-Host "AWS CLI is installed" -ForegroundColor Green
} catch {
    Write-Host "AWS CLI is not installed. Please install it first." -ForegroundColor Red
    exit 1
}

# Check AWS credentials
try {
    $awsIdentity = aws sts get-caller-identity --output json | ConvertFrom-Json
    Write-Host "AWS credentials configured for account: $($awsIdentity.Account)" -ForegroundColor Green
} catch {
    Write-Host "AWS credentials not configured. Please run 'aws configure'" -ForegroundColor Red
    exit 1
}

$StackName = "solutionsynth-website-$Environment"
$TemplatePath = "infrastructure/website-hosting.yml"

if (-not (Test-Path $TemplatePath)) {
    Write-Host "CloudFormation template not found: $TemplatePath" -ForegroundColor Red
    exit 1
}

Write-Host "Validating CloudFormation template..." -ForegroundColor Yellow
try {
    aws cloudformation validate-template --template-body file://$TemplatePath --region $Region | Out-Null
    Write-Host "CloudFormation template is valid" -ForegroundColor Green
} catch {
    Write-Host "CloudFormation template validation failed" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Check if stack exists
Write-Host "Checking if stack exists..." -ForegroundColor Yellow
$StackExists = $false
$StackStatus = aws cloudformation describe-stacks --stack-name $StackName --region $Region --query "Stacks[0].StackStatus" --output text 2>&1
if ($LASTEXITCODE -eq 0) {
    $StackExists = $true
    Write-Host "Stack exists with status: $StackStatus" -ForegroundColor Cyan
} else {
    Write-Host "Stack does not exist, will create new stack" -ForegroundColor Cyan
}

# Deploy or update stack
if ($StackExists) {
    Write-Host "Updating existing stack..." -ForegroundColor Yellow
    $Command = "update-stack"
} else {
    Write-Host "Creating new stack..." -ForegroundColor Yellow
    $Command = "create-stack"
}

# Temporarily allow errors for this command
$ErrorActionPreference = "Continue"
$StackResult = aws cloudformation $Command --stack-name $StackName --template-body file://$TemplatePath --parameters ParameterKey=DomainName,ParameterValue=$DomainName ParameterKey=HostedZoneId,ParameterValue=$HostedZoneId --capabilities CAPABILITY_IAM --region $Region --output json 2>&1
$StackExitCode = $LASTEXITCODE
$ErrorActionPreference = "Stop"

$SkipWait = $false
if ($StackExitCode -ne 0) {
    if ($StackResult -match "No updates are to be performed") {
        Write-Host "No infrastructure changes detected - stack is up to date" -ForegroundColor Cyan
        $SkipWait = $true
    } else {
        Write-Host "Stack operation failed: $StackResult" -ForegroundColor Red
        exit 1
    }
} else {
    $StackJson = $StackResult | ConvertFrom-Json
    Write-Host "Stack operation initiated successfully" -ForegroundColor Green
    Write-Host "Stack ID: $($StackJson.StackId)" -ForegroundColor Cyan
}

# Wait for stack operation to complete (only if stack was updated)
if (-not $SkipWait) {
    Write-Host "Waiting for stack operation to complete..." -ForegroundColor Yellow
    if ($StackExists) {
        $WaitCommand = "stack-update-complete"
    } else {
        $WaitCommand = "stack-create-complete"
    }

    try {
        aws cloudformation wait $WaitCommand --stack-name $StackName --region $Region
        Write-Host "Stack operation completed successfully" -ForegroundColor Green
    } catch {
        Write-Host "Stack operation failed or timed out" -ForegroundColor Red
        aws cloudformation describe-stack-events --stack-name $StackName --region $Region --query "StackEvents[0:5]" --output table
        exit 1
    }
}

# Get stack outputs
Write-Host "Getting stack outputs..." -ForegroundColor Yellow
try {
    $StackOutputs = aws cloudformation describe-stacks --stack-name $StackName --region $Region --query "Stacks[0].Outputs" --output json | ConvertFrom-Json
    $BucketName = ($StackOutputs | Where-Object { $_.OutputKey -eq "WebsiteBucketName" }).OutputValue
    $CloudFrontId = ($StackOutputs | Where-Object { $_.OutputKey -eq "CloudFrontDistributionId" }).OutputValue
    $WebsiteURL = ($StackOutputs | Where-Object { $_.OutputKey -eq "WebsiteURL" }).OutputValue
    Write-Host "Infrastructure deployed successfully!" -ForegroundColor Green
    Write-Host "S3 Bucket: $BucketName" -ForegroundColor Cyan
    Write-Host "CloudFront Distribution: $CloudFrontId" -ForegroundColor Cyan
    Write-Host "Website URL: $WebsiteURL" -ForegroundColor Cyan
} catch {
    Write-Host "Failed to get stack outputs" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Upload website files to S3
Write-Host "Uploading website files to S3..." -ForegroundColor Yellow

$WebsiteFiles = @("index.html", "error.html", "styles/main.css", "scripts/main.js")
foreach ($file in $WebsiteFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "Website file not found: $file" -ForegroundColor Red
        exit 1
    }
}

try {
    aws s3 cp index.html s3://$BucketName/ --content-type "text/html" --cache-control "max-age=300"
    aws s3 cp error.html s3://$BucketName/ --content-type "text/html" --cache-control "max-age=300"
    aws s3 cp styles/ s3://$BucketName/styles/ --recursive --content-type "text/css" --cache-control "max-age=31536000"
    aws s3 cp scripts/main.js s3://$BucketName/scripts/main.js --content-type "application/javascript" --cache-control "max-age=31536000"
    
    if (Test-Path "assets") {
        aws s3 sync assets/ s3://$BucketName/assets/ --exclude "placeholder.txt" --cache-control "max-age=31536000"
    }
    Write-Host "Website files uploaded successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to upload website files" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Invalidate CloudFront cache
Write-Host "Invalidating CloudFront cache..." -ForegroundColor Yellow
try {
    $InvalidationResult = aws cloudfront create-invalidation --distribution-id $CloudFrontId --paths "/*" --output json | ConvertFrom-Json
    Write-Host "CloudFront invalidation created: $($InvalidationResult.Invalidation.Id)" -ForegroundColor Green
} catch {
    Write-Host "Failed to create CloudFront invalidation (website still accessible)" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Website deployment completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Deployment Summary:" -ForegroundColor Cyan
Write-Host "  Domain: $DomainName" -ForegroundColor White
Write-Host "  Environment: $Environment" -ForegroundColor White
Write-Host "  S3 Bucket: $BucketName" -ForegroundColor White
Write-Host "  CloudFront Distribution: $CloudFrontId" -ForegroundColor White
Write-Host "  Website URL: $WebsiteURL" -ForegroundColor White
Write-Host ""
Write-Host "Note: SSL certificate validation and DNS propagation may take up to 30 minutes." -ForegroundColor Yellow
Write-Host "Your website will be available at: $WebsiteURL" -ForegroundColor Green
