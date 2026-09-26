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

Although this resembles a standard supervised learning problem, predicting robot actions introduces several additional challenges. The Diffusion Policy paper highlights three in particular: **multimodal action distributions**, **sequential correlation between actions**, and the need for **high-precision control**.

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

### Diffusion for Robot Actions {#diffusion-for-robot-actions}

Diffusion Policy adapts **denoising diffusion models** to robot control. In a conventional diffusion model, the goal is to learn how to reverse a process that gradually corrupts data with noise. Diffusion Policy applies the same idea to robot behavior: instead of denoising an image, the model denoises an **action sequence**.

During training, the model begins with a clean action chunk from a robot demonstration and adds Gaussian noise at a randomly selected diffusion level. The presentation describes this corruption process as

$$
A^k = \sqrt{\bar{\alpha}_k} A^0
      + \sqrt{1-\bar{\alpha}_k}\epsilon.
$$

Where:

- $$A^0$$ is the original, clean action chunk from the demonstration
- $$A^k$$ is the corrupted version of that action chunk at diffusion step $$k$$
- $$k$$ is the **diffusion timestep**, indicating the current noise level
- $$\bar{\alpha}_k$$ controls how much of the original action signal is retained at diffusion step $$k$$
- $$\epsilon$$ is sampled Gaussian noise
- $$\sqrt{\bar{\alpha}_k}A^0$$ represents the portion of the demonstrated action sequence that remains
- $$\sqrt{1-\bar{\alpha}_k}\epsilon$$ represents the noise added to the action sequence

The network is then trained to predict the noise that was injected into the demonstrated action chunk. The training objective is:

$$
\mathcal{L}
=
\mathbb{E}
\left[
\left\|
\epsilon -
\epsilon_\theta(A^k,o,k)
\right\|^2
\right].
$$

Where:

- $$\mathcal{L}$$ is the loss minimized during training
- $$\mathbb{E}$$ indicates that the loss is averaged across demonstrated action chunks, sampled noise, and different diffusion levels
- $$\epsilon$$ is the actual Gaussian noise that was added
- $$\epsilon_\theta$$ is the neural network trained to predict that noise
- $$\theta$$ denotes the learned parameters of the network
- $$A^k$$ is the corrupted action chunk
- $$o$$ is the observation that provides the robot's current context
- $$k$$ tells the network the current diffusion noise level
- $$\|\cdot\|^2$$ measures the squared error between the true injected noise and the model's prediction

The training problem can therefore be interpreted as **learning to reverse corruption**. Given a noisy action sequence and the robot's current observation, the network learns which part of the sequence should be treated as noise.

At inference time, this process is reversed. There is no demonstrated action chunk to corrupt. Instead, the policy:

1. encodes the current robot observation,
2. initializes a random Gaussian sample with the dimensions of the full action chunk,
3. repeatedly predicts and removes noise over $$K$$ denoising steps, conditioning each step on the observation, and
4. returns the final denoised sequence as a candidate robot action chunk

Here, $$K$$ denotes the total number of iterative denoising steps used to transform the initially random sample into a structured action sequence.

An important consequence of this generative formulation is that **different random initializations can produce different valid behaviors for the same observation**. Rather than collapsing several demonstrated strategies into one average prediction, the diffusion process can generate samples corresponding to different modes of the learned action distribution. <d-cite key="chi2023diffusion"></d-cite>

### Visual Conditioning and Model Architecture {#visual-conditioning-and-model-architecture}

The denoising process described above cannot generate useful robot actions from the noisy action chunk alone. The generated trajectory must also depend on **what the robot currently observes**.

Diffusion Policy therefore models a conditional action distribution

$$
p(A_t \mid O_t),
$$

where:

- $$A_t$$ is the sequence of future actions being generated beginning at robot time $$t$$.
- $$O_t$$ represents the robot's recent observations.
- $$p(A_t \mid O_t)$$ is the probability distribution over possible action sequences conditioned on those observations.

Rather than jointly generating future observations and actions, Diffusion Policy directly generates actions **conditioned on the current observation**. This avoids the additional computational cost of predicting future visual states and makes the formulation more suitable for real-time robot control. 

Visual observations are first passed through a visual encoder to produce a compact representation that can be reused throughout the denoising process. The paper uses a modified **ResNet-18** visual encoder and trains it jointly with the policy. Different camera views are encoded separately and then combined into the observation representation. <d-cite key="chi2023diffusion"></d-cite>

The paper considers two architectures for the noise-prediction network $$\epsilon_\theta$$: a **temporal CNN** and a **Transformer**.

{% include figure.liquid
   path="assets/img/2026-09-23-foundation-models-for-action/diffusion-policy-overview.png"
   class="img-fluid rounded z-depth-1"
   caption="Figure 2: Diffusion Policy overview. The policy conditions repeated denoising of an action sequence on recent robot observations. The paper implements the noise-prediction network using either a temporal CNN with FiLM conditioning or a Transformer with cross-attention. Adapted from Chi et al."
%}

