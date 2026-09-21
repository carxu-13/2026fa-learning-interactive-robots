---
layout: distill
title: "Foundation Models for Vision"
description: "Pre-trained vision foundation models (CLIP, SigLIP, V-JEPA 2) and their latent representations for embodied robotics perception and planning."
date: 2026-09-16
future: true
htmlwidgets: true

# Authors
authors:
  - name: "Yen-Ling Kuo"
    url: "https://yenlingkuo.com"
    affiliations:
      name: "University of Virginia"

bibliography: 2026-09-16-foundation-models-for-vision.bib

toc:
  - name: "Introduction & Motivation"
  - name: "Robot Vision vs. Computer Vision"
  - name: "Language-Supervised Representations: CLIP to SigLIP"
    subsections:
      - name: "Contrastive Learning with CLIP"
      - name: "The Softmax Bottleneck"
      - name: "SigLIP: Pairwise Sigmoid Loss"
  - name: "Latent Predictive World Models: V-JEPA 2"
    subsections:
      - name: "The JEPA Philosophy: Latent vs. Pixel Prediction"
      - name: "Architecture & Target Stabilization via EMA"
      - name: "V-JEPA 2-AC: Action-Conditioned World Model"
      - name: "Planning via Latent Energy Minimization"
  - name: "Cross-Paradigm Comparison"
  - name: "Classroom Discussions & Student Q&A"
  - name: "Critical Analysis, Limitations & Future Directions"
  - name: "References"
---

## Introduction & Motivation

Autonomous robots operating in unstructured, human-centric environments must continuously perceive and interpret dynamic scenes to make reliable decisions. While humans effortlessly integrate multimodal senses—vision, touch, audition, proprioception, and smell—robotic systems rely on electronic transducers such as RGB cameras, depth sensors, LiDAR, and tactile arrays. Among these modalities, **vision** provides the highest spatial bandwidth and rich semantic information about the world.

Historically, computer vision in robotics relied on supervised learning over closed, pre-defined label sets (e.g., ImageNet classification, COCO bounding boxes). However, this paradigm exhibits fundamental limitations when deployed on physical robots:
1. **The Closed-World Assumption**: Real-world environments are inherently open-ended; pre-training on fixed categories fails to capture novel objects, diverse tool affordances, or varied user instructions.
2. **Annotation Bottleneck**: Manually annotating millions of robotic manipulation scenes is prohibitively expensive, fragile, and geographically constrained.
3. **Task-Agnostic Semantics vs. Physical Dynamics**: Conventional visual encoders capture static object semantics ("what an object is") but discard crucial physical dynamics ("how the world changes under interaction").

To overcome these barriers, modern robot learning increasingly leverages **Vision Foundation Models**—large neural networks pre-trained on massive, diverse datasets using self-supervised or weakly supervised objectives. In this lecture, we investigate two major paradigms:
- **Language-Supervised Visual Foundations**: Learning semantic, open-vocabulary visual representations via web-scale multimodal alignment (**CLIP** <d-cite key="radford2021learning"></d-cite> and **SigLIP** <d-cite key="zhai2023sigmoid"></d-cite>).
- **Self-Supervised Latent Predictive World Models**: Learning intuitive physical dynamics and temporal causality directly from internet video in latent representation space (**V-JEPA 2** <d-cite key="assran2025vjepa2"></d-cite> and its action-conditioned extension **V-JEPA 2-AC**).

---

## Robot Vision vs. Computer Vision

A critical conceptual theme emphasized in lecture is that **vision for robotics differs fundamentally from traditional computer vision**:

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/robot-vision-situated.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 1: Standard computer vision analyzes curated static images, whereas robot vision is fundamentally embodied, active, and environmentally situated (adapted from UT Austin CS391R; Brooks 1991; Bajcsy 2018; Zeng et al. 2018)." 
%}

Following the foundational perspectives of Rodney Brooks <d-cite key="brooks1991intelligence"></d-cite> and Ruzena Bajcsy <d-cite key="bajcsy2018revisiting"></d-cite>, robotic vision possesses three distinguishing traits:

