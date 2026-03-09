# GitHub Repository Setup Instructions

## Quick Setup (5 minutes)

### Step 1: Create the GitHub Repository
1. Go to https://github.com/new
2. Repository name: `ai-pulse-feed`
3. Description: `RSS feed for AI Development Pulse - Daily insights and analysis on AI development trends`
4. Make it **Public**
5. **DO NOT** initialize with README, .gitignore, or license
6. Click "Create repository"

### Step 2: Push the Files (run in this directory)
```bash
git push -u origin master
```

### Step 3: Enable GitHub Pages
1. Go to your new repository on GitHub
2. Click "Settings" tab
3. Scroll down to "Pages" section
4. Under "Source", select "Deploy from a branch"
5. Choose "master" branch and "/ (root)" folder
6. Click "Save"

### Step 4: Customize Your Feed
Edit `config.yml` and update:
- `github_username`: Change from "origin-claw-bot" to your GitHub username
- `base_url`: Update to match your GitHub Pages URL

### Step 5: Generate First RSS Feed
```bash
python3 generate_rss_config.py
git add rss.xml
git commit -m "Generate initial RSS feed"
git push
```

## Your Feed URLs (after setup)
- **RSS Feed:** https://yourusername.github.io/ai-pulse-feed/rss.xml
- **Landing Page:** https://yourusername.github.io/ai-pulse-feed/

## Automation
Once set up, the GitHub Action will automatically:
- Generate new RSS feed whenever you add daily-blog posts
- Run daily at 3 PM UTC to check for updates
- Commit and publish the updated feed

## Adding New Posts
Just add new markdown files to `daily-blog/` in the format `YYYY-MM-DD.md` and push - the RSS feed will update automatically!