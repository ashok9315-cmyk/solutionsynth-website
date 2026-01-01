# GitHub Actions Workflows

This directory contains automated workflows for the Synth AI Solution website.

## 🚀 Workflows Overview

### 1. **CI/CD Pipeline** (`deploy.yml`)

**Triggers**: Push to `main`/`develop`, Pull Requests to `main`

**Features**:
- 🔒 **Security Scanning**: Hardcoded secret detection, HTML validation
- ✅ **Infrastructure Validation**: CloudFormation template validation
- 🚀 **Production Deployment**: Automated deployment to AWS (main branch only)
- 📊 **Deployment Verification**: Post-deployment health checks
- 🔄 **Cache Management**: Automatic CloudFront cache invalidation

**Environments**:
- **Production**: Deploys to `https://solutionsynth.cloud`

## 🔧 Setup Requirements

### GitHub Secrets

Add these secrets to your GitHub repository:

```bash
# AWS Credentials (Required)
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
```

**⚠️ Important**: 
1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add the AWS credentials with the exact names above

### Repository Settings

1. **Enable Actions**: Go to Settings → Actions → General → Allow all actions
2. **Branch Protection**: Set up branch protection rules for `main` (optional)
3. **Environments**: Create a `production` environment with required reviewers (optional)

## 📊 Workflow Status

### Main Branch Status
- [![CI/CD Pipeline](https://github.com/ashok9315-cmyk/solutionsynth-website/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/ashok9315-cmyk/solutionsynth-website/actions/workflows/deploy.yml)

## 🎯 Workflow Jobs

| Job | Description | Runs On |
|-----|-------------|---------|
| **security-scan** | Scans for hardcoded secrets and validates HTML | All pushes/PRs |
| **validate-infrastructure** | Validates CloudFormation template | All pushes/PRs |
| **deploy-production** | Deploys to AWS production environment | Main branch only |
| **notify** | Sends deployment status notifications | After deployment |

## 🔄 Development Workflow

### For Contributors:
1. **Create Feature Branch**: `git checkout -b feature/your-feature`
2. **Make Changes**: Develop your feature
3. **Create PR**: Open PR to `main`
4. **Automated Checks**: Security scan and validation run automatically
5. **Review & Merge**: After approval, merge triggers deployment

### For Maintainers:
1. **Monitor Deployments**: Check GitHub Actions tab for deployment status
2. **Review Security**: Address any security scan findings
3. **Performance**: Monitor website performance after deployments

## 🚨 Troubleshooting

### Common Issues:

**Deployment Failures**:
- Check AWS credentials in repository secrets
- Verify AWS permissions for CloudFormation, S3, and CloudFront
- Ensure domain and hosted zone ID are correct

**Security Scan Failures**:
- Remove any hardcoded AWS keys or secrets
- Use GitHub Secrets for sensitive data
- Check HTML validation errors

**Infrastructure Validation Failures**:
- Verify CloudFormation template syntax
- Check AWS resource limits and quotas
- Ensure proper IAM permissions

## 📈 Monitoring & Alerts

### What's Monitored:
- ✅ Website deployment status
- ✅ Security vulnerabilities
- ✅ Infrastructure validation
- ✅ Post-deployment health checks

### Alert Channels:
- GitHub Actions notifications
- Workflow run summaries
- Email notifications (if configured)

## 🔒 Security Features

### Automated Security:
- **Secret Scanning**: Prevents hardcoded API keys and AWS credentials
- **HTML Validation**: Ensures proper HTML structure
- **Access Control**: Environment-based deployment protection
- **Credential Management**: Secure secret storage in GitHub

### Best Practices:
- All secrets stored in GitHub Secrets
- No hardcoded credentials in code
- Automated security scanning on every commit
- Production deployments only from main branch

## 🚀 Quick Start

1. **Fork/Clone** the repository
2. **Add AWS Secrets** to your GitHub repository settings
3. **Push Changes** to trigger workflows
4. **Monitor** workflow runs in the Actions tab

The workflows will automatically handle security scanning, validation, and deploying your website to AWS! 🎉

---

## 📋 Workflow Configuration

### Environment Variables:
- `AWS_REGION`: us-east-1
- `DOMAIN_NAME`: solutionsynth.cloud
- `HOSTED_ZONE_ID`: Z02373041SS8TKQHXZLAR

### Deployment Steps:
1. Security scanning and validation
2. CloudFormation stack deployment
3. Website file upload to S3
4. CloudFront cache invalidation
5. Deployment verification
6. Status notification

The entire deployment process typically takes 3-5 minutes to complete.