1. **Embodied**: The robot has a physical morphology and physically occupies space. Visual observations are tightly coupled to the robot's proprioceptive state and kinematic actuators. Every motor command alters the camera perspective, and collisions or contacts create immediate physical and sensory feedback.
2. **Active**: Rather than passively processing static images uploaded to a server, a robot is an *active perceiver*. It chooses where to look, moves its end-effector to resolve occlusions, or intentionally pushes a pile of cluttered objects to inspect hidden grasp candidates <d-cite key="zeng2018robotic"></d-cite>. Perception is purposeful and driven by downstream task goals.
3. **Situated**: The robot operates in the "here and now" of the physical world. The representations cannot remain detached, abstract labels; they must ground spatial geometry, affordances, physical support relationships, and real-time temporal contingencies under latency constraints.

---

## Language-Supervised Representations: CLIP to SigLIP

### Contrastive Learning with CLIP

The first foundational breakthrough in open-vocabulary vision is **CLIP** (Contrastive Language-Image Pre-training) <d-cite key="radford2021learning"></d-cite>. Instead of categorizing images into 1,000 fixed ImageNet classes, CLIP trains on 400 million (image, text) pairs harvested from the public internet.

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/clip-contrastive-pretraining.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 2: Contrastive pre-training and zero-shot inference in CLIP (Radford et al., 2021). An image encoder and text encoder jointly embed visual and textual inputs into a unified latent space via cosine similarity maximization." 
%}

#### Mathematical Formulation
Let a mini-batch contain $$N$$ matched pairs $$\{(\mathbf{x}_i^I, \mathbf{x}_i^T)\}_{i=1}^N$$. An image encoder $$f_I$$ and a text encoder $$f_T$$ produce representations that are projected and $$L_2$$-normalized:

$$
\mathbf{z}_i^I = \frac{f_I(\mathbf{x}_i^I)}{\|f_I(\mathbf{x}_i^I)\|_2}, \quad \mathbf{z}_j^T = \frac{f_T(\mathbf{x}_j^T)}{\|f_T(\mathbf{x}_j^T)\|_2}
$$

The pairwise cosine similarity matrix is given by $$s_{i,j} = \mathbf{z}_i^I \cdot \mathbf{z}_j^T$$, and the scaled logits are $$\ell_{i,j} = s_{i,j} / \tau$$, where $$\tau$$ is a learnable temperature parameter. CLIP optimizes a symmetric **InfoNCE** cross-entropy loss:

$$
\mathcal{L}_{\text{CLIP}} = \frac{1}{2N} \sum_{i=1}^N \left( - \log \frac{\exp(\ell_{i,i})}{\sum_{j=1}^N \exp(\ell_{i,j})} - \log \frac{\exp(\ell_{i,i})}{\sum_{j=1}^N \exp(\ell_{j,i})} \right)
$$

For inference, zero-shot classification is performed by embedding class names formatted into prompt templates (e.g., `"a photo of a {label}"`) and selecting the label whose text embedding maximizes cosine similarity with the query image embedding:

$$
\hat{y} = \arg\max_{c \in \{1, \dots, C\}} \left( \mathbf{z}_{\text{test}}^I \cdot \mathbf{z}_c^T \right)
$$

---

### The Softmax Bottleneck

While CLIP achieves impressive zero-shot transfer, its **softmax-based normalization** presents significant computational and architectural bottlenecks:

1. **Global Inter-Device Communication**: Evaluating the denominator $$\sum_{j=1}^N \exp(\ell_{i,j})$$ requires computing the full $$N \times N$$ similarity matrix. In distributed multi-GPU / multi-node setups, this necessitates an expensive `AllGather` collective communication operation across all worker ranks at every training step.
2. **Memory Scaling**: Storing the full similarity matrix and backward pass activation graph scales quadratically ($$\mathcal{O}(N^2)$$), severely restricting maximum batch sizes.
3. **Numerical Instability**: Exponentiating large dot products requires custom numerical stabilization (such as online max-subtraction tricks) to avoid float overflow.

---

### SigLIP: Pairwise Sigmoid Loss

To overcome the softmax bottleneck, **SigLIP** (Sigmoid Loss for Language Image Pre-Training) <d-cite key="zhai2023sigmoid"></d-cite> introduces an elegant reformulation: **replace the global multi-class softmax with independent pairwise sigmoid binary classifications**.

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/siglip-vs-clip-loss.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 3: Algorithmic comparison between standard Softmax contrastive loss (left) and SigLIP's pairwise Sigmoid loss (right). SigLIP treats each image-text cell as an independent binary classification task (Zhai et al., ICCV 2023)." 
%}

Instead of normalizing across the entire batch, SigLIP treats each cell $$(i, j)$$ in the $$N \times N$$ matrix as an independent binary classification problem: *Does image $$i$$ match text $$j$$?*

