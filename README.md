# AI Development Pulse - RSS Feed Generator

This system automatically converts your daily AI development blog posts from markdown files into a proper RSS 2.0 feed that can be hosted on GitHub Pages.

## 🚀 Quick Start

### 1. Create GitHub Repository

1. Go to [GitHub](https://github.com) and create a new public repository
2. Name it `ai-pulse-feed` (or your preferred name)
3. Initialize with README (optional)

### 2. Upload Files

Clone your new repo and copy these files:
```bash
git clone https://github.com/yourusername/ai-pulse-feed.git
cd ai-pulse-feed

# Copy these files from your current workspace:
# - generate_rss.py
# - index.html  
# - daily-blog/ (entire directory)
# - README.md (this file)
```

### 3. Enable GitHub Pages

1. Go to your repo on GitHub
2. Click **Settings** → **Pages**
3. Under **Source**, select **"Deploy from a branch"**
4. Choose **"main"** branch and **"/ (root)"**
5. Click **Save**

Your RSS feed will be available at: `https://yourusername.github.io/ai-pulse-feed/rss.xml`

## 📁 File Structure

```
ai-pulse-feed/
├── generate_rss.py          # Main RSS generator script
├── index.html               # Landing page for the RSS feed
├── rss.xml                  # Generated RSS feed (created by script)
├── daily-blog/              # Your markdown blog posts
│   ├── 2026-02-28.md
│   ├── 2026-03-01.md
│   └── ...
└── README.md                # This file
```

## ⚙️ Usage

### Generate RSS Feed

Run the Python script to generate/update your RSS feed:

```bash
python3 generate_rss.py
```

This will:
- Scan all `.md` files in the `daily-blog/` directory
- Extract titles, dates, and content 
- Generate `rss.xml` with proper RSS 2.0 format
- Sort posts by date (newest first)

### Automation Options

#### Option 1: Manual Updates
Run the script manually whenever you add new blog posts, then commit and push:

```bash
python3 generate_rss.py
git add rss.xml
git commit -m "Update RSS feed"
git push
```

#### Option 2: GitHub Actions (Recommended)

Create `.github/workflows/update-rss.yml`:

```yaml
name: Update RSS Feed

on:
  push:
    paths:
      - 'daily-blog/*.md'
  schedule:
    - cron: '0 15 * * *'  # Run daily at 3 PM UTC

jobs:
  update-rss:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.9'
      
      - name: Generate RSS feed
        run: python3 generate_rss.py
      
      - name: Commit and push RSS feed
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add rss.xml
          git diff --staged --quiet || git commit -m "Auto-update RSS feed"
          git push
```

## 🎯 Features

### RSS Generator (`generate_rss.py`)
- **Multiple title formats**: Handles both "Daily AI Dev Insights" and "AI Development Pulse" formats
- **Markdown to HTML**: Converts markdown formatting to HTML for RSS readers
- **Proper RSS 2.0**: Includes all required RSS elements and metadata
- **Date parsing**: Extracts dates from filenames or content
- **Error handling**: Continues processing even if individual files have issues

### Landing Page (`index.html`)
- **Professional design**: Clean, responsive interface
- **Direct subscribe links**: One-click subscription to popular RSS readers
- **RSS URL copying**: Easy copy-to-clipboard functionality
- **Feed information**: Clear instructions and feed statistics

### RSS Feed Features
- **Standard RSS 2.0 format**
- **Proper CDATA encoding** for HTML content
- **Unique GUIDs** for each post
- **Publication dates** extracted from post metadata
- **Author attribution**
- **Self-referencing atom:link**

## 🔧 Configuration

### Customize Feed Metadata

Edit `generate_rss.py` to customize your feed:

```python
class RSSGenerator:
    def __init__(self, blog_dir="daily-blog", base_url="https://yourusername.github.io/ai-pulse-feed"):
        self.blog_dir = Path(blog_dir)
        self.base_url = base_url  # Change this to your actual GitHub Pages URL
        self.feed_title = "AI Development Pulse"  # Your feed title
        self.feed_description = "Daily insights and analysis..."  # Your description
        self.feed_author = "Aaron Henningsgaard"  # Your name
```

### Update Landing Page

Edit `index.html` to customize:
- Replace `yourusername` with your actual GitHub username
- Update the description and about section
- Modify colors and styling as desired

## 📱 RSS Reader Integration

Your RSS feed will work with all major RSS readers:

### Desktop Readers
- **Feedly** - Web-based, most popular
- **Inoreader** - Feature-rich web reader
- **NetNewsWire** - Free Mac app
- **Feedbro** - Browser extension

### Mobile Readers
- **Reeder** (iOS/Mac) - Premium, excellent design
- **Flipboard** - Magazine-style layout
- **Feedly** mobile apps
- **Google News** (supports RSS)

### Developer Tools
- **curl**: `curl https://yourusername.github.io/ai-pulse-feed/rss.xml`
- **RSS validators**: Use W3C Feed Validator to test

## 🛠️ Troubleshooting

### Common Issues

1. **Python not found**
   ```bash
   # Install Python 3
   sudo apt update && sudo apt install python3
   ```

2. **Permission denied**
   ```bash
   chmod +x generate_rss.py
   ```

3. **GitHub Pages not updating**
   - Check that Pages is enabled in repository settings
   - Verify the repository is public
   - Wait 5-10 minutes for deployment

4. **RSS feed not parsing**
   - Validate your RSS at: https://validator.w3.org/feed/
   - Check for XML syntax errors
   - Ensure proper character encoding

### Debug Mode

Add debug output to the generator:

```python
# Add to main() function
print(f"Found {len(date_files)} blog posts:")
for f in date_files:
    print(f"  - {f.name}")
```

## 🎨 Customization Ideas

### Enhanced Features
- **Category tags**: Add categories to RSS items
- **Full-text search**: Index content for searching
- **Email subscriptions**: Integrate with email services
- **Social sharing**: Add share buttons to landing page
- **Analytics**: Track RSS subscriber count

### Content Enhancements  
- **Images**: Extract and include images from markdown
- **Links**: Convert markdown links to HTML
- **Code blocks**: Preserve code formatting in RSS
- **Table of contents**: Generate TOC for longer posts

## 📊 Analytics

Track your RSS feed usage:
- **GitHub Pages**: Basic traffic stats in repository insights
- **Google Analytics**: Add tracking to `index.html`
- **RSS analytics services**: FeedBurner, Feedpress, etc.

## 🤝 Contributing

To contribute improvements:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your own blog posts
5. Submit a pull request

## 📄 License

This RSS generator is released under the MIT License. Use freely for personal or commercial projects.

---

**Need help?** Open an issue in the GitHub repository or reach out directly.

**RSS Feed URL**: `https://yourusername.github.io/ai-pulse-feed/rss.xml`  
**Landing Page**: `https://yourusername.github.io/ai-pulse-feed/`