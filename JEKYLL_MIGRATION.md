# Jekyll Migration Instructions

This repository has been converted from an RSS-only blog to a full Jekyll blog with RSS support.

## What Changed

### New Structure
```
ai-pulse-feed/
├── _config.yml          # Jekyll configuration
├── Gemfile             # Ruby dependencies  
├── _layouts/           # HTML templates
│   ├── default.html    # Base layout
│   └── post.html       # Post layout
├── _posts/             # Jekyll posts (converted from daily-blog/)
│   ├── 2026-02-28-daily-ai-dev-insights-february-28-2026.md
│   ├── 2026-03-01-daily-ai-dev-insights-march-1-2026.md
│   └── ...
├── index.md            # Blog homepage
├── archive.md          # All posts archive
└── .github/workflows/
    └── jekyll-build-and-deploy.yml  # Updated deployment
```

### Preserved Files
- `daily-blog/` - Original posts (kept for reference)
- `generate_rss.py` - Legacy RSS generator (backup)
- `index.html` - Original landing page (can be removed after migration)

## Features Added

### 1. Individual Post Pages ✅
- Each post now has its own URL: `/YYYY/MM/DD/title/`
- Clean, readable layouts with navigation
- SEO-friendly with proper meta tags

### 2. Blog Homepage ✅
- Lists recent posts with excerpts
- Responsive design matching the original aesthetic
- Easy navigation to archive and RSS feed

### 3. Archive Page ✅
- Chronological listing of all posts
- Grouped by year and month
- Quick scanning with dates and excerpts

### 4. RSS Feed Support ✅
- Jekyll native RSS feed at `/feed.xml`
- Legacy RSS generator as backup at `/rss.xml`
- Both feeds work with all RSS readers

### 5. GitHub Pages Ready ✅
- Uses GitHub Pages compatible Jekyll version
- Automated builds and deployment
- No server setup required

## Migration Steps

### 1. Enable GitHub Pages
1. Go to repository Settings > Pages
2. Source: "GitHub Actions"
3. The workflow will automatically build and deploy

### 2. Update Repository Settings (Optional)
- Update repository description: "Daily AI development insights - Jekyll blog with RSS feed"
- Add topics: `jekyll`, `ai-development`, `rss-feed`, `blog`

### 3. DNS Setup (Optional)
If using a custom domain:
1. Add `CNAME` file with your domain
2. Update `_config.yml` with your URL
3. Configure DNS with your provider

### 4. Clean Up (After Migration Verified)
These files can be removed once Jekyll is working:
- `daily-blog/` (original posts)
- `index.html` (original landing page)  
- `generate_rss.py` and related files (if Jekyll RSS works)
- `config.yml` (old config)
- `setup.sh`

## Local Development

### Prerequisites
- Ruby 3.1+
- Bundler gem

### Setup
```bash
# Clone and navigate
git clone <repository-url>
cd ai-pulse-feed

# Install dependencies
bundle install

# Run local server
bundle exec jekyll serve

# Visit http://localhost:4000
```

### Adding New Posts
Create files in `_posts/` with format: `YYYY-MM-DD-title-with-dashes.md`

```yaml
---
layout: post
title: "Your Post Title"
date: YYYY-MM-DD HH:MM:SS -0800
author: Aaron Henningsgaard
tags: [AI development, specific, tags]
excerpt: "Brief description for RSS and previews"
---

Your post content here...
```

## RSS Feed URLs

Both feeds contain the same content:
- **Jekyll Feed**: `/feed.xml` (primary)
- **Legacy Feed**: `/rss.xml` (backup)

Update any RSS subscriptions to use the new Jekyll feed URL.

## Verification Checklist

After migration:
- [ ] Blog homepage loads and shows recent posts
- [ ] Individual post pages work with clean URLs
- [ ] Archive page lists all posts chronologically  
- [ ] RSS feeds work (test with RSS reader)
- [ ] Mobile responsive design works
- [ ] GitHub Actions workflow runs successfully
- [ ] All original post content preserved

## Rollback Plan

If issues occur:
1. Revert the GitHub Actions workflow to the original `update-rss.yml`
2. Restore `index.html` as the main page
3. Keep `daily-blog/` posts in original format

The original RSS-only functionality is preserved and can be restored quickly.

## Support

For issues or questions about the Jekyll setup, check:
- Jekyll documentation: https://jekyllrb.com/docs/
- GitHub Pages + Jekyll: https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll