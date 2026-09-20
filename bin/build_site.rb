#!/usr/bin/env ruby
require 'yaml'
require 'json'
require 'fileutils'

config = YAML.load_file('_config.yml') rescue {}
schedule = YAML.load_file('_data/schedule.yml') rescue []

site_dir = '_site'
FileUtils.rm_rf(site_dir)
FileUtils.mkdir_p(site_dir)

# Copy assets
if Dir.exist?('assets')
  FileUtils.cp_r('assets', site_dir)
end

baseurl = config['baseurl'] || '/2026fa-learning-interactive-robots'
title = config['title'] || 'Learning for Interactive Robots'

def base_layout(page_title, content, baseurl, active_page = '')
  <<~HTML
  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>#{page_title} | Learning for Interactive Robots</title>
      <meta name="description" content="Course website and student lecture reports for UVA Learning for Interactive Robots (Fall 2026).">
      <link rel="stylesheet" href="#{baseurl}/assets/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mdbootstrap@4.20.0/css/mdb.min.css" crossorigin="anonymous">
      <link rel="stylesheet" href="#{baseurl}/assets/css/academicons.min.css">
      <link rel="stylesheet" href="#{baseurl}/assets/css/scholar-icons.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
      <link rel="stylesheet" href="#{baseurl}/assets/css/main.css">
      <script>
        function toggleTheme() {
          const current = document.documentElement.getAttribute('data-theme') || 'light';
          const next = current === 'light' ? 'dark' : 'light';
          document.documentElement.setAttribute('data-theme', next);
          localStorage.setItem('theme', next);
        }
        (function() {
          const saved = localStorage.getItem('theme') || 'light';
          document.documentElement.setAttribute('data-theme', saved);
        })();
      </script>
      <script>
        window.MathJax = {
          tex: {
            inlineMath: [['$', '$'], ['\\\\(', '\\\\)']],
            displayMath: [['$$', '$$'], ['\\\\[', '\\\\]']]
          }
        };
      </script>
      <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
      <style>
        body { padding-top: 70px; padding-bottom: 70px; }
        .navbar-brand { font-weight: normal; color: #000; letter-spacing: -0.5px; }
        html[data-theme='dark'] .navbar-brand { color: #fff !important; }
        .table th { background-color: #f8f9fa; font-weight: 600; }
        html[data-theme='dark'] .table th { background-color: #2c3237; color: #fff; }
        html[data-theme='dark'] .table td { color: #e8e8e8; }
        .badge-tutorial { background-color: #17a2b8; color: white; }
        .badge-noclass { background-color: #6c757d; color: white; }
        .report-btn { font-size: 0.85rem; font-weight: 500; }
      </style>
    </head>
    <body class="fixed-top-nav sticky-bottom-footer">
      <header>
        <nav id="navbar" class="navbar navbar-light navbar-expand-sm fixed-top bg-white border-bottom shadow-sm">
          <div class="container">
            <a class="navbar-brand text-dark font-weight-normal" href="#{baseurl}/">
              🤖 Learning for Interactive Robots
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
              <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse text-right" id="navbarNav">
              <ul class="navbar-nav ml-auto flex-nowrap align-items-center">
                <li class="nav-item #{active_page == 'schedule' ? 'active' : ''}">
                  <a class="nav-link font-weight-medium" href="#{baseurl}/">schedule</a>
                </li>
                <li class="nav-item #{active_page == 'submitting' ? 'active' : ''}">
                  <a class="nav-link font-weight-medium" href="#{baseurl}/submitting/">submitting</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link font-weight-medium" href="https://yenlingkuo.com/courses/uva-interactive-robot-2026.html" target="_blank" rel="noopener noreferrer">about</a>
                </li>
                <li class="nav-item ml-2">
                  <button class="btn btn-sm btn-outline-secondary px-2 py-1" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                    <i class="fa-solid fa-moon"></i>
                  </button>
                </li>
              </ul>
            </div>
          </div>
        </nav>
      </header>

      <div class="container mt-4" role="main">
        #{content}
      </div>

      <footer class="footer fixed-bottom py-3 bg-white border-top">
        <div class="container text-center small text-muted">
          &copy; 2026 Learning for Interactive Robots &middot; University of Virginia
        </div>
      </footer>

      <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
  </html>
  HTML
end

# 1. Render First Page (index.html)
rows_html = schedule.map do |s|
  if s['has_report']
    badge_report = %(<a href="#{baseurl}#{s['report_url']}" class="btn btn-sm btn-outline-primary report-btn px-3 py-1">Read Report &rarr;</a>)
  else
    badge_report = %(<span class="text-muted">&mdash;</span>)
  end

  <<~TR
    <tr>
      <td class="font-weight-bold">#{s['week']}</td>
      <td>#{s['date']}</td>
      <td><strong>#{s['topic']}</strong></td>
      <td class="text-center">#{badge_report}</td>
    </tr>
  TR
end.join("\n")

index_content = <<~HTML
  <div class="post">
    <header class="post-header mb-4">
      <h1 class="post-title font-weight-bold display-5">Learning for Interactive Robots</h1>
      <p class="post-description lead text-muted">
        <strong>CS 6501 &middot; Fall 2026 &middot; University of Virginia</strong>
      </p>
    </header>

    <div class="card mb-4 border-light shadow-sm">
      <div class="card-body">
        <h5 class="card-title font-weight-bold">About Lecture Reports</h5>
        <p class="card-text text-secondary mb-2">
          Welcome to the course website for <strong>Learning for Interactive Robots</strong> at UVA. Following the model of the <a href="https://iclr-blogposts.github.io/2026/about/" target="_blank">ICLR Blogposts Track</a>, student teams synthesize key concepts, foundational literature, and classroom discussions for each lecture in an interactive, Distill-style blog report.
        </p>
        <p class="card-text text-secondary mb-0">
          Each team submits their lecture report through a <strong>Pull Request</strong> to the course GitHub repository following the <a href="#{baseurl}/submitting/">submission guide</a>. Once reviewed and merged, the report is published directly to this site.
        </p>
      </div>
    </div>

    <section class="mt-4">
      <h3 class="font-weight-bold mb-3">Lecture Reports</h3>

      <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
          <thead class="thead-light">
            <tr>
              <th scope="col" style="width: 12%;">Week</th>
              <th scope="col" style="width: 18%;">Date</th>
              <th scope="col">Lecture Topic</th>
              <th scope="col" style="width: 22%; text-align: center;">Report Page</th>
            </tr>
          </thead>
          <tbody>
            #{rows_html}
          </tbody>
        </table>
      </div>
    </section>
  </div>
HTML

File.write("#{site_dir}/index.html", base_layout("Course Schedule", index_content, baseurl, "schedule"))

# 2. Render Submitting Guide
FileUtils.mkdir_p("#{site_dir}/submitting")
submitting_body = <<~HTML
  <div class="post">
    <header class="post-header mb-4">
      <h1 class="post-title font-weight-bold">Report Submission Guide</h1>
      <p class="post-description text-muted">Pull request workflow and formatting guidelines for student lecture reports.</p>
    </header>

    <div class="card bg-light border mb-4">
      <div class="card-body">
        <h5 class="card-title font-weight-bold">Quickstart Summary</h5>
        <ol class="mb-0 pl-3 text-secondary">
          <li><strong>Fork & Clone</strong>: Fork <a href="https://github.com/live-robotics-uva/2026fa-learning-interactive-robots" target="_blank"><code>live-robotics-uva/2026fa-learning-interactive-robots</code></a> and clone locally.</li>
          <li><strong>Locate Starter File</strong>: Find your assigned post in <code>_posts/YYYY-MM-DD-[slug].md</code>.</li>
          <li><strong>Add Assets</strong>: Place images in <code>assets/img/YYYY-MM-DD-[slug]/</code> and BibTeX in <code>assets/bibliography/YYYY-MM-DD-[slug].bib</code>.</li>
          <li><strong>Preview Locally</strong>: Run via Docker (<code>./bin/docker_run.sh</code>) or Jekyll serve.</li>
          <li><strong>Submit PR</strong>: Title must exactly match <code>YYYY-MM-DD-[slug]</code> against <code>main</code>.</li>
        </ol>
      </div>
    </div>

    <div class="alert alert-warning border-warning">
      <strong>⚠️ Automated File Filter CI</strong>: Automated checks (<code>filter-files.yml</code>) verify that PRs modify <em>only</em> <code>_posts/SLUG.md</code>, <code>assets/img/SLUG/*</code>, <code>assets/html/SLUG/*</code>, and <code>assets/bibliography/SLUG.bib</code>. PRs altering other files are automatically rejected.
    </div>

    <h3 class="font-weight-bold mt-4">Front Matter & Format</h3>
    <pre class="bg-light p-3 rounded border"><code>---
layout: distill
title: "Lecture Topic: Full Title"
description: "A concise 1-2 sentence abstract summarizing key insights."
date: 2026-09-16
future: true
htmlwidgets: true

authors:
  - name: "Student 1"
    affiliations:
      name: "University of Virginia"
  - name: "Student 2"
    affiliations:
      name: "University of Virginia"

bibliography: 2026-09-16-foundation-models-for-vision.bib

toc:
  - name: "Introduction & Context"
  - name: "Core Mathematical Formulation"
  - name: "Key Papers & Syntheses"
  - name: "Critical Analysis & Discussion"
  - name: "References"
---</code></pre>

    <h3 class="font-weight-bold mt-4">Mathematical Formulas</h3>
    <p>Formulas are rendered via MathJax 3. Use inline <code>$ ... $</code> or display equations:</p>
    <pre class="bg-light p-3 rounded border"><code>$$
\\pi^* = \\arg\\max_\\pi \\mathbb{E}_{\\tau \\sim \\pi} \\left[ \\sum_{t=0}^T \\gamma^t R(s_t, a_t) \\right]
$$</code></pre>

    <h3 class="font-weight-bold mt-4">PR Checklist</h3>
    <ul class="text-secondary pl-3">
      <li>All filenames, directories, and assets are strictly lowercase.</li>
      <li>PR title matches filename slug: <code>YYYY-MM-DD-[slug]</code>.</li>
      <li>Team member names and UVA affiliations are filled in.</li>
      <li>No files outside <code>_posts/</code> and dedicated <code>assets/</code> directories have been modified.</li>
    </ul>
  </div>
HTML
File.write("#{site_dir}/submitting/index.html", base_layout("Submission Guide", submitting_body, baseurl, "submitting"))

# 3. Render About Redirect (links directly to external course page)
FileUtils.mkdir_p("#{site_dir}/about")
about_redirect = <<~HTML
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Redirecting to Course Page...</title>
    <meta http-equiv="refresh" content="0; url=https://yenlingkuo.com/courses/uva-interactive-robot-2026.html">
    <link rel="canonical" href="https://yenlingkuo.com/courses/uva-interactive-robot-2026.html">
  </head>
  <body>
    <p>Redirecting to <a href="https://yenlingkuo.com/courses/uva-interactive-robot-2026.html">https://yenlingkuo.com/courses/uva-interactive-robot-2026.html</a>...</p>
  </body>
</html>
HTML
File.write("#{site_dir}/about/index.html", about_redirect)

# 4. Render Blog (Reports Roll)
FileUtils.mkdir_p("#{site_dir}/blog")
report_cards = schedule.select { |s| s['has_report'] }.map do |s|
  post_file = "_posts/#{s['slug']}.md"
  desc = s['topic']
  if File.exist?(post_file)
    text = File.read(post_file)
    if text =~ /description:\s*["']?([^"'\n]+)/
      desc = $1
    end
  end

  <<~CARD
    <div class="card mb-3 shadow-sm hoverable border">
      <div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-1">
          <span class="badge badge-primary px-2 py-1">#{s['week']} &middot; #{s['date']}</span>
          <span class="text-muted small"><i class="fa-regular fa-clock mr-1"></i> ~8 min read</span>
        </div>
        <h4 class="card-title font-weight-bold mb-2">
          <a href="#{baseurl}#{s['report_url']}" class="text-dark text-decoration-none">#{s['topic']}</a>
        </h4>
        <p class="card-text text-secondary mb-3">#{desc}</p>
        <div class="d-flex justify-content-between align-items-center">
          <span class="small text-muted"><i class="fa-solid fa-users mr-1"></i> Scribe Team</span>
          <a href="#{baseurl}#{s['report_url']}" class="btn btn-sm btn-outline-primary px-3">Read Report &rarr;</a>
        </div>
      </div>
    </div>
  CARD
end.join("\n")

blog_body = <<~HTML
  <div class="post">
    <header class="post-header mb-4">
      <h1 class="post-title font-weight-bold">Lecture Reports</h1>
      <p class="post-description text-muted">Complete archive of student lecture reports and interactive syntheses for Fall 2026.</p>
    </header>

    <div class="row">
      <div class="col-md-12">
        #{report_cards}
      </div>
    </div>
  </div>
HTML
File.write("#{site_dir}/blog/index.html", base_layout("Lecture Reports", blog_body, baseurl, "reports"))

# 5. Render Individual Posts
schedule.select { |s| s['has_report'] }.each do |s|
  post_dir = "#{site_dir}#{s['report_url']}"
  FileUtils.mkdir_p(post_dir)
  post_file = "_posts/#{s['slug']}.md"
  bib_file = "assets/bibliography/#{s['slug']}.bib"
  bib_content = File.exist?(bib_file) ? File.read(bib_file) : ""

  post_body = <<~HTML
    <article class="post-content">
      <header class="mb-4 pb-3 border-bottom">
        <div class="mb-2">
          <span class="badge badge-primary px-2 py-1">#{s['week']}</span>
          <span class="badge badge-light border text-secondary ml-1">#{s['date']}</span>
        </div>
        <h1 class="post-title font-weight-bold display-5">#{s['topic']}</h1>
        <div class="d-flex align-items-center text-muted small mt-3">
          <div><i class="fa-solid fa-user-group mr-1"></i> <strong>Authors:</strong> Scribe Team (Student Names)</div>
        </div>
      </header>

      <div class="row">
        <div class="col-md-9">
          <section id="motivation" class="mb-4">
            <h3 class="font-weight-bold mb-2">Introduction & Motivation</h3>
            <p class="text-secondary">
              This lecture report synthesizes core concepts, assigned readings, and classroom discussions for the <strong>#{s['topic']}</strong> session in <em>Learning for Interactive Robots (Fall 2026)</em> at the University of Virginia.
            </p>
            <blockquote class="blockquote border-left pl-3 py-1 my-3 bg-light rounded text-secondary">
              <p class="mb-0"><strong>Key takeaway:</strong> Exploring foundational representation learning, algorithmic formulations, and embodied deployment challenges for #{s['topic'].downcase}.</p>
            </blockquote>
          </section>

          <section id="foundations" class="mb-4">
            <h3 class="font-weight-bold mb-2">Key Concepts & Theoretical Foundations</h3>
            <p class="text-secondary">
              In interactive robotics, formalizing the interaction between the robotic agent and human collaborators is central. Below is a representative mathematical formulation for this lecture topic:
            </p>
            <div class="p-3 bg-light rounded border text-center my-3">
              $$
              \\min_{\\theta} \\; \\mathbb{E}_{\\tau \\sim \\mathcal{D}} \\left[ \\mathcal{L}(\\pi_\\theta(a_t \\mid s_t, h_t), \\; a^*_t) \\right] + \\lambda \\mathcal{R}(\\theta)
              $$
            </div>
            <p class="text-secondary">
              Where $s_t$ represents the robot state, $h_t$ encapsulates the human context (e.g., intent, language instruction, or corrective signals), and $\\pi_\\theta$ denotes the interactive policy.
            </p>
          </section>

          <section id="discussion" class="mb-4">
            <h3 class="font-weight-bold mb-2">Discussion & Paper Syntheses</h3>
            <p class="text-secondary">During lecture, we reviewed key methodologies and empirical findings from the foundational literature:</p>
            <ul class="text-secondary pl-3">
              <li><strong>Problem Framing:</strong> How does #{s['topic']} overcome limitations of traditional non-interactive robotics?</li>
              <li><strong>Core Insights:</strong> What architectural priors or algorithmic choices yield robust interactive performance?</li>
              <li><strong>Embodied Deployment:</strong> How do these models transfer to physical hardware under real-world latency, noise, and safety constraints?</li>
            </ul>
          </section>

          <section id="analysis" class="mb-4">
            <h3 class="font-weight-bold mb-2">Critical Analysis & Future Directions</h3>
            <ol class="text-secondary pl-3">
              <li><strong>Assumptions & Failure Modes:</strong> What implicit assumptions about human behavior or sensor observability are violated in unstructured environments?</li>
              <li><strong>Scalability & Generalization:</strong> How well do the learned models adapt to novel humans, unseen tasks, or out-of-distribution physical interactions?</li>
              <li><strong>Open Research Questions:</strong> What questions remain unresolved for next-generation interactive robots?</li>
            </ol>
          </section>

          <section id="references" class="mb-5 pt-3 border-top">
            <h4 class="font-weight-bold mb-2">References & Citations</h4>
            <pre class="bg-light p-3 rounded border text-secondary" style="font-size: 0.85rem;"><code>#{bib_content}</code></pre>
          </section>
        </div>

        <div class="col-md-3">
          <div class="sticky-top pt-2" style="top: 80px;">
            <div class="card border-light shadow-sm">
              <div class="card-body p-3">
                <h6 class="font-weight-bold mb-2 text-uppercase small text-muted">Table of Contents</h6>
                <nav class="nav flex-column small">
                  <a class="nav-link py-1 text-secondary" href="#motivation">1. Motivation</a>
                  <a class="nav-link py-1 text-secondary" href="#foundations">2. Theoretical Foundations</a>
                  <a class="nav-link py-1 text-secondary" href="#discussion">3. Paper Syntheses</a>
                  <a class="nav-link py-1 text-secondary" href="#analysis">4. Critical Analysis</a>
                  <a class="nav-link py-1 text-secondary" href="#references">5. References</a>
                </nav>
              </div>
            </div>
            <div class="card border-light shadow-sm mt-3">
              <div class="card-body p-3 small text-secondary">
                <strong>Cite this report:</strong>
                <p class="mb-0 mt-1 font-italic">Scribe Team, "#{s['topic']}", UVA Learning for Interactive Robots, 2026.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </article>
  HTML

  File.write("#{post_dir}/index.html", base_layout(s['topic'], post_body, baseurl, "reports"))
end

# 6. Also create root-relative copy or symlink inside _site so that accessing
# both http://localhost:<port>/ and http://localhost:<port>/2026fa-learning-interactive-robots/ works!
base_sub = "#{site_dir}/2026fa-learning-interactive-robots"
FileUtils.rm_rf(base_sub)
FileUtils.mkdir_p(base_sub)
Dir.glob("#{site_dir}/*").each do |item|
  next if File.basename(item) == '2026fa-learning-interactive-robots'
  target = "#{base_sub}/#{File.basename(item)}"
  FileUtils.cp_r(item, target)
end

puts "Site generated successfully into _site/!"
