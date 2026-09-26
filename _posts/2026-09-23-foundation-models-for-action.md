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

### Current Problem and Introduction:
Developing robot foundation models have a few major challenges: Research must be completed at a large scale, model architectures must effectively make use of diverse data sources while representing subtleties, and pre-training and post-training ratios and procedures are hard to curate. $\pi_0$ solves these issues by proposing a design that fine-tunes a VLM (vision-language model) to produce actions via flow matching.

### $\pi_0$ Model
{% include figure.liquid 
   path="assets/img/2026-09-23-foundation-models-for-action/pi0_framework.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 1: Pre-training mixture trains the flow matching VLA model, which then initializes the weights from PaliGemma. The resulting $\pi_0$ model is used to control various robot embodiments to control a wide array of tasks." 
%}
In their training framework, they assemble a pre-training mixture of datasets from 7 different robot configurations, 68 different tasks, and 22 robots. The pre-training phase trains a base model that exhibits generalization, and can follow basic language commands, but the paper employs a post-training procedure to help adapt the model to more specific, complex downstream tasks. The paper uses the pre-training mixture, as shown in Figure 1, to train the flow-matching VLA model. This consists of the larger VLM backbone and a smaller action expert. The VLM backbone is initialized from PaliGemma-VLM, which provides representations from large-scale Internet pre-training for vision and text encodings. They further augment this backbone with robotics-specific inputs and outputs, using conditional flow matching. Conditional flow matching models the continuous distribution of action sequencing and provides high precision and modeling capability. Another interesting note is that they use a separate set of weights for the robotics-specific tokens, specifically one set for image or text inputs and one from robot-specific inputs or outputs.

### Generating Actions with Conditional Flow Matching
Given camera images, a language instruction, and the robot’s joint positions, $\pi_0$ generates a chunk $\mathbf{A}_t$ of 50 future actions. Instead of predicting these actions directly, the action expert uses conditional flow matching to transform a noisy action sequence $\mathbf{A}_t^\tau$ into a coherent robot trajectory. $\ep$ is the Gaussian noise, $o$ is context, and $\tau$ runs from $0$ to $1$, so from noise to action:  

$$
L^\tau(\theta)
=
\mathbb{E}
\left[
\left \|
\mathbf{v}_\theta(\mathbf{A}_t^\tau, \mathbf{o}_t)
-
\mathbf{u}(\mathbf{A}_t^\tau \mid \mathbf{A}_t)
\right\|^2
\right]
$$

Here, $\mathbf{v}_\theta$ is the model’s predicted direction from the noisy actions toward the final trajectory, while $\mathbf{u}$ is the target direction derived from the demonstrated actions. Minimizing their squared difference teaches $\pi_0$ to iteratively transform noisy chunks into smooth actions that are consistent with the robot’s observations and language instruction.

After learning how flow matching learns a transport velocity, the paper discusses how the flow inference gets integrated into the action field using the forward Euler integration rule.
$$
\mathbf{A}^{\tau + \Delta \tau}
=
\mathbf{A}^{\tau}
+
\Delta \tau \cdot
\mathbf{v}_{\theta}\left(\mathbf{A}^{\tau}, \mathbf{o}, \tau\right)
$$

Here, $v_{\theta}$ predicts how each component of the candidate chunk should change, $\Delta\tau$ represents a small step in generation time. Each Euler step is one completion of the update, multiplied by $\Delta\tau$, then added to the current chunk.

### Experiment and Evaluation
{% include figure.liquid 
   path="assets/img/2026-09-23-foundation-models-for-action/pi0_results.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 2: The full pre-trained $\pi_0$ model attains more than 50% of the maximum score across all the tasks.Out-of-box pre-training means the model was only pre-trained, as opposed to both pre-trained + fine-tuned, and only finetuned. A score of 1.0 represents perfect execution." 
%}
The paper collects data from a wide range of objects and environments, but the data was only gathered from one or two cameras and with low frequency control. To learn more complex tasks, the paper collected over 10,000 hours worth of data completing these complex tasks, which could look like throwing many specific items into the garbage. As mentioned earlier, they used seven different robot types, with varying numbers of cameras and kinematic properties. They run a few sets of experiments, such as seeing how $\pi_0$ performs after only pre-training, how well $\pi_0$ adapts to complex tasks, specifically for dexterous tasks.

As shown in Figure 2, $\pi_0$ outperformed all other ablated $\pi_0$ models for tasks present in pre-training. The fully pre-trained $\pi_0$ model attains more than 50% of the maximum score across all of the tasks. The results show that many of the difficult tasks show large improvement from using the pre-trained model, showing that pre-training is especially useful with harder tasks.

### Limitations and Open Challenges
Although the paper tested with various robot embodiments during training, and found that $\pi_0$ was able to generalize skills to complete these new tasks through fine-tuning, $\pi_0$ is not able to generalize to a truly unseen robot. This paper does not provide a clean zero-shot evaluation where an entire robot is omitted during pretraining, and then deployed on a completely unseen robot. Additionally, $\pi_0$ is not tested for in-context learning, which could be an interesting to conduct research on in the future. 

## Cross-Paradigm Comparison

The two foundation model paradigms discussed during lecture shared similar ideas to train large-scale unlabeled data, yet they exhibit complementary strengths and trade-offs for robotics:

| Dimension | Diffusion Policy | $\pi_0$ |
| :--- | :--- | :--- |
| **Pre-training Data** | 400M–1B static (image, text) pairs from the web | 22M video clips (unlabeled) |
| **Objective** | Natural language text captions (weakly supervised) | Masked spatiotemporal video tokens (self-supervised) |
| **Denoising Function** | Contrastive loss: InfoNCE (CLIP) or Sigmoid (SigLIP) | Smooth $$L_1$$ latent regression against EMA target |
| **Representational Prior** | High-level semantic categorization & open-vocabulary concepts | Temporal causality, dynamics, and visual object permanence |
| **Action Awareness** | None (static scene snapshots) | Action-conditioned post-training (DROID 7D end-effector deltas) |
| **Inference Mechanism** | Zero-shot cosine similarity matching against text prompts | Latent Model Predictive Control (CEM) |
| **Primary Robotic Use** | High-level task planning, object retrieval, open-world detection | Trajectory planning, visual affordance prediction |
## Presentation Q&A

During the lecture, several technical questions were raised by the presenting team concerning the capabilities of VLAs:

**Question 1:** Do you expect VLAs (vision-language-action models) to exhibit the same scaling properties (neural scaling laws) as LLMs? Why or why not?  

**Question 2:** Do you expect VLAs to be a sufficient approach to master all physical intelligence tasks?  

**Question 3:** Do you think backpropagating through the LLM during VLA training could improve learned representations of the LLM?  
