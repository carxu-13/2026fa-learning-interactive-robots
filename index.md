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
      <strong>CS 6501 &middot; Fall 2026 &middot; University of Virginia</strong>
    </p>
  </header>

  <div class="card mb-4 border-light shadow-sm">
    <div class="card-body">
      <h5 class="card-title font-weight-bold">About Lecture Reports</h5>
      <p class="card-text mb-2">
        Welcome to the course lecture report website for <strong>Learning for Interactive Robots</strong> at UVA. Following the model of the <a href="https://iclr-blogposts.github.io/2026/about/" target="_blank">ICLR Blogposts Track</a>, student teams synthesize and critique key concepts, foundational papers, and discussion insights for each lecture in a rich, interactive Distill-style blog report.
      </p>
      <p class="card-text mb-0">
        Each team submits their lecture report through a <strong>Pull Request</strong> to the course GitHub repository following the <a href="{{ '/submitting/' | relative_url }}">submission guide</a>. Once reviewed and merged, the report is published directly to this site.
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
          {% for session in site.data.schedule %}
            <tr>
              <td>{{ session.week }}</td>
              <td>{{ session.date }}</td>
              <td>{{ session.topic }}</td>
              <td class="text-center">
                {% assign is_linked = false %}
                {% if session.has_report %}
                  {% for post in site.posts %}
                    {% if post.url == session.report_url and post.ready %}
                      {% assign is_linked = true %}
                    {% endif %}
                  {% endfor %}
                {% endif %}
                {% if is_linked %}
                  <a href="{{ session.report_url | relative_url }}" class="btn btn-sm btn-outline-primary px-3 py-1 font-weight-medium">
                    Read Report &rarr;
                  </a>
                {% else %}
                  <span class="text-muted">&mdash;</span>
                {% endif %}
              </td>
            </tr>
          {% endfor %}
        </tbody>
      </table>
    </div>
  </section>
</div>