#### Mathematical Formulation
Define the label $$y_{i,j} \in \{-1, +1\}$$:

$$
y_{i,j} = \begin{cases} +1 & \text{if } i = j \text{ (positive pair)} \\ -1 & \text{if } i \neq j \text{ (negative pair)} \end{cases}
$$

The SigLIP loss is defined as:

$$
\mathcal{L}_{\text{SigLIP}} = - \frac{1}{N} \sum_{i=1}^N \sum_{j=1}^N \log \sigma \left( y_{i,j} (t \cdot (\mathbf{z}_i^I \cdot \mathbf{z}_j^T) + b) \right)
$$

where $$\sigma(u) = \frac{1}{1 + e^{-u}}$$, $$t$$ is a learnable scale parameter, and $$b$$ is a learnable bias term.

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/siglip-scaling-performance.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 4: SigLIP enables scaling to massive batch sizes without inter-device all-gather communication bottlenecks, outperforming standard CLIP on zero-shot ImageNet across compute budgets (Zhai et al., 2023)." 
%}

#### Key Advantages of SigLIP
- **Decoupled Computation & Memory Efficiency**: Because each pair is independent, gradients can be accumulated chunk-by-chunk without gathering all image/text embeddings across all devices into a single monolithic matrix.
- **Extreme Batch Sizes**: SigLIP easily scales to batch sizes of $$32\text{k}$$, $$64\text{k}$$, or higher, leading to faster throughput and better zero-shot classification accuracy.
- **Robustness to Web Label Noise**: In real-world web data, multiple captions in a mini-batch can be valid descriptions for the same image (e.g., "a golden retriever" and "a cute dog playing in the grass"). Softmax penalizes all non-diagonal pairs as hard negatives, forcing false competition. SigLIP's independent sigmoid gates avoid artificially suppressing complementary, valid text descriptions.

---

## Latent Predictive World Models: V-JEPA 2

While CLIP and SigLIP provide rich semantic features for static object recognition, physical robot manipulation requires understanding **temporal dynamics, physics, and causal consequences of action**. 

### The JEPA Philosophy: Latent vs. Pixel Prediction

A common approach in self-supervised video learning is pixel-level reconstruction (e.g., Video Masked Autoencoders, diffusion models). However, pixel reconstruction forces the neural network to spend immense representational capacity predicting high-frequency visual noise (e.g., carpet textures, foliage swaying in the background, sensor flicker) that is completely irrelevant to robotic manipulation.

To address this, Yann LeCun proposed the **Joint Embedding Predictive Architecture (JEPA)**. The core philosophy of JEPA is:
> **Do not predict pixels. Predict missing or future content directly in an abstract latent feature space.**

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/vjepa2-pipeline.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 5: The two-stage V-JEPA 2 pipeline: (1) Self-supervised actionless video pre-training on 22 million in-the-wild videos; (2) Post-training with frozen encoders on robot demonstration data (DROID) for action-conditioned predictive world modeling and planning (Assran et al., 2025)." 
%}

---

### Architecture & Target Stabilization via EMA

**V-JEPA 2** <d-cite key="assran2025vjepa2"></d-cite> scales latent predictive pre-training to **22 million in-the-wild videos** and over **1 billion parameters** using Vision Transformers (ViT).

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/vjepa2-architecture.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 6: V-JEPA 2 architecture. Spatiotemporal video tubes are patchified. A context encoder processes visible tokens, while a lightweight predictor regresses the target encoder's latent representations of masked spatiotemporal patches. An Exponential Moving Average (EMA) and stop-gradient prevent representation collapse." 
%}

#### Operational Steps
1. **Spatiotemporal Patchification**: An input video clip is split into spatiotemporal tubes (e.g., $$2 \times 16 \times 16$$ pixels).
2. **Masking**: Large 3D spatiotemporal blocks are dropped. The context encoder $$f_\phi$$ only processes the visible unmasked tokens.
3. **Predictor**: A lightweight transformer $$g_\theta$$ takes the context token representations concatenated with learnable mask tokens and predicts the latent representations corresponding to the masked regions:

$$
\hat{\mathbf{z}}_m = g_\theta(f_\phi(\mathbf{x}_{\text{context}}), m)
$$

4. **Objective**: The predictor is trained with a smooth $$L_1$$ regression loss against target representations $$\mathbf{z}_m^*$$:

