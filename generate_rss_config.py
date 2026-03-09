#!/usr/bin/env python3
"""
Enhanced RSS Feed Generator for AI Development Pulse Daily Reports
Reads configuration from config.yml and generates RSS 2.0 XML feed
"""

import os
import re
import yaml
from datetime import datetime
from pathlib import Path
import xml.etree.ElementTree as ET
from xml.dom import minidom

class ConfigurableRSSGenerator:
    def __init__(self, config_file="config.yml"):
        self.config = self.load_config(config_file)
        self.blog_dir = Path(self.config['content']['blog_directory'])
        
    def load_config(self, config_file):
        """Load configuration from YAML file"""
        default_config = {
            'feed': {
                'title': 'AI Development Pulse',
                'description': 'Daily insights and analysis on AI development trends',
                'author': 'Aaron Henningsgaard',
                'language': 'en-us'
            },
            'site': {
                'base_url': 'https://username.github.io/ai-pulse-feed'
            },
            'content': {
                'blog_directory': 'daily-blog',
                'max_posts': 50
            },
            'contact': {
                'email': 'noreply@example.com'
            }
        }
        
        try:
            with open(config_file, 'r', encoding='utf-8') as f:
                user_config = yaml.safe_load(f) or {}
            
            # Merge user config with defaults
            config = default_config.copy()
            for section, values in user_config.items():
                if section in config:
                    config[section].update(values)
                else:
                    config[section] = values
                    
            return config
            
        except FileNotFoundError:
            print(f"Config file {config_file} not found, using defaults")
            return default_config
        except yaml.YAMLError as e:
            print(f"Error parsing config file: {e}")
            return default_config
    
    def extract_title_and_date(self, filepath):
        """Extract title and date from markdown file"""
        with open(filepath, 'r', encoding='utf-8') as f:
            first_line = f.readline().strip()
        
        # Handle different title formats
        if first_line.startswith('# Daily AI Dev Insights - '):
            date_str = first_line.replace('# Daily AI Dev Insights - ', '')
            title = f"Daily AI Dev Insights - {date_str}"
        elif first_line.startswith('# AI Development Pulse - '):
            date_str = first_line.replace('# AI Development Pulse - ', '')
            title = f"AI Development Pulse - {date_str}"
        else:
            # Fallback: extract from filename
            filename = filepath.stem  # e.g., "2026-03-09"
            try:
                file_date = datetime.strptime(filename, "%Y-%m-%d")
                date_str = file_date.strftime("%B %d, %Y")
                title = f"{self.config['feed']['title']} - {date_str}"
            except ValueError:
                title = first_line.replace('# ', '') if first_line.startswith('#') else filename
                date_str = "Unknown Date"
        
        # Parse date for RSS pubDate
        try:
            if "," in date_str:
                pub_date = datetime.strptime(date_str, "%B %d, %Y")
            else:
                # Try parsing filename
                filename = filepath.stem
                pub_date = datetime.strptime(filename, "%Y-%m-%d")
        except ValueError:
            pub_date = datetime.now()
            
        return title, pub_date
    
    def extract_content(self, filepath):
        """Extract content from markdown file, converting to HTML-like format"""
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Convert markdown headers to HTML
        content = re.sub(r'^# (.+)$', r'<h1>\1</h1>', content, flags=re.MULTILINE)
        content = re.sub(r'^## (.+)$', r'<h2>\1</h2>', content, flags=re.MULTILINE)
        content = re.sub(r'^### (.+)$', r'<h3>\1</h3>', content, flags=re.MULTILINE)
        
        # Convert **bold** to <strong>
        content = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', content)
        
        # Convert *italic* to <em>
        content = re.sub(r'(?<!\*)\*([^*]+?)\*(?!\*)', r'<em>\1</em>', content)
        
        # Convert markdown links to HTML
        content = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', content)
        
        # Convert line breaks to <br> and wrap paragraphs
        paragraphs = content.split('\n\n')
        html_paragraphs = []
        
        for para in paragraphs:
            para = para.strip()
            if para:
                # Don't wrap headers in <p> tags
                if not (para.startswith('<h') or para.startswith('---') or para.startswith('*')):
                    para = para.replace('\n', '<br/>')
                    if not para.startswith('<'):
                        para = f'<p>{para}</p>'
                html_paragraphs.append(para)
        
        return '\n'.join(html_paragraphs)
    
    def generate_rss(self):
        """Generate RSS 2.0 XML feed from markdown files"""
        # Create RSS root element
        rss = ET.Element('rss', version='2.0')
        rss.set('xmlns:atom', 'http://www.w3.org/2005/Atom')
        
        channel = ET.SubElement(rss, 'channel')
        
        # Channel metadata from config
        ET.SubElement(channel, 'title').text = self.config['feed']['title']
        ET.SubElement(channel, 'description').text = self.config['feed']['description']
        ET.SubElement(channel, 'link').text = self.config['site']['base_url']
        ET.SubElement(channel, 'language').text = self.config['feed']['language']
        
        author_email = f"{self.config['contact']['email']} ({self.config['feed']['author']})"
        ET.SubElement(channel, 'managingEditor').text = author_email
        ET.SubElement(channel, 'webMaster').text = author_email
        ET.SubElement(channel, 'lastBuildDate').text = datetime.now().strftime('%a, %d %b %Y %H:%M:%S %z')
        
        # Self-referencing atom link
        atom_link = ET.SubElement(channel, 'atom:link')
        atom_link.set('href', f"{self.config['site']['base_url']}/rss.xml")
        atom_link.set('rel', 'self')
        atom_link.set('type', 'application/rss+xml')
        
        # Get all markdown files and sort by date (newest first)
        md_files = list(self.blog_dir.glob('*.md'))
        # Filter out template and other non-date files
        date_files = [f for f in md_files if re.match(r'\d{4}-\d{2}-\d{2}\.md', f.name)]
        date_files.sort(key=lambda x: x.stem, reverse=True)
        
        # Limit to max_posts
        max_posts = self.config['content'].get('max_posts', 50)
        date_files = date_files[:max_posts]
        
        # Generate items
        for filepath in date_files:
            try:
                title, pub_date = self.extract_title_and_date(filepath)
                content = self.extract_content(filepath)
                
                # Create item element
                item = ET.SubElement(channel, 'item')
                ET.SubElement(item, 'title').text = title
                ET.SubElement(item, 'description').text = content
                ET.SubElement(item, 'link').text = f"{self.config['site']['base_url']}/posts/{filepath.stem}.html"
                ET.SubElement(item, 'guid').text = f"{self.config['site']['base_url']}/posts/{filepath.stem}.html"
                ET.SubElement(item, 'pubDate').text = pub_date.strftime('%a, %d %b %Y %H:%M:%S +0000')
                ET.SubElement(item, 'author').text = author_email
                
                # Add categories if configured
                if 'categories' in self.config:
                    for category in self.config['categories']:
                        ET.SubElement(item, 'category').text = category
                
            except Exception as e:
                print(f"Error processing {filepath}: {e}")
                continue
        
        # Pretty print XML
        rough_string = ET.tostring(rss, encoding='unicode')
        reparsed = minidom.parseString(rough_string)
        return reparsed.toprettyxml(indent="  ", encoding='UTF-8').decode('utf-8')

