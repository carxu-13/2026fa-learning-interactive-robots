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
    subsections:
    - name: "Introduction and Problem"
    - name: "Diffusion for Robot Actions"
    - name: "Visual Conditioning and Model Architecture"
    - name: "Action Chunking and Receding-Horizon Control"
    - name: "Key Properties of Diffusion Policy"
    - name: "Experiments and Limitations"
  - name: "Vision-Language-Action Flow Model"
  - name: "Cross-Paradigm Comparison"
  - name: "Question and Answer"

---

## Introduction

Autonomous robots operating in unstructured, human-centered environments must do more than recognize objects or understand instructions, they must translate that understanding into **physical actions that succeed in the real world**. Unlike purely perceptual or language-based tasks, robot control is affected by contact dynamics, sensing uncertainty, execution error, and changes in the environment that occur as the robot acts.

A central theme of this lecture is that **generalization must survive physical execution**. Language may identify *what* task should be performed, but a robot policy must still determine *how* to move in a way that is precise, temporally consistent, and responsive to feedback.

Learning general robot policies introduces several challenges:

1. **Multiple Valid Behaviors**: A single task may admit several successful action sequences. For example, a robot may approach an object from different directions or complete subtasks in different orders. A policy therefore needs to represent distributions over possible behaviors rather than only a single deterministic action.

2. **Temporal Dependence**: Robot actions are not independent across time. Once a robot begins following a particular strategy, subsequent controls must remain consistent with that decision while still responding to changes in the environment.

3. **Physical Execution and Feedback**: Predictions must remain useful after they are executed. Contact, control error, or unexpected changes can cause the physical state to differ from what the policy anticipated, making closed-loop observation and replanning important.

4. **Generalization Across Tasks and Environments**: A general-purpose robot should ideally reuse knowledge across different tasks, objects, scenes, and robot embodiments rather than requiring a completely separate policy for every behavior.

To address these challenges, this lecture examines two approaches to learning and generating robot actions:

- **Diffusion Policy** <d-cite key="chi2023diffusion"></d-cite>: Represents robot control as a conditional generative modeling problem. Rather than directly predicting a single action, Diffusion Policy generates continuous **action sequences** through iterative denoising, allowing the policy to model multimodal behaviors while maintaining temporal consistency.

- **$\pi_0$: A Vision-Language-Action Flow Model** <d-cite key="black2025pi0"></d-cite>: Combines a pretrained vision-language model with a continuous action-generation module. Visual and language representations provide semantic task context, while a dedicated action expert generates continuous robot action chunks through flow matching.

Together, these approaches highlight two complementary components of general robot intelligence: learning expressive representations of **what behavior is appropriate** and generating continuous, closed-loop actions that can reliably realize that behavior in the physical world.


## Diffusion Policy: Visuomotor Policy Learning via Action Diffusion

### Introduction and Problem {#introduction-and-problem}

A central goal in robot learning is to learn control policies directly from demonstrations. In **behavior cloning**, demonstrations pair observations of the robot and its environment with the controls executed by a human or expert controller. The policy is then trained through supervised learning to reproduce appropriate controls from the robot's current context.

Although this resembles a standard supervised learning problem, predicting robot actions introduces several additional challenges. The Diffusion Policy paper highlights three in particular: **multimodal action distributions**, **sequential correlation between actions**, and the need for **high-precision control**. <d-cite key="chi2023diffusion"></d-cite>

Robot actions are sequential because a control decision at one timestep constrains which actions are sensible at the next. They must also remain precise after being physically executed: small errors can alter the state of the environment and affect all subsequent actions. Most importantly, the same situation may have several different successful solutions rather than one uniquely correct action.

**Multimodal action distributions.** A distribution is **multimodal** when it contains several distinct high-probability solutions, or modes. In robot manipulation, these modes can correspond to different strategies for accomplishing the same task. For example, a robot may be able to approach an object from either the left or the right, use different valid grasps, or complete several subtasks in different orders. Demonstrations can therefore contain substantially different actions even when the underlying task and observation are similar.

This creates a problem for simple deterministic regression. A squared-error regression objective tends to favor predictions near the average of the demonstrated actions. When the demonstrations represent distinct strategies, however, the average between them may not itself be a useful strategy. For instance, averaging trajectories that pass around opposite sides of an obstacle could result in a trajectory that passes between the demonstrated modes rather than following either successful path.

The objective is therefore not always to recover one "correct" action. A useful robot policy may instead need to represent a **distribution over several possible successful behaviors**.

**Representing an action distribution.** The paper and presentation compare three broad ways to represent this distribution:

| Policy Representation | Basic Idea | Main Trade-off |
| :--- | :--- | :--- |
| **Explicit / Direct Prediction** | Directly predict an action or the parameters of an action distribution | Simple and efficient, but common regression objectives can struggle when distinct behaviors are all valid |
| **Implicit / Energy-Based Policy** | Learn an energy function over candidate actions and search for actions with low energy | Can represent multimodal distributions, but action optimization and training can be difficult |
| **Diffusion Policy** | Begin with a noisy action sample and iteratively refine it through learned updates | Can represent complex, high-dimensional action distributions, but requires multiple denoising steps during inference |

{% include figure.liquid
   path="assets/img/2026-09-23-foundation-models-for-action/diffusion-policy-representations.png"
   class="img-fluid rounded z-depth-1"
   caption="Figure 1: Three approaches to representing robot action distributions. An explicit policy directly predicts an action or distribution parameters; an implicit policy learns an energy function over candidate actions; Diffusion Policy begins from noise and iteratively refines the sample using a learned gradient field. Adapted from Chi et al."
%}

Diffusion Policy <d-cite key="chi2023diffusion"></d-cite> takes the third approach. Instead of treating robot behavior as a single deterministic mapping, it represents a **distribution over possible action sequences** and generates one trajectory through a conditional denoising process. This changes the policy-learning problem from **direct action prediction** to **generative action modeling**. Because the model generates from a distribution, it can represent several distinct behaviors without forcing them into a single averaged prediction.

Diffusion Policy also generates **sequences of actions rather than isolated controls**. This is important because robot actions are temporally dependent: once the robot begins following one strategy, subsequent actions should remain consistent with that decision. Jointly generating a sequence gives the policy a way to model these dependencies and produce coherent trajectories over multiple control steps.


## $\pi_0$: A Vision-Language-Action Flow Model for General Robot Control

This lecture report covers the **Foundation Models for Action** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Topic Overview**: Vision-Language-Action (VLA) models (RT-1, RT-2, OpenVLA) trained on internet-scale multimodal data and cross-embodiment robot demonstrations.

## Cross-Paradigm Comparison

This lecture report covers the **Foundation Models for Action** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Topic Overview**: Vision-Language-Action (VLA) models (RT-1, RT-2, OpenVLA) trained on internet-scale multimodal data and cross-embodiment robot demonstrations.

## Presentation Q&A

This lecture report covers the **Foundation Models for Action** session in *Learning for Interactive Robots (CS 6501, Fall 2026)* at the University of Virginia.

> **Topic Overview**: Vision-Language-Action (VLA) models (RT-1, RT-2, OpenVLA) trained on internet-scale multimodal data and cross-embodiment robot demonstrations.

---

### Report Status

This report is currently being prepared and will be updated by the student reporter team following the lecture session and classroom discussion. Please check back soon!
