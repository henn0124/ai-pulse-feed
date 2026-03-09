#!/bin/bash

# AI Development Pulse RSS Feed Setup Script
# Run this script to quickly set up your RSS feed for GitHub Pages deployment

set -e  # Exit on any error

echo "🚀 AI Development Pulse RSS Feed Setup"
echo "======================================"

# Check if we're in the right directory
if [ ! -d "daily-blog" ]; then
    echo "❌ Error: daily-blog/ directory not found!"
    echo "   Please run this script from the directory containing your daily-blog/ folder"
    exit 1
fi

echo "✅ Found daily-blog/ directory"

# Count blog posts
POST_COUNT=$(find daily-blog/ -name "*.md" -not -name "_*" | wc -l)
echo "📝 Found $POST_COUNT blog posts"

# Check if Python is available
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "❌ Error: Python not found!"
    echo "   Please install Python 3.x to generate RSS feeds"
    exit 1
fi

echo "✅ Found Python: $PYTHON_CMD"

# Generate initial RSS feed
echo "🔄 Generating RSS feed..."
if [ -f "config.yml" ]; then
    echo "   Using configuration from config.yml"
    $PYTHON_CMD generate_rss_config.py
else
    echo "   Using default configuration"
    $PYTHON_CMD generate_rss.py
fi

# Check if RSS was generated
if [ ! -f "rss.xml" ]; then
    echo "❌ Error: Failed to generate rss.xml"
    exit 1
fi

echo "✅ Generated rss.xml successfully"

# Display RSS stats
RSS_SIZE=$(stat -c%s rss.xml 2>/dev/null || stat -f%z rss.xml 2>/dev/null || echo "unknown")
RSS_ITEMS=$(grep -c "<item>" rss.xml 2>/dev/null || echo "0")

echo "📊 RSS Feed Stats:"
echo "   File size: $RSS_SIZE bytes"
echo "   Number of posts: $RSS_ITEMS"

# Check required files
echo ""
echo "🔍 Checking required files:"

REQUIRED_FILES=("index.html" "generate_rss.py" "README.md")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file (missing)"
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  Warning: Some files are missing. Please ensure you have:"
    for file in "${MISSING_FILES[@]}"; do
        echo "   - $file"
    done
fi

# Check if .github/workflows exists
if [ -d ".github/workflows" ]; then
    echo "   ✅ .github/workflows/ (GitHub Actions ready)"
else
    echo "   ⚠️  .github/workflows/ (GitHub Actions not set up)"
fi

echo ""
echo "📋 Next Steps:"
echo "=============="

echo "1. Create a new GitHub repository (e.g., 'ai-pulse-feed')"
echo "2. Upload all files to your repository:"

cat << 'EOF'
   git init
   git add .
   git commit -m "Initial RSS feed setup"
   git branch -M main
   git remote add origin https://github.com/yourusername/ai-pulse-feed.git
   git push -u origin main
EOF

echo ""
echo "3. Enable GitHub Pages:"
echo "   - Go to Settings → Pages"
echo "   - Source: Deploy from branch"  
echo "   - Branch: main, folder: / (root)"

echo ""
echo "4. Update your base URL:"
if [ -f "config.yml" ]; then
    echo "   - Edit config.yml"
    echo "   - Change 'yourusername' to your GitHub username"
else
    echo "   - Edit generate_rss.py"  
    echo "   - Update base_url with your GitHub Pages URL"
fi

echo ""
echo "Your RSS feed will be available at:"
echo "🔗 https://yourusername.github.io/ai-pulse-feed/rss.xml"
echo "🏠 https://yourusername.github.io/ai-pulse-feed/"

echo ""
echo "🎉 Setup complete! Your RSS feed system is ready for deployment."

# Offer to open files for editing
if command -v code &> /dev/null; then
    echo ""
    read -p "📝 Open config files in VS Code? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "config.yml" ]; then
            code config.yml
        fi
        code README.md
    fi
fi