$$
\mathcal{L}_{\text{V-JEPA}} = \frac{1}{|\mathcal{M}|} \sum_{m \in \mathcal{M}} \|\hat{\mathbf{z}}_m - \mathbf{z}_m^*\|_1
$$

#### Preventing Representation Collapse: Stop-Gradient and EMA
In a self-supervised setup where both the context encoder and target encoder are parameterized by neural networks, a trivial solution exists: the encoders could output a constant vector $$\mathbf{z} = \mathbf{0}$$ for all inputs, trivially achieving zero loss.

To prevent representation collapse, V-JEPA 2 employs an **Exponential Moving Average (EMA) target encoder** with a **stop-gradient**:
- Gradients do **not** backpropagate through the target encoder: $$\mathbf{z}_m^* = \text{stop\_gradient}(f_{\bar{\phi}}(\mathbf{x}_m))$$.
- The target parameters $$\bar{\phi}$$ are updated slowly over time as a convex combination of previous target parameters and current student parameters $$\phi$$:

$$
\bar{\phi}_t \leftarrow \alpha \bar{\phi}_{t-1} + (1 - \alpha) \phi_t, \quad \alpha \in [0.99, 0.999]
$$

This ensures that the target encoder provides a smoothly evolving, stable supervisory signal rather than a rapidly oscillating moving target.

---

### V-JEPA 2-AC: Action-Conditioned World Model

Pre-training on internet video is strictly **actionless**—the model observes passive human videos without knowing what physical forces or motor commands caused the movements. To make V-JEPA 2 actionable for robotics, the authors propose **V-JEPA 2-AC (Action-Conditioned)**.

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/vjepa2-ac-world-model.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 7: V-JEPA 2-AC architecture. The visual encoder is frozen. A causal transformer predictor takes the current visual tokens and candidate robot action deltas to autoregressively predict future latent states under block-causal attention." 
%}

#### Post-Training Setup
1. **Frozen Visual Encoder**: The pre-trained V-JEPA 2 visual backbone is frozen, preserving its rich visual feature representations.
2. **Action Representation**: Robot trajectories are drawn from the **DROID** dataset <d-cite key="khazatsky2024droid"></d-cite> (62 hours of diverse manipulation video). At each step $$k$$, the action $$\mathbf{a}_k \in \mathbb{R}^7$$ represents the real-valued Cartesian end-effector delta pose (position $$\Delta x, \Delta y, \Delta z$$, rotation $$\Delta \text{roll}, \Delta \text{pitch}, \Delta \text{yaw}$$, and gripper state).
3. **Block-Causal Predictor**: An action-conditioned transformer predictor processes initial state tokens $$\mathbf{s}_0$$ and action tokens $$\mathbf{a}_{0:T-1}$$ using a block-causal attention mask to prevent information leakage from future frames.

#### Autoregressive Rollout Loss
To combat compounding errors during multi-step planning rollouts, the model is trained with both single-step and autoregressive multi-step rollout losses:

$$
\mathcal{L}_{\text{AC}} = \sum_{t=1}^H \|\hat{\mathbf{s}}_t - \mathbf{s}_t^*\|_1, \quad \text{where } \hat{\mathbf{s}}_t = P_\theta(\hat{\mathbf{s}}_{t-1}, \mathbf{a}_{t-1})
$$

---

### Planning via Latent Energy Minimization

At test time, V-JEPA 2-AC acts as an internal visual simulator, allowing the robot to "imagine" the physical consequences of actions without executing them on the real hardware.

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/vjepa2-planning-rollout.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 8: Planning with V-JEPA 2-AC via Model Predictive Control. Candidate action sequences are sampled from a Gaussian distribution, rolled out in latent space, and iteratively refined using the Cross-Entropy Method to minimize the L1 distance to the goal image embedding." 
%}

Given a visual goal image $$I_g$$ and the current observation $$I_0$$, planning proceeds via **Model Predictive Control (MPC)** using the **Cross-Entropy Method (CEM)**:

1. Encode the target goal: $$\mathbf{z}_g = f(I_g)$$.
2. Sample $$K$$ candidate action trajectories $$\mathbf{a}_{0:T-1}^{(k)} \sim \mathcal{N}(\boldsymbol{\mu}, \boldsymbol{\Sigma})$$.
3. Roll out each candidate trajectory through the latent world model to obtain the predicted final state $$\hat{\mathbf{s}}_T^{(k)}$$.
4. Compute the latent energy (distance to goal):