**CNN-based Diffusion Policy.** The CNN implementation applies one-dimensional temporal convolutions along the action sequence. This allows the model to capture local temporal relationships between neighboring actions.

The observation representation is incorporated using **Feature-wise Linear Modulation (FiLM)**. As illustrated in Figure 2, the observation-derived conditioning parameters modify intermediate CNN features during denoising. The diffusion timestep $$k$$ is also provided to the network so that it knows the current noise level.

The CNN-based implementation performed well across many of the evaluated tasks and generally required relatively little task-specific hyperparameter tuning. However, the paper notes that temporal convolution can over-smooth signals when the desired actions change rapidly over time. 

**Transformer-based Diffusion Policy.** The Transformer implementation instead represents the noisy action sequence as a sequence of **action embeddings**. The robot observation is converted into a separate sequence of **observation embeddings**.

Within each Transformer decoder block, **cross-attention** allows the action representations to access information from the observation. In this way, the network can use the current scene and robot state to determine how each component of the noisy action trajectory should be updated. The Transformer also uses causal attention over the action sequence, so each action representation attends only to itself and previous action representations. This preserves the temporal structure of the predicted trajectory.

The Transformer architecture is particularly useful for tasks involving more complex or rapidly changing action sequences. In the paper's state-based experiments, Transformer variants often performed best when task complexity and the rate of action change were high. However, the authors also found the Transformer to be more sensitive to hyperparameter choices than the CNN implementation. <d-cite key="chi2023diffusion"></d-cite>

Both architectures ultimately serve the same role: given the current noisy action sequence, the robot observation, and the diffusion timestep, they predict the noise that should be removed. Repeating this prediction over multiple denoising steps transforms an initially random action chunk into one that is consistent with the robot's current physical context.

### Action Chunking and Receding-Horizon Control {#action-chunking-and-receding-horizon-control}

Diffusion Policy generates **sequences of future actions**, or action chunks, rather than predicting each control independently. In the notation used during the lecture,

$$
A_t = [a_t, \ldots, a_{t+H-1}],
$$

where $$A_t$$ is the action chunk generated at robot time $$t$$, $$a_t$$ is an individual control command, and $$H$$ is the number of future actions in the sequence.

Predicting several actions jointly helps capture **temporal dependence**: once the robot begins following one strategy, later actions should remain consistent with that decision. However, the robot does not execute the entire chunk. Instead, it executes only the first $$h$$ actions, where $$ h \leq H, $$

then receives a new observation and generates another action chunk. This is a form of **receding-horizon control**, in which the policy plans farther ahead than it commits.

A question raised during the lecture was: **Why is $$h \leq H$$? If the robot only executes $$h$$ actions, why generate a longer sequence of $$H$$ actions?**

The two horizons serve different purposes. A longer prediction gives the policy enough temporal context to generate a coherent trajectory, while executing only a shorter prefix allows the robot to re-observe and correct for contact dynamics, sensing noise, or execution error before committing too far into the future.

In the paper's notation, this is described using three horizons: <d-cite key="chi2023diffusion"></d-cite>

- **Observation horizon ($$T_o$$):** number of recent observations given to the policy.
- **Prediction horizon ($$T_p$$):** number of future actions predicted.
- **Action horizon ($$T_a$$):** number of predicted actions executed before replanning.

Thus, the lecture's $$H$$ corresponds conceptually to the prediction horizon, while $$h$$ corresponds to the shorter execution horizon. This creates a trade-off between **temporal consistency and responsiveness**.

{% include figure.liquid
   path="assets/img/2026-09-23-foundation-models-for-action/diffusion-policy-horizon-ablation.png"
   class="img-fluid rounded z-depth-1 mx-auto d-block"
   width="75%"
   max-width="75%"
   caption="Figure 3: Action-horizon and latency ablations for Diffusion Policy. Increasing the action horizon initially improves temporal consistency, but very long execution horizons reduce responsiveness to new observations. The latency experiment evaluates how performance changes when delays are introduced between observation and action execution. Adapted from Chi et al."
%}

The action-horizon ablation demonstrates this trade-off experimentally. Performance initially improves as the action horizon increases, but eventually decreases when the robot remains open-loop for too long. The paper reports that an action horizon of eight steps performed best for most evaluated tasks. <d-cite key="chi2023diffusion"></d-cite>

### Key Properties of Diffusion Policy {#key-properties-of-diffusion-policy}


**Multimodal behavior and temporal consistency.** One of Diffusion Policy's main advantages is its ability to represent multiple valid behaviors without averaging them together. Because inference begins from a random action sample, different rollouts can converge to different modes of the learned action distribution.

