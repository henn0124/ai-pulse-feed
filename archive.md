---
layout: default
title: Archive - All Posts
---

# Archive - All Posts

*Complete archive of daily AI development insights and analysis.*

---

{% assign posts_by_year = site.posts | group_by_exp: 'post', 'post.date | date: "%Y"' %}

{% for year in posts_by_year %}
## {{ year.name }}

{% assign posts_by_month = year.items | group_by_exp: 'post', 'post.date | date: "%B"' %}
{% for month in posts_by_month %}
### {{ month.name }} {{ year.name }}

<div class="posts-list">
{% for post in month.items %}
  <article class="archive-post">
    <div class="post-date">
      <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %d" }}</time>
    </div>
    <div class="post-info">
      <h4 class="post-title">
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </h4>
      <div class="post-excerpt">
        {% if post.excerpt %}
          {{ post.excerpt | strip_html | truncatewords: 20 }}
        {% else %}
          {{ post.content | strip_html | truncatewords: 20 }}
        {% endif %}
      </div>
      {% if post.tags.size > 0 %}
        <div class="post-tags">
          {% for tag in post.tags limit: 4 %}
            <span class="tag">#{{ tag }}</span>{% unless forloop.last %} {% endunless %}
          {% endfor %}
        </div>
      {% endif %}
    </div>
  </article>
{% endfor %}
</div>

{% endfor %}
{% endfor %}

---

<div style="text-align: center; margin: 40px 0;">
  <a href="{{ "/" | relative_url }}" class="nav-links">← Back to Home</a>
  <a href="{{ "/feed.xml" | relative_url }}" class="nav-links rss-link" style="margin-left: 20px;">📡 RSS Feed</a>
</div>

<style>
  .posts-list {
    margin-bottom: 40px;
  }
  
  .archive-post {
    display: flex;
    align-items: flex-start;
    margin-bottom: 25px;
    padding-bottom: 20px;
    border-bottom: 1px solid #f0f0f0;
  }
  
  .post-date {
    flex-shrink: 0;
    width: 80px;
    margin-right: 20px;
    text-align: right;
  }
  
  .post-date time {
    font-size: 0.9em;
    color: #7f8c8d;
    font-weight: bold;
  }
  
  .post-info {
    flex: 1;
  }
  
  .post-title {
    margin: 0 0 8px 0;
    font-size: 1.2em;
  }
  
  .post-title a {
    color: #2c3e50;
    text-decoration: none;
  }
  
  .post-title a:hover {
    color: #3498db;
    text-decoration: underline;
  }
  
  .post-excerpt {
    color: #666;
    font-size: 0.95em;
    line-height: 1.4;
    margin-bottom: 8px;
  }
  
  .post-tags {
    font-size: 0.85em;
  }
  
  .tag {
    color: #3498db;
    margin-right: 8px;
  }
  
  h2 {
    color: #2c3e50;
    margin-top: 50px;
    margin-bottom: 30px;
    font-size: 2em;
    border-bottom: 3px solid #3498db;
    padding-bottom: 10px;
  }
  
  h3 {
    color: #34495e;
    margin-top: 30px;
    margin-bottom: 20px;
    font-size: 1.4em;
  }
  
  @media (max-width: 600px) {
    .archive-post {
      flex-direction: column;
    }
    
    .post-date {
      width: auto;
      margin-right: 0;
      margin-bottom: 5px;
      text-align: left;
    }
  }
</style>