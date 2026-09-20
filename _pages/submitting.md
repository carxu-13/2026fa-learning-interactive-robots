---
layout: page
title: submitting
permalink: /submitting/
description: Student submission guidelines and pull request workflow for lecture reports.
nav: true
nav_order: 2
---

### Course Report Submission Workflow

In **Learning for Interactive Robots (UVA Fall 2026)**, student teams create and submit their lecture reports via GitHub Pull Requests, adopting the model of the [ICLR Blogposts track](https://iclr-blogposts.github.io/2026/about/).

This workflow gives students hands-on experience producing high-quality, reproducible scientific communications with interactive visualizations, mathematical rigor, and transparent peer review.

---

### Quickstart

1. **Fork the Course Repository**:
   Fork [github.com/live-robotics-uva/2026fa-learning-interactive-robots](https://github.com/live-robotics-uva/2026fa-learning-interactive-robots) to your GitHub account and clone it locally.

2. **Locate or Create Your Post**:
   Navigate to the `_posts/` directory. Each lecture has a designated post file matching the date and topic slug:
   - Format: `_posts/YYYY-MM-DD-[slug].md`
   - Example: `_posts/2026-09-16-foundation-models-for-vision.md`

3. **Add Your Assets**:
   - **Static Figures & Images**: Place image files in `assets/img/YYYY-MM-DD-[slug]/`.
   - **Interactive HTML Widgets**: Place interactive HTML files in `assets/html/YYYY-MM-DD-[slug]/`.
   - **BibTeX Citations**: Place reference citations in `assets/bibliography/YYYY-MM-DD-[slug].bib`.

4. **Test and Preview Locally**:
   Run the local server using Docker (`./bin/docker_run.sh`) or native Jekyll (`bundle exec jekyll serve`). Preview your post at `http://localhost:8080` (or `http://localhost:4000`).

5. **Open a Pull Request**:
   - Create a PR against the `main` branch of `live-robotics-uva/2026fa-learning-interactive-robots`.
   - Set the PR title to **exactly match your post slug**: `YYYY-MM-DD-[slug]`.
   - Fill out the PR template checklist.

> [!WARNING]
> **Strict File Modification Filter**
> Automated CI checks (`filter-files.yml`) strictly verify that your PR modifies **ONLY** allowed files:
> - `_posts/YYYY-MM-DD-[slug].md`
> - `assets/img/YYYY-MM-DD-[slug]/*`
> - `assets/html/YYYY-MM-DD-[slug]/*`
> - `assets/bibliography/YYYY-MM-DD-[slug].bib`
>
> If any files outside your post or asset folder are touched, the PR check will fail.

---

### Creating & Formatting Your Report

Your report uses Jekyll's **Distill** layout, designed specifically for scientific and technical blogging.

#### Front Matter (YAML Header)

Every post begins with a YAML front matter block:

```yaml
---
layout: distill
title: "Lecture Topic: Full Title"
description: "A concise 1-2 sentence abstract summarizing the key insights of the lecture."
date: 2026-09-16
future: true
htmlwidgets: true

authors:
  - name: "Alice Smith"
  - name: "Bob Jones"

bibliography: 2026-09-16-foundation-models-for-vision.bib

toc:
  - name: "Introduction & Context"
  - name: "Core Mathematical Formulation"
  - name: "Interactive Visualizations"
  - name: "Key Papers & Critical Takeaways"
  - name: "Open Questions & Discussion"
  - name: "References"
---
```

#### Math & Equations

Math is rendered using **MathJax 3**.
- **Inline math**: Surround LaTeX expressions with single dollar signs or `\( ... \)` (e.g., `$p(\tau \mid \theta)$`).
- **Display equations**: Surround equations with `$$ ... $$` as a standalone block:

```latex
$$
\pi^* = \arg\max_\pi \mathbb{E}_{\tau \sim \pi} \left[ \sum_{t=0}^T \gamma^t R(s_t, a_t) \right]
$$
```

#### Figures & Media

Static images should be placed in `assets/img/YYYY-MM-DD-[slug]/`. To embed images with captions and responsive scaling, use the Liquid `figure` include:

```liquid
{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/architecture.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 1: Vision-Language-Action architecture diagram." 
%}
```

For interactive HTML widgets (e.g., Plotly, Bokeh, D3, or three.js), place the HTML bundle in `assets/html/YYYY-MM-DD-[slug]/` and embed with an `<iframe>` or the interactive figure include.

#### Bibliography & Citations

{% raw %}
Cite papers using the Distill citation tag `<d-cite key="citation_key"></d-cite>` or Jekyll Scholar `{% cite citation_key %}`:
- Example: `Recent work by <d-cite key="brohan2022rt1"></d-cite> demonstrated end-to-end robotic control.`
{% endraw %}
- Place matching BibTeX entries in `assets/bibliography/YYYY-MM-DD-[slug].bib`.
- Citations and hover tooltips are automatically generated at the end of the post.

---

### Local Serving & Preview

To preview your blog post locally before submitting:

#### Option A: Docker (Recommended)
Make sure [Docker](https://docs.docker.com/get-docker/) is running, then execute:

```bash
./bin/docker_run.sh
```

Navigate to `http://localhost:8080/2026fa-learning-interactive-robots/` to preview the site with live reload.

#### Option B: Native Ruby & Bundler
If you have Ruby (3.3+) and Bundler installed:

```bash
bundle install
bundle exec jekyll serve --future
```

Navigate to `http://localhost:4000/2026fa-learning-interactive-robots/`.

---

### PR Checklist Before Submission

- [ ] Post is located at `_posts/YYYY-MM-DD-[slug].md` with all lowercase letters and hyphens.
- [ ] PR Title matches the filename: `YYYY-MM-DD-[slug]`.
- [ ] All authors, student names, and affiliations are listed in the YAML front matter.
- [ ] Images are placed in `assets/img/YYYY-MM-DD-[slug]/`.
- [ ] Citations are placed in `assets/bibliography/YYYY-MM-DD-[slug].bib`.
- [ ] No files outside `_posts/` and your dedicated `assets/` subfolders have been modified.
- [ ] Post builds and previews cleanly with no broken images or LaTeX errors.