The Push-T example illustrates this clearly: from the same state, the robot can move around either the left or right side of the T-shaped block before pushing it toward the target.

{% include figure.liquid
   path="assets/img/2026-09-23-foundation-models-for-action/diffusion-policy-multimodal-behavior.png"
   class="img-fluid rounded z-depth-1 mx-auto d-block"
   width="80%"
   max-width="80%"
   caption="Figure 4: Multimodal behavior in the Push-T task. Diffusion Policy represents both the left and right approaches while committing to a single coherent mode within each rollout. Adapted from Chi et al."
%}

Diffusion Policy also maintains **temporal consistency** by generating an entire action sequence jointly. This prevents consecutive actions from switching between different valid strategies. The paper demonstrates both **short-horizon multimodality**, such as approaching an object from different directions, and **long-horizon multimodality**, where subtasks can be completed in different valid orders.

**Synergy with position control.** Another important design decision is the representation of the robot's actions. Many previous behavior-cloning systems use **velocity control**, where the policy predicts how fast and in what direction the robot should move. Diffusion Policy instead performs particularly well with **position control**, where the policy predicts desired positions directly.

{% include figure.liquid
   path="assets/img/2026-09-23-foundation-models-for-action/diffusion-policy-position-control.png"
   class="img-fluid rounded z-depth-1 mx-auto d-block"
   width="70%"
   max-width="70%"
   caption="Figure 5: Effect of switching from velocity to position control. While the evaluated baseline methods generally lose performance under position control, Diffusion Policy is able to benefit from the position-based action representation. Adapted from Chi et al."
%}

The authors suggest two reasons for this result. First, position-control actions can produce more pronounced multimodality because there may be several different desired positions that lead to successful behavior. Second, position control is less affected by **compounding error** when predicting sequences of future actions. With velocity control, a small error in one predicted velocity changes the resulting position and can affect every later command. Position targets provide a more direct reference for where the robot should move. <d-cite key="chi2023diffusion"></d-cite>

**High-dimensional action-sequence prediction.**  Diffusion models scale well to high-dimensional outputs, allowing Diffusion Policy to predict full action sequences rather than isolated controls. This supports the temporal consistency discussed above and reduces the need to make each decision independently.

Sequence prediction also provides robustness to **idle actions** in demonstrations. During teleoperation, a demonstrator may pause temporarily, creating repeated position commands or near-zero velocities. Single-step behavior-cloning policies can overfit to these pauses and become stuck. By modeling actions as part of a longer sequence, Diffusion Policy can better represent the broader motion surrounding an idle period rather than treating the pause as an isolated target action. 

**Training stability.** Finally, the paper reports that Diffusion Policy is relatively stable to train compared with implicit energy-based policies such as IBC. Energy-based policies often require negative sampling during training and can exhibit unstable evaluation performance even while their training objective decreases. Diffusion Policy instead learns the gradient used to denoise actions without requiring the same normalization procedure, resulting in more consistent training behavior and less task-specific hyperparameter tuning. <d-cite key="chi2023diffusion"></d-cite>

Together, these properties explain why the diffusion representation is useful beyond simply being another way to predict actions. It provides a policy representation that can capture multiple possible behaviors, maintain consistency across time, scale to action sequences, and work effectively with position-based robot control.

### Experiments and Limitations {#experiments-and-limitations}
Diffusion Policy was evaluated across **15 tasks from four robot-manipulation benchmarks**, spanning both simulated and real-world environments. The paper reports an average **46.9% improvement in success rate** over the compared behavior-cloning methods. <d-cite key="chi2023diffusion"></d-cite>

The evaluation includes tasks with different action dimensions, state- and image-based observations, single- and multi-stage manipulation, and both rigid and fluid objects. These results suggest that the benefits of Diffusion Policy are not limited to a single task or setting. 

Despite these results, the method has two important limitations.

**Dependence on demonstration data.** Because Diffusion Policy is trained through behavior cloning, its performance still depends on the quality and coverage of the demonstrations. Inadequate demonstration data can lead to poor performance even if the action distribution is modeled effectively.

**Inference latency.** Diffusion Policy requires **multiple denoising steps during inference**, making it more computationally expensive than policies that generate actions in a single forward pass. The authors use DDIM to reduce the number of inference iterations, but the paper notes that the remaining computational cost may still be too high for tasks requiring very high-rate control. 

Overall, the experiments provide broad evidence for Diffusion Policy across a range of manipulation tasks, while its reliance on demonstration data and iterative inference remain important limitations for real-time deployment.

**Additional resource.** The presenting team also recommended [*Diffusion Policy: LeRobot Research Presentation #2 by Cheng Chi*](https://www.youtube.com/watch?v=M03sZFfW-qU) for a more detailed walkthrough of the method and its design choices.

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
