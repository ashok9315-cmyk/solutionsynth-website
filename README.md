# Synth AI Solution Website

Professional static website for **solutionsynth.cloud** - the homepage of Synth AI Solution, showcasing cutting-edge AI and cloud solutions.

## 🌐 Live Website

**Production URL:** [https://solutionsynth.cloud](https://solutionsynth.cloud)

## 📋 Overview

This is a modern, responsive static website built for Synth AI Solution, featuring:

- **Company Information**: About Synth AI Solution and our mission
- **Services**: AI Solutions, Cloud Computing, Web Development, E-Commerce, Portfolio Generation, Mobile Apps
- **Featured Products**: 
  - [CarbonLens AI](https://carbonlens-ai.solutionsynth.cloud) - Intelligent supply chain carbon footprint tracker
  - [AI CV Maker](https://resume-generator-ai.solutionsynth.cloud/) - Intelligent resume generator powered by AI
  - [Profolia](https://www.profolia.art) - Professional online portfolio creation platform
- **Founder Profile**: Ashok S - Founder & CEO
- **Contact Information**: Direct contact methods and inquiry form

## 🛠️ Technology Stack

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Styling**: Custom CSS with modern design patterns
- **Icons**: Font Awesome 6.4.0
- **Fonts**: Inter (Google Fonts)
- **Hosting**: AWS S3 + CloudFront
- **SSL**: AWS Certificate Manager
- **DNS**: AWS Route 53

## 🏗️ Project Structure

```
solutionsynth-website/
├── .github/
│   └── workflows/
│       └── deploy.yml             # GitHub Actions deployment workflow
├── index.html                     # Main HTML file
├── error.html                     # Custom 404 error page
├── styles/
│   └── main.css                   # Main stylesheet
├── scripts/
│   ├── main.js                    # JavaScript functionality
│   └── deploy-website.ps1         # Manual deployment script
├── assets/
│   ├── logo.svg                   # Company logo
│   ├── favicon.svg                # Website favicon
│   ├── carbonlens-preview.jpg     # CarbonLens AI screenshot
│   ├── AI Resume Generator-preview.jpg # AI CV Maker screenshot
│   ├── profolia-preview.jpg       # Profolia screenshot
│   ├── founder-photo.jpg          # Founder photo
│   └── placeholder.txt            # Asset requirements and guidelines
├── infrastructure/
│   └── website-hosting.yml        # CloudFormation template
└── README.md                      # This file
```

## 🚀 Features

### Design & User Experience
- **Responsive Design**: Mobile-first approach with breakpoints for all devices
- **Modern UI**: Clean, professional design with gradient accents
- **Smooth Animations**: CSS animations and JavaScript interactions
- **Performance Optimized**: Lazy loading, debounced scroll events, optimized assets

### Functionality
- **Mobile Navigation**: Hamburger menu for mobile devices
- **Smooth Scrolling**: Navigation links with smooth scroll behavior
- **Contact Form**: Functional contact form with validation
- **Notification System**: User feedback for form submissions
- **Scroll to Top**: Convenient scroll-to-top button
- **SEO Optimized**: Meta tags, Open Graph, structured data

### Sections
1. **Hero Section**: Eye-catching introduction with company value proposition
2. **About Section**: Company information and core values
3. **Services Section**: Comprehensive service offerings
4. **Products Section**: Featured products with live links
5. **Founder Section**: Founder profile and contact information
6. **Contact Section**: Contact form and company details
7. **Footer**: Links, social media, and additional information

## 🔧 Local Development

### Prerequisites
- Modern web browser
- Text editor or IDE
- Local web server (optional, for testing)

### Setup
1. Clone or download the project files
2. Open `index.html` in a web browser
3. For local server (recommended):
   ```bash
   # Using Python
   python -m http.server 8000
   
   # Using Node.js
   npx serve .
   
   # Using PHP
   php -S localhost:8000
   ```

### File Editing
- **HTML**: Edit `index.html` for content changes
- **CSS**: Edit `styles/main.css` for styling changes
- **JavaScript**: Edit `scripts/main.js` for functionality changes

## 🚀 Deployment

### Automated Deployment (Recommended)
The website uses GitHub Actions for automatic deployment on every push to the main branch.

**Setup:**
1. Add AWS credentials to GitHub repository secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. Push changes to the main branch - deployment happens automatically

**GitHub Actions Workflow:**
- Validates CloudFormation template
- Deploys/updates AWS infrastructure
- Uploads website files to S3
- Invalidates CloudFront cache
- Provides deployment summary

### Manual Deployment
You can also deploy manually using the PowerShell script:

### Manual Deployment Process

1. **Prerequisites**:
   ```powershell
   # Install AWS CLI
   # Configure AWS credentials
   aws configure
   ```

2. **Deploy Infrastructure**:
   ```powershell
   cd solutionsynth-website
   .\scripts\deploy-website.ps1
   ```

### AWS Infrastructure
The website is hosted on AWS using:
- **S3**: Static file hosting
- **CloudFront**: Global CDN for fast delivery
- **Route 53**: DNS management
- **Certificate Manager**: SSL/TLS certificates

### CI/CD Pipeline
- **GitHub Actions**: Automated deployment on push to main branch
- **AWS CLI**: Infrastructure and file deployment
- **CloudFormation**: Infrastructure as Code
- **Cache Invalidation**: Automatic CDN cache clearing
   ```powershell
   # Deploy CloudFormation stack
   aws cloudformation create-stack \
     --stack-name solutionsynth-website-production \
     --template-body file://infrastructure/website-hosting.yml \
     --parameters ParameterKey=DomainName,ParameterValue=solutionsynth.cloud \
     --capabilities CAPABILITY_IAM \
     --region us-east-1

   # Upload files to S3
   aws s3 sync . s3://solutionsynth.cloud-website-production \
     --exclude "*.md" --exclude "infrastructure/*" --exclude "scripts/*"

   # Invalidate CloudFront cache
   aws cloudfront create-invalidation \
     --distribution-id YOUR_DISTRIBUTION_ID \
     --paths "/*"
   ```

## 📁 Assets

### Included Assets
The website includes the following assets:

- `assets/logo.svg` - Company logo
- `assets/favicon.svg` - Website favicon
- `assets/carbonlens-preview.jpg` - CarbonLens AI screenshot
- `assets/AI Resume Generator-preview.jpg` - AI CV Maker screenshot
- `assets/profolia-preview.jpg` - Profolia screenshot
- `assets/founder-photo.jpg` - Founder photo (250x250px)

### Optional Assets
Consider adding these for enhanced functionality:

- `assets/og-image.jpg` - Open Graph image (1200x675px) for social sharing

### Asset Guidelines
- Use high-quality images (minimum 1080p for photos)
- Optimize file sizes for web performance
- Use SVG format for logos and illustrations
- Follow brand colors: Primary gradient (#667eea to #764ba2)

## 🎨 Customization

### Brand Colors
```css
/* Primary Gradient */
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);

/* Text Colors */
--primary-text: #2d3748;
--secondary-text: #666;
--accent-color: #667eea;
```

### Typography
- **Primary Font**: Inter (Google Fonts)
- **Fallback**: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif

### Responsive Breakpoints
- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

## 📞 Contact Information

**Synth AI Solution**
- **Website**: [https://solutionsynth.cloud](https://solutionsynth.cloud)
- **Email**: [ashok@solutionsynth.cloud](mailto:ashok@solutionsynth.cloud)
- **Phone**: [+91-8939876461](tel:+918939876461)

**Founder**: Ashok S
- **Role**: Founder & CEO
- **Expertise**: AI & Machine Learning, Cloud Architecture, Full-Stack Development

## 🔗 Related Projects

- **[CarbonLens AI](https://carbonlens-ai.solutionsynth.cloud)**: Intelligent supply chain carbon footprint tracker
- **[AI CV Maker](https://resume-generator-ai.solutionsynth.cloud/)**: Intelligent resume generator powered by AI
- **[Profolia](https://www.profolia.art)**: Professional online portfolio creation platform

## 📄 License

© 2025 Synth AI Solution. All rights reserved.

## 🚀 Future Enhancements

- [ ] Add blog section for technical articles
- [ ] Implement dark mode toggle
- [ ] Add client testimonials section
- [ ] Integrate with CMS for easy content updates
- [ ] Add multi-language support
- [ ] Implement advanced analytics
- [ ] Add case studies section
- [ ] Create interactive demos

---

**Built with ❤️ by Synth AI Solution**