---
layout: distill
title: "Safety, Trust"
description: "Control barrier functions, reachability analysis, human trust dynamics, and verifiable safe interaction in robotics."
date: 2026-11-23
future: true
htmlwidgets: true

# Scribe team authors
authors:
  - name: "Scribe Team (Student Names)"

bibliography: 2026-11-23-safety-trust.bib

toc:
  - name: "Introduction & Motivation"
  - name: "Key Concepts & Theoretical Foundations"
  - name: "Discussion & Paper Syntheses"
  - name: "Critical Analysis & Future Directions"
  - name: "References"
---

## Introduction & Motivation

This lecture report synthesizes the core concepts, assigned readings, and classroom discussions for the **Safety, Trust** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Key takeaway**: Control barrier functions, reachability analysis, human trust dynamics, and verifiable safe interaction in robotics.

---

## Key Concepts & Theoretical Foundations

In interactive robotics, formalizing the interaction between the robotic agent and human collaborators is central. Below is a representative mathematical formulation for this lecture topic:

$$
\min_{\theta} \; \mathbb{E}_{\tau \sim \mathcal{D}} \left[ \mathcal{L}(\pi_\theta(a_t \mid s_t, h_t), \; a^*_t) \right] + \lambda \mathcal{R}(\theta)
$$

Where $s_t$ represents the robot state, $h_t$ encapsulates the human context (e.g., intent, language instruction, or corrective signals), and $\pi_\theta$ denotes the interactive policy.

### Interactive Components & Figures

Student teams are encouraged to illustrate architectures, control loops, or data distributions using clear figures and interactive widgets:

```liquid
{% include figure.liquid 
   path="assets/img/2026-11-23-safety-trust/overview.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 1: Conceptual overview diagram of Safety, Trust." 
%}
```

---

## Discussion & Paper Syntheses

During lecture, we reviewed key methodologies and empirical findings from the foundational literature:

- **Problem Framing**: How does Safety, Trust overcome the limitations of traditional non-interactive robotics?
- **Core Insights**: What architectural priors or algorithmic choices yield robust interactive performance?
- **Embodied Deployment**: How do these models transfer to physical hardware under real-world latency, noise, and safety constraints?

---

## Critical Analysis & Future Directions

1. **Assumptions & Failure Modes**: What implicit assumptions about human behavior or sensor observability are violated in unstructured environments?
2. **Scalability & Generalization**: How well do the learned models adapt to novel humans, unseen tasks, or out-of-distribution physical interactions?
3. **Open Research Questions**: What questions remain unresolved for next-generation interactive robots?

---

## References
