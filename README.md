# Learning for Interactive Robots (UVA Fall 2026)

[![Deploy site](https://github.com/live-robotics-uva/2026fa-learning-interactive-robots/actions/workflows/deploy.yaml/badge.svg)](https://github.com/live-robotics-uva/2026fa-learning-interactive-robots/actions/workflows/deploy.yaml)
[![filter-files](https://github.com/live-robotics-uva/2026fa-learning-interactive-robots/actions/workflows/filter-files.yml/badge.svg)](https://github.com/live-robotics-uva/2026fa-learning-interactive-robots/actions/workflows/filter-files.yml)

Course website and student lecture reports repository for **CS 6501 / CS 4501: Learning for Interactive Robots** at the **University of Virginia (Fall 2026)**.

🌐 **Live Website**: [https://live-robotics-uva.github.io/2026fa-learning-interactive-robots](https://live-robotics-uva.github.io/2026fa-learning-interactive-robots)

---

## Overview

Following the model of the [ICLR Blogposts track](https://iclr-blogposts.github.io/2026/about/), each student team serves as scribes for a designated lecture topic and publishes a comprehensive, peer-reviewed [Distill-style](https://distill.pub/) blog report. 

Reports combine mathematical rigor, interactive visualizations, critical summaries of foundational papers, and syntheses of classroom discussions.

---

## Course Schedule & Topics

The home page features an interactive schedule table linking each lecture to its dedicated report:

| Week | Date | Lecture Topic | Report Required? | Report Post |
|:---|:---|:---|:---:|:---|
| **Week 4** | Wed, Sep 16 | Foundation Models for Vision | Yes | [`_posts/2026-09-16-foundation-models-for-vision.md`](_posts/2026-09-16-foundation-models-for-vision.md) |
| **Week 5** | Mon, Sep 21 | Foundation Models for Language | Yes | [`_posts/2026-09-21-foundation-models-for-language.md`](_posts/2026-09-21-foundation-models-for-language.md) |
| **Week 5** | Wed, Sep 23 | Foundation Models for Action | Yes | [`_posts/2026-09-23-foundation-models-for-action.md`](_posts/2026-09-23-foundation-models-for-action.md) |
| **Week 6** | Mon, Sep 28 | Tutorial | *No* | — |
| **Week 6** | Wed, Sep 30 | Language Grounding & Commonsense | Yes | [`_posts/2026-09-30-language-grounding-commonsense.md`](_posts/2026-09-30-language-grounding-commonsense.md) |
| **Week 7** | Mon, Oct 5 | No Class - Fall Reading Days | *No* | — |
| **Week 7** | Wed, Oct 7 | Tutorial | *No* | — |
| **Week 8** | Mon, Oct 12 | Policy, World Model Code Generation | Yes | [`_posts/2026-10-12-policy-world-model-code-generation.md`](_posts/2026-10-12-policy-world-model-code-generation.md) |
| **Week 8** | Wed, Oct 14 | Feedback and Correction | Yes | [`_posts/2026-10-14-feedback-and-correction.md`](_posts/2026-10-14-feedback-and-correction.md) |
| **Week 9** | Mon, Oct 19 | Non-verbal Interaction and Learning Signals | Yes | [`_posts/2026-10-19-non-verbal-interaction-and-learning-signals.md`](_posts/2026-10-19-non-verbal-interaction-and-learning-signals.md) |
| **Week 9** | Wed, Oct 21 | Human Models | Yes | [`_posts/2026-10-21-human-models.md`](_posts/2026-10-21-human-models.md) |
| **Week 10** | Mon, Oct 26 | Intent/Trajectory Prediction | Yes | [`_posts/2026-10-26-intent-trajectory-prediction.md`](_posts/2026-10-26-intent-trajectory-prediction.md) |
| **Week 10** | Wed, Oct 28 | Preference, Influence | Yes | [`_posts/2026-10-28-preference-influence.md`](_posts/2026-10-28-preference-influence.md) |
| **Week 11** | Mon, Nov 2 | Social Interaction, Cooperation | Yes | [`_posts/2026-11-02-social-interaction-cooperation.md`](_posts/2026-11-02-social-interaction-cooperation.md) |
| **Week 11** | Wed, Nov 4 | Shared Autonomy | Yes | [`_posts/2026-11-04-shared-autonomy.md`](_posts/2026-11-04-shared-autonomy.md) |
| **Week 12** | Mon, Nov 9 | No Class - Project Feedback | *No* | — |
| **Week 12** | Wed, Nov 11 | No Class - Project Feedback | *No* | — |
| **Week 13** | Mon, Nov 16 | Human-in-the-loop Systems | Yes | [`_posts/2026-11-16-human-in-the-loop-systems.md`](_posts/2026-11-16-human-in-the-loop-systems.md) |
| **Week 13** | Wed, Nov 18 | Continual Learning, Multi-task Learning | Yes | [`_posts/2026-11-18-continual-learning-multi-task-learning.md`](_posts/2026-11-18-continual-learning-multi-task-learning.md) |
| **Week 14** | Mon, Nov 23 | Safety, Trust | Yes | [`_posts/2026-11-23-safety-trust.md`](_posts/2026-11-23-safety-trust.md) |

---

## Student Quickstart: Submitting a Report

### 1. Fork & Clone
Fork this repository to your GitHub account and clone your fork locally:
```bash
git clone git@github.com:<your-username>/2026fa-learning-interactive-robots.git
cd 2026fa-learning-interactive-robots
```

### 2. Locate Your Lecture Report File
Find your team's assigned starter template in `_posts/`:
```bash
# Example for Week 4
_posts/2026-09-16-foundation-models-for-vision.md
```

### 3. Add Assets and References
Only modify files within these designated paths:
- **Report Markdown**: `_posts/YYYY-MM-DD-[slug].md`
- **Images/Diagrams**: `assets/img/YYYY-MM-DD-[slug]/`
- **Interactive HTML**: `assets/html/YYYY-MM-DD-[slug]/`
- **BibTeX Citations**: `assets/bibliography/YYYY-MM-DD-[slug].bib`

> [!CAUTION]
> Do **NOT** modify configuration files, layouts, includes, or other posts. Automated GitHub Actions will reject pull requests that modify files outside your dedicated post and asset directories.

### 4. Preview Locally

#### Using Docker (Recommended)
```bash
./bin/docker_run.sh
```
Open [http://localhost:8080/2026fa-learning-interactive-robots/](http://localhost:8080/2026fa-learning-interactive-robots/) in your browser.

#### Using Ruby / Bundler
```bash
bundle install
bundle exec jekyll serve --future
```
Open [http://localhost:4000/2026fa-learning-interactive-robots/](http://localhost:4000/2026fa-learning-interactive-robots/) in your browser.

### 5. Submit Pull Request
1. Commit your changes to a new branch:
   ```bash
   git checkout -b report-2026-09-16-foundation-models-for-vision
   git add _posts/ assets/
   git commit -m "Add lecture report for Foundation Models for Vision"
   git push origin report-2026-09-16-foundation-models-for-vision
   ```
2. Open a Pull Request against `live-robotics-uva/2026fa-learning-interactive-robots` `main` branch.
3. Name your PR title **strictly matching your post slug**:
   `2026-09-16-foundation-models-for-vision`
4. Complete the PR template checklist. Automated CI will validate your submission and provide feedback.

---

## Repository Structure

```text
├── .devcontainer/             # VS Code Dev Container configuration
├── .github/
│   ├── pull_request_template.md # PR submission checklist for students
│   └── workflows/
│       ├── deploy.yaml        # Automated deployment to GitHub Pages
│       └── filter-files.yml   # PR file-path validation CI
├── _bibliography/             # Global bibliography data
├── _data/
│   └── schedule.yml           # Course schedule & report URL definitions
├── _includes/                 # Liquid template components (header, footer, math, figures)
├── _layouts/                  # Page layouts (distill, default, page, post)
├── _pages/
│   ├── about.md               # About the course & instructor
│   ├── blog.md                # Searchable blog roll of all reports
│   └── submitting.md          # Detailed student submission guidelines
├── _posts/                    # 15 starter templates for lecture reports
├── assets/
│   ├── bibliography/          # Post-specific BibTeX files
│   ├── css/                   # Stylesheets (Bootstrap, theme)
│   ├── html/                  # Post-specific interactive widgets
│   ├── img/                   # Post-specific diagrams and figures
│   └── js/                    # Theme switcher, MathJax, search
├── bin/
│   ├── docker_run.sh          # Local Docker runner
│   ├── filter_paths.py        # PR path validation script
│   └── merge_prs.sh           # PR preview build script
├── _config.yml                # Site configuration
├── Gemfile                    # Ruby dependencies
└── index.md                   # Home page with responsive schedule table
```

---

## Instructor & Course Staff

- **Instructor**: Prof. Yen-Ling Kuo (LIVE Lab, Department of Computer Science, University of Virginia)
- **Course**: CS 6501 / CS 4501: Learning for Interactive Robots (Fall 2026)