$$
\mathcal{E}\left(\mathbf{a}_{0:T-1}^{(k)}\right) = \|\hat{\mathbf{s}}_T^{(k)} - \mathbf{z}_g\|_1
$$

5. Select the top $$M$$ elite candidates with lowest energy, update the distribution parameters $$(\boldsymbol{\mu}, \boldsymbol{\Sigma})$$, and repeat for several iterations.
6. Execute the first action $$\mathbf{a}_0$$ of the converged trajectory on the robot, observe the new camera frame, and replan (receding horizon control).

{% include figure.liquid 
   path="assets/img/2026-09-16-foundation-models-for-vision/vjepa2-goal-reaching.png" 
   class="img-fluid rounded z-depth-1" 
   caption="Figure 9: Zero-shot goal reaching and manipulation with V-JEPA 2-AC across different robotic platforms and laboratory setups (Assran et al., 2025)." 
%}

---

## Cross-Paradigm Comparison

The two foundation model paradigms discussed during lecture exhibit complementary strengths and trade-offs for embodied robotics:

| Dimension | Language-Supervised (CLIP / SigLIP) | Latent Predictive (V-JEPA 2 / V-JEPA 2-AC) |
| :--- | :--- | :--- |
| **Pre-training Data** | 400M–1B static (image, text) pairs from the web | 22M in-the-wild video clips (unlabeled) |
| **Supervisory Signal** | Natural language text captions (weakly supervised) | Masked spatiotemporal video tokens (self-supervised) |
| **Loss Function** | Contrastive loss: InfoNCE (CLIP) or Sigmoid (SigLIP) | Smooth $$L_1$$ latent regression against EMA target |
| **Representational Prior** | High-level semantic categorization & open-vocabulary concepts | Temporal causality, physical mechanics, and visual object permanence |
| **Action Awareness** | None (static scene snapshots) | Action-conditioned post-training (DROID 7D end-effector deltas) |
| **Inference Mechanism** | Zero-shot cosine similarity matching against text prompts | Latent Model Predictive Control (CEM / MPPI optimization) |
| **Primary Robotic Use** | High-level task planning, object retrieval, open-world detection | Closed-loop trajectory rollout, visual affordance prediction, servoing |

---

## Classroom Discussions & Student Q&A

During the lecture, several deep technical questions were raised by students regarding model inductive biases, loss mechanics, and robotics deployment:

### Q1: Why does SigLIP's independent binary classification improve robustness against web data noise?
> **Student Question**: *The lecture mentioned that SigLIP improves robustness against noisy training data compared to CLIP. What is the mathematical intuition behind this?*

**Discussion & Instructor Synthesis**:
In large-scale web scrapes, the mapping between images and text is rarely one-to-one. For example, given a picture of a brown tabby cat, several captions in the same batch could be completely true (e.g., *"a domestic cat"*, *"a brown pet on the sofa"*, *"feline resting"*). 

Under CLIP's multi-class softmax loss, all off-diagonal entries are treated as mutually exclusive negatives. The softmax denominator forces a competitive zero-sum normalization across the mini-batch; hence, having other semantically valid captions in the batch actively penalizes the model and destabilizes gradients. In contrast, SigLIP frames every pair $$(i, j)$$ as an independent binary decision. If multiple captions match the visual scene, their positive sigmoid activations do not artificially suppress one another, dramatically boosting tolerance to label ambiguity and web caption noise.

---

### Q2: Does SigLIP improve genuine representation alignment, or merely zero-shot task metrics?
> **Student Question**: *The paper highlights strong zero-shot ImageNet numbers, but does that actually indicate better geometric alignment between visual and language representations? Also, how does this relate to CLIP score?*

**Discussion & Instructor Synthesis**:
In high-dimensional representation spaces, measuring true geometric "alignment" is computationally difficult and lacks a single scalar definition. Consequently, the field predominantly relies on downstream zero-shot accuracy as an operational proxy for alignment—if visual tokens and text tokens align well, zero-shot nearest-neighbor retrieval and classification improve.

Regarding **CLIP score**: In generative modeling (e.g., Stable Diffusion), practitioners commonly use pre-trained CLIP encoders as a frozen perceptual judge to evaluate image-text fidelity. However, when evaluating pre-training methods like SigLIP, the objective is establishing whether the learned manifold itself exhibits superior transferability and linear separability across diverse visual distributions.

---

### Q3: Why does Meta develop both DINOv2 and V-JEPA? Why not combine them into a single foundation model?
> **Student Question**: *Meta AI has published DINO, DINOv2, SAM, and now V-JEPA 2. Why are these maintained as separate models rather than unified into a single mega-foundation model?*