def main():
    """Generate RSS feed using configuration and save to rss.xml"""
    
    # Try to use PyYAML, fall back to basic generator if not available
    try:
        import yaml
        generator = ConfigurableRSSGenerator()
        print("Using configurable RSS generator with config.yml")
    except ImportError:
        print("PyYAML not available, falling back to basic generator")
        # Fall back to the original generator
        from generate_rss import RSSGenerator
        generator = RSSGenerator()
    
    # Check if daily-blog directory exists
    if not generator.blog_dir.exists():
        print(f"Error: {generator.blog_dir} directory not found!")
        return
    
    # Generate RSS content
    print("Generating RSS feed...")
    rss_content = generator.generate_rss()
    
    # Write to file
    output_file = Path('rss.xml')
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(rss_content)
    
    print(f"RSS feed generated successfully: {output_file}")
    
    # Show feed info
    md_files = list(generator.blog_dir.glob('*.md'))
    date_files = [f for f in md_files if re.match(r'\d{4}-\d{2}-\d{2}\.md', f.name)]
    print(f"Processed {len(date_files)} blog posts")
    
    if hasattr(generator, 'config'):
        print(f"Feed title: {generator.config['feed']['title']}")
        print(f"Base URL: {generator.config['site']['base_url']}")

if __name__ == '__main__':
    main()