---
layout: default
title: schedule
permalink: /
nav: true
nav_order: 1
---

<div class="post">
  <header class="post-header mb-4">
    <h1 class="post-title font-weight-bold">Learning for Interactive Robots</h1>
    <p class="post-description text-muted">
      <strong>CS 6501 / CS 4501 &middot; Fall 2026</strong> &middot; University of Virginia<br>
      Department of Computer Science &middot; LIVE Lab
    </p>
  </header>

  <div class="card mb-4 border-light shadow-sm">
    <div class="card-body">
      <h5 class="card-title font-weight-bold">About the Lecture Reports</h5>
      <p class="card-text text-secondary mb-2">
        Welcome to the website for <strong>Learning for Interactive Robots</strong> at UVA. Following the model of the <a href="https://iclr-blogposts.github.io/2026/about/" target="_blank">ICLR Blogposts Track</a>, student teams synthesize and critique key concepts, foundational papers, and discussion insights for each lecture in a rich, interactive Distill-style blog report.
      </p>
      <p class="card-text text-secondary mb-3">
        Each team submits their lecture report through a <strong>Pull Request</strong> to the course GitHub repository. Once reviewed and merged, the report is published directly to this site.
      </p>
      <div class="d-flex flex-wrap" style="gap: 0.5rem;">
        <a href="{{ '/blog/' | relative_url }}" class="btn btn-primary btn-sm">
          <i class="fa-solid fa-newspaper mr-1"></i> Browse All Reports
        </a>
        <a href="{{ '/submitting/' | relative_url }}" class="btn btn-outline-secondary btn-sm">
          <i class="fa-solid fa-code-pull-request mr-1"></i> PR Submission Guide
        </a>
        <a href="https://github.com/live-robotics-uva/2026fa-learning-interactive-robots" target="_blank" class="btn btn-outline-dark btn-sm">
          <i class="fa-brands fa-github mr-1"></i> GitHub Repository
        </a>
      </div>
    </div>
  </div>

  <section class="mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="font-weight-bold mb-0">Course Schedule & Lecture Reports</h3>
      <span class="text-muted small">Fall 2026 (Weeks 4&ndash;14)</span>
    </div>

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
          {% for session in site.data.schedule %}
            <tr class="{% unless session.has_report %}table-light text-muted{% endunless %}">
              <td class="font-weight-bold">{{ session.week }}</td>
              <td>{{ session.date }}</td>
              <td>
                {% if session.has_report %}
                  <strong>{{ session.topic }}</strong>
                {% else %}
                  <span class="text-secondary">{{ session.topic }}</span>
                  {% if session.topic contains 'Tutorial' %}
                    <span class="badge badge-info ml-1">Tutorial</span>
                  {% elsif session.topic contains 'No Class' %}
                    <span class="badge badge-secondary ml-1">No Class</span>
                  {% endif %}
                {% endif %}
              </td>
              <td class="text-center">
                {% if session.has_report %}
                  <a href="{{ session.report_url | relative_url }}" class="btn btn-sm btn-outline-primary px-3 py-1 font-weight-medium">
                    Read Report &rarr;
                  </a>
                {% else %}
                  <span class="text-muted font-italic">&mdash;</span>
                {% endif %}
              </td>
            </tr>
          {% endfor %}
        </tbody>
      </table>
    </div>
  </section>

  <section class="mt-5 p-4 rounded bg-light border">
    <h4 class="font-weight-bold mb-2">How to Contribute Your Report</h4>
    <ol class="mb-0 pl-3 text-secondary">
      <li>Fork the repository: <a href="https://github.com/live-robotics-uva/2026fa-learning-interactive-robots" target="_blank"><code>live-robotics-uva/2026fa-learning-interactive-robots</code></a>.</li>
      <li>Edit your assigned report template file under <code>_posts/YYYY-MM-DD-[topic-slug].md</code>.</li>
      <li>Add figures to <code>assets/img/YYYY-MM-DD-[topic-slug]/</code> and references to <code>assets/bibliography/YYYY-MM-DD-[topic-slug].bib</code>.</li>
      <li>Open a Pull Request with title <code>YYYY-MM-DD-[topic-slug]</code>. Automated checks will verify your files.</li>
      <li>See the complete instructions in the <a href="{{ '/submitting/' | relative_url }}">Submission Guide</a>.</li>
    </ol>
  </section>
</div>