**Discussion & Instructor Synthesis**:
While uniting all perceptual capabilities into one model is an appealing vision, multi-objective pre-training often suffers from **gradient conflict**:
- **DINOv2** <d-cite key="oquab2023dinov2"></d-cite> optimizes self-distillation over multi-crop static images to learn dense, patch-level geometric and semantic descriptors.
- **Segment Anything (SAM)** optimizes promptable spatial mask prediction for boundary delineation.
- **V-JEPA 2** <d-cite key="assran2025vjepa2"></d-cite> optimizes spatiotemporal predictive transitions to learn an intuitive physics world model.

When these distinct loss functions are optimized jointly in a shared backbone, the objectives frequently compete, degrading specialized downstream capabilities. Furthermore, static images lack temporal arrows of time, while video datasets often exhibit lower per-frame resolution and spatial diversity. Maintaining specialized representations (spatial/dense vs. dynamic/temporal) remains more effective until scalable multi-task architectures are developed.

---

### Q4: What is the role of EMA and stop-gradient in V-JEPA?
> **Student Question**: *In the V-JEPA diagram, what does the EMA block do, and why is there a stop-gradient?*

**Discussion & Instructor Synthesis**:
In self-supervised predictive architectures without negative pairs (unlike contrastive learning), representation collapse is a constant danger. If gradients flowed freely into the target encoder, the network could trivially minimize $$L_1$$ loss by collapsing all representations to a constant scalar $$\mathbf{z} = \mathbf{0}$$.

By cutting gradients (`stop_gradient`) on the target branch and updating the target encoder solely via **Exponential Moving Average (EMA)** of the context encoder's weights, the target representations remain stable over long optimization trajectories. This prevents the "dog chasing its own tail" instability, ensuring the predictor learns non-trivial representations of scene dynamics.

---

### Q5: How do we transition from actionless video representations to physical robot execution?
> **Student Question**: *V-JEPA 2 is pre-trained on passive YouTube videos without action logs. How does the robot actually execute physical tasks at test time?*

**Discussion & Instructor Synthesis**:
Passive internet video provides rich priors on object permanence, liquid flow, deformation, and temporal causality, but it contains no motor commands or joint angles. V-JEPA bridges this through **V-JEPA 2-AC**:
1. The video encoder is frozen as an observational feature extractor.
2. A lightweight action-conditioned causal transformer is trained on a smaller dataset of real robot teleoperation demonstrations (**DROID**).
3. At test time, control is framed as **latent Model Predictive Control**: candidate motor sequences are sampled and rolled out inside the model's imagination, and the action trajectory that best matches the goal state embedding is executed.

---

## Limitations & Future Directions

While SigLIP and V-JEPA 2 represent major advancements, several foundational challenges remain before these models can fully support robust, closed-loop interactive robots:

### 1. Sensitivity to Camera Extrinsics & Coordinate Ambiguity
In V-JEPA 2-AC, actions are expressed as 7D Cartesian end-effector deltas. If the robot's physical mounting base is outside the camera's field of view, the model struggles to infer the camera-to-robot coordinate frame transformation, leading to directional errors during closed-loop visual servoing.

### 2. Compounding Errors in Autoregressive Rollouts
Although V-JEPA 2-AC introduces multi-step rollout losses during post-training, latent predictions over extended time horizons still suffer from compounding drift. For horizons longer than 15–20 steps, the imagined latent state diverges from real-world physics, limiting the model to short-horizon primitives (e.g., reaching, grasping, pushing) rather than complex, multi-stage manipulation plans.

### 3. Curse of Dimensionality in Sampling-Based Planning
Planning via CEM or MPPI requires evaluating hundreds of candidate action sequences. As task horizons grow, the volume of the search space grows exponentially. Without a learned policy prior to guide action proposals, purely random Gaussian sampling becomes computationally intractable for high-frequency control.

### 4. Goal Specification: Image Goals vs. Multimodal Instructions
V-JEPA 2-AC currently requires an **image goal** ($$I_g$$) to define the task. In human-robot interaction, providing an exact image of the desired future state is unnatural and often impossible (e.g., asking a robot to *"find my keys"* or *"clean the kitchen"*). Integrating language-aligned models (like SigLIP) with latent predictive world models (like V-JEPA) to enable **language-conditioned latent planning** is an active and promising research frontier.

---