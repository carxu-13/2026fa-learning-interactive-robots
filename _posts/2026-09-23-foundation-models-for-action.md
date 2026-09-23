---
layout: distill
title: "Foundation Models for Action"
description: "Vision-Language-Action (VLA) models (RT-1, RT-2, OpenVLA) trained on internet-scale multimodal data and cross-embodiment robot demonstrations."
date: 2026-09-23
future: true
htmlwidgets: true
ready: false

# Reporter team authors
authors:
  - name: "Reporter Team (Angelica Bain, Srikar Bangaru, Samriddhi Kumar, Caroline Xu)"

bibliography: 2026-09-23-foundation-models-for-action.bib

toc:
  - name: "Introduction"
  - name: "Diffusion Policy"
  - name: "Vision-Language-Action Flow Model"
  - name: "Cross-Paradigm Comparison"
  - name: "Question and Answer"

---

## Introduction

This lecture report covers the **Foundation Models for Action** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Topic Overview**: Vision-Language-Action (VLA) models (RT-1, RT-2, OpenVLA) trained on internet-scale multimodal data and cross-embodiment robot demonstrations.

## Diffusion Policy: Visuometer Policy Learning via Action Diffusion

This lecture report covers the **Foundation Models for Action** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Topic Overview**: Vision-Language-Action (VLA) models (RT-1, RT-2, OpenVLA) trained on internet-scale multimodal data and cross-embodiment robot demonstrations.


## $\pi_0$: A Vision-Language-Action Flow Model for General Robot Control

$\pi_0$ builds on the framework of generating an entire action sequence, by combining this approach with a pretrained VLM, to create a generalist VLA model. 

> **Current Problem and Introduction**: Developing robot foundation models have a few major challenges: Research must be completed at a large scale, model architectures must effectively make use of diverse data sources while representing subtleties, and pre-training and post-training ratios and procedures are hard to curate. $\pi_0$ solves these issues by proposing a design that fine-tunes a VLM (vision-language model) to produce actions via flow matching.
**$\pi_0$ Model**
{% include figure.liquid 
   path="assets\img\2026-09-23-foundation-models-for-action\pi0_framework.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 1: Pre-training mixture trains the flow matching VLA model, which then initializes the weights from PaliGemma. The resulting $\pi_0$ model is used to control various robot embodiments to control a wide array of tasks." 
%}
**Experiment and Evaluation**

**Limitations and Open Challenges**

## Cross-Paradigm Comparison

This lecture report covers the **Foundation Models for Action** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Topic Overview**: Vision-Language-Action (VLA) models (RT-1, RT-2, OpenVLA) trained on internet-scale multimodal data and cross-embodiment robot demonstrations.

## Presentation Q&A

During the lecture, several technical questions were raised by the presenting team concerning the capabilities of VLAs:

> **Question 1:** Do you expect VLAs (vision-language-action models) to exhibit the same scaling properties (neural scaling laws) as LLMs? Why/why not?
**Question 2:** Do you expect VLAs to be a sufficient approach to master all physical intelligence tasks?
**Question 3:** Do you think backpropagating through the LLM during VLA training could improve learned representations of the LLM?



---

### Report Status

This report is currently being prepared and will be updated by the student reporter team following the lecture session and classroom discussion. Please check back soon!
