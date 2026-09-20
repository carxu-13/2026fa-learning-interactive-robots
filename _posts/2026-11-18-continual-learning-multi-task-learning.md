---
layout: distill
title: "Continual Learning, Multi-task Learning"
description: "Lifelong robot learning, preventing catastrophic forgetting, and positive transfer across diverse robotic manipulation tasks."
date: 2026-11-18
future: true
htmlwidgets: true

# Scribe team authors
authors:
  - name: "Scribe Team (Student Names)"

bibliography: 2026-11-18-continual-learning-multi-task-learning.bib

toc:
  - name: "Introduction & Motivation"
  - name: "Key Concepts & Theoretical Foundations"
  - name: "Discussion & Paper Syntheses"
  - name: "Critical Analysis & Future Directions"
  - name: "References"
---

## Introduction & Motivation

This lecture report synthesizes the core concepts, assigned readings, and classroom discussions for the **Continual Learning, Multi-task Learning** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Key takeaway**: Lifelong robot learning, preventing catastrophic forgetting, and positive transfer across diverse robotic manipulation tasks.

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
   path="assets/img/2026-11-18-continual-learning-multi-task-learning/overview.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 1: Conceptual overview diagram of Continual Learning, Multi-task Learning." 
%}
```

---

## Discussion & Paper Syntheses

During lecture, we reviewed key methodologies and empirical findings from the foundational literature:

- **Problem Framing**: How does Continual Learning, Multi-task Learning overcome the limitations of traditional non-interactive robotics?
- **Core Insights**: What architectural priors or algorithmic choices yield robust interactive performance?
- **Embodied Deployment**: How do these models transfer to physical hardware under real-world latency, noise, and safety constraints?

---

## Critical Analysis & Future Directions

1. **Assumptions & Failure Modes**: What implicit assumptions about human behavior or sensor observability are violated in unstructured environments?
2. **Scalability & Generalization**: How well do the learned models adapt to novel humans, unseen tasks, or out-of-distribution physical interactions?
3. **Open Research Questions**: What questions remain unresolved for next-generation interactive robots?

---

## References
