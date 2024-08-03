# Curve Simplification

## Project Overview

This project focuses on simplifying and analyzing curves by assigning weights to each control point. The main objective is to reduce the number of control points while preserving the overall shape and key characteristics of the curve. This method is applicable in various domains, including graphics, geometry, and scientific data representation.

![simplification_animation](https://github.com/user-attachments/assets/98a85ea2-4d0c-481e-a3cf-3b650d87e2d4)


## Objective

- **Reduce control points**: Minimize the number of control points without significantly altering the curve's shape.
- **Quantify point importance**: Determine the relative importance of each control point to guide curve simplification.

## Spline Curve Concept

### Introduction to Spline Curves

In the context of curve simplification, the concept of spline curves is crucial. **Spline curves** are not merely a series of straight lines connecting points; they are smooth curves that allow for more complex shapes. This is achieved by introducing intermediate control points called **Spline Points** $S_i$ between each pair of main control points $P_i$ and $P_{i+1}$.

- **Spline Points $S_i$**: These are additional control points that provide curvature to the curve between two main control points. These points are always present and cannot be simplified away without affecting the curve's shape.

- **Curve Segment**: If a spline point $S_i$ lies directly on the segment $[P_i, P_{i+1}]$, that segment is a straight line. Otherwise, a spline is created.

For initial simplification, we assume $S_i$ lies on the perpendicular bisector of the segment $[P_i, P_{i+1}]$. The spline point can move along this bisector, allowing for various curve shapes. This ensures that between every two main control points, there is an intermediate spline point that contributes to the curvature of the curve.

### Constructing the Curve Gamma

To start constructing spline curves in MATLAB or Python, we utilize the list of control points $P = [P_1, \cdots, P_n]$. From this list, we derive the list $S$ of spline control points.

- **Spline Control Point $S_i$**: Each spline control point is associated with a real number $s_i$ that defines its position along the perpendicular bisector of the segment $[P_i, P_{i+1}]$.

  - If $s_i = 0$, the spline point lies on the segment $[P_i, P_{i+1}]$, resulting in a straight line segment.
  - If $s_i \neq 0$, a spline is created between $P_i$, $S_i$, and $P_{i+1}$. The sign of $s_i$ indicates the direction of movement relative to the segment.

By adjusting these $s_i$ values, we can create various complex curves. The following sections detail how to calculate these control points and use them to simplify curves.

## Weight Measure $W_i$

The weight measure $W_i$ evaluates the importance of each control point $P_i$ on a curve using three primary factors: curvature, angle, and perpendicular distance.

### 1. Curvature ($\kappa$)

Curvature measures how much a curve changes direction at a given point. A point with high curvature significantly contributes to the local shape of the curve.

#### Curvature Formula

The curvature $\kappa_i$ at point $P_i$ is calculated using the area of the triangle formed by $P_{i-1}$, $P_i$, and $P_{i+1}$.

$$
\kappa_i = \frac{2 \cdot \text{Area}(P_{i-1}, P_i, P_{i+1})}{\|P_{i-1} - P_i\| \cdot \|P_{i+1} - P_i\| \cdot \|P_{i+1} - P_{i-1}\|}
$$

**Where**:
- $\text{Area}(P_{i-1}, P_i, P_{i+1})$ is the area of the triangle determined by these three points.

### 2. Angle ($\theta$)

The angle between two adjacent segments of the curve indicates the directional change at a point. Points with sharp angles are more significant.

#### Angle Formula

The angle $\theta_i$ is calculated between the vectors formed by $[P_{i-1}, P_i]$ and $[P_i, P_{i+1}]$.

$$
\theta_i = \cos^{-1}\left(\frac{(P_{i} - P_{i-1}) \cdot (P_{i+1} - P_i)}{\|P_{i} - P_{i-1}\| \cdot \|P_{i+1} - P_i\|}\right)
$$

**Where**:
- $\cdot$ represents the dot product.
- $\|\cdot\|$ is the Euclidean norm (vector length).

### 3. Perpendicular Distance ($d$)

The perpendicular distance measures the deviation of a point from the straight line connecting its immediate neighbors. A point far from this straight line is often more critical for defining the curve's shape.

#### Perpendicular Distance Formula

The distance $d_i$ is calculated from the cross product between the segment vector $[P_{i-1}, P_{i+1}]$ and the vector $[P_{i-1}, P_i]$.

$$
d_i = \frac{\left| (P_{i+1} - P_{i-1}) \times (P_{i-1} - P_i) \right|}{\|P_{i+1} - P_{i-1}\|}
$$

**Where**:
- $\times$ is the 2D cross product.
- $\|\cdot\|$ is the length of the segment between $P_{i-1}$ and $P_{i+1}$.

### Weight Formula $W_i$

The weight measure $W_i$ combines these three factors for each control point:

$$
W_i = \alpha \cdot \left(\frac{\kappa_i}{\max(\kappa)}\right) + \beta \cdot \left(1 - \frac{\theta_i}{\pi}\right) + \gamma \cdot \left(\frac{d_i}{\max(d)}\right)
$$

**Where**:
- $\alpha$, $\beta$, and $\gamma$ are weighting coefficients that satisfy $\alpha + \beta + \gamma = 1$.
- $\max(\kappa)$ and $\max(d)$ are the maximum curvature and distance values for the entire curve.

## Applications and Observations

- **Circular Curves**: Points on a perfect circle tend to have high and nearly equal weights, as each point contributes uniformly to the overall shape.
- **Dense Curves**: In curves with very close points, the weights $W_i$ vary, highlighting less critical points for the structure.
- **Varied Curves**: For more complex curves, $W_i$ identifies key points that maintain shape and directional changes.

## Example Usage

### Example 1: Simplifying a Custom Curve

1. **Initialize Control Points**:

```matlab
   % Define control points for a custom curve
   P = [0, 0; 2, 1; 4, 0; 6, 2; 8, 1; 10, 1.5; 12, 0; 14, -1; 16, 0];
   
   % Define weighting coefficients
   alpha = 0.4;
   beta = 0.3;
   gamma = 0.3;
   
   % Calculate weights
   [weights, max_curvature, max_distance] = weight(P, alpha, beta, gamma);
   
   % Define s_values for Bezier control points
   s_values = [0.5, -0.3, 0.4, -0.2, 0.3, -0.4, 0.2, -0.1];
   
   % Compute intermediate S_points
   [midpoints, directions] = compute_midpoints_and_directions(P);
   S_points = compute_spline_control_points(midpoints, directions, s_values);
   
   % Construct Bezier curve
   bezier_curve_points = construct_curve(P, S_points);
   
   % Compute envelopes for error tolerance
   epsilon = 0.2;
   [upper_envelope, lower_envelope] = compute_envelopes(bezier_curve_points, epsilon);
   
   % Plot the curve
   plot_curve(P, S_points, s_values, bezier_curve_points, upper_envelope, lower_envelope, weights);
```

**Description**: This example initializes a set of control points, computes the weights for each point, and plots the resulting curve with its error envelopes. The Bezier control points are calculated based on defined s_values, showing how to preserve curve details.

![Custom Curve](https://github.com/user-attachments/assets/558f30b4-2ab4-46d4-b000-9f72aa30e774)


### Example 2: Analyzing a Circular Curve

1. **Initialize Circular Control Points**:

```matlab
   % Define control points for a circle
   theta = linspace(0, 2*pi, 12);
   x_circle = cos(theta);
   y_circle = sin(theta);
   P_circle = [x_circle', y_circle'];

   % Define weighting coefficients
   alpha = 0.4;
   beta = 0.3;
   gamma = 0.3;

  

 % Calculate weights for the circular curve
   [weights_circle, max_curvature_circle, max_distance_circle] = weight(P_circle, alpha, beta, gamma);
   
   % No spline modifications (s_values = 0)
   s_values_circle = zeros(1, length(P_circle) - 1);
   
   % Compute intermediate S_points
   [midpoints_circle, directions_circle] = compute_midpoints_and_directions(P_circle);
   S_points_circle = compute_spline_control_points(midpoints_circle, directions_circle, s_values_circle);
   
   % Construct Bezier curve
   bezier_curve_points_circle = construct_curve(P_circle, S_points_circle);
   
   % Compute envelopes
   epsilon = 0.1;  % Smaller epsilon for the circle
   [upper_envelope_circle, lower_envelope_circle] = compute_envelopes(bezier_curve_points_circle, epsilon);
   
   % Plot the circular curve
   plot_curve(P_circle, S_points_circle, s_values_circle, bezier_curve_points_circle, upper_envelope_circle, lower_envelope_circle, weights_circle);
```

**Description**: This example illustrates how to analyze a circular curve. It demonstrates the calculation of weights for a perfectly circular set of control points, highlighting the uniformity in weights and shape preservation.

![Circular Curve](https://github.com/user-attachments/assets/522cb5db-8b49-488b-9930-e5ddda3b310f)


### Example 3: High-Density Points Curve

1. **Initialize High-Density Control Points**:

```matlab
   % Define control points for a curve with high-density points
   x_dense = linspace(0, 10, 100);
   y_dense = sin(x_dense) + 0.1 * randn(1, 100); % Add small noise
   P_dense = [x_dense', y_dense'];

   % Define weighting coefficients
   alpha = 0.4;
   beta = 0.3;
   gamma = 0.3;

   % Calculate weights for the dense curve
   [weights_dense, max_curvature_dense, max_distance_dense] = weight(P_dense, alpha, beta, gamma);
   
   % Generate random s_values for slight variations
   s_values_dense = 0.1 * randn(1, length(P_dense) - 1);
   
   % Compute intermediate S_points
   [midpoints_dense, directions_dense] = compute_midpoints_and_directions(P_dense);
   S_points_dense = compute_spline_control_points(midpoints_dense, directions_dense, s_values_dense);
   
   % Construct Bezier curve
   bezier_curve_points_dense = construct_curve(P_dense, S_points_dense);
   
   % Compute envelopes
   epsilon = 0.3;  % Larger epsilon for flexibility
   [upper_envelope_dense, lower_envelope_dense] = compute_envelopes(bezier_curve_points_dense, epsilon);
   
   % Plot the high-density curve
   plot_curve(P_dense, S_points_dense, s_values_dense, bezier_curve_points_dense, upper_envelope_dense, lower_envelope_dense, weights_dense);
```

**Description**: In this example, a curve with a high density of points is analyzed. The weights calculated reveal which points are less critical, allowing for potential simplification. The use of random s_values introduces slight variations, demonstrating the flexibility of this method.

![Dense Curve](https://github.com/user-attachments/assets/70b68f1e-e9d3-4e9c-a83d-313ceda5c38a)

### Weight $W$ vs. Distance $s$ Curve

In this section, we examine how the weight $W$ of a control point varies with the distance $s$ of the intermediate spline control point $S$ from the line segment $[P_{\text{in}}, P_{\text{out}}]$. 

#### Plotting Weight $W$ as a Function of Distance $s$

- **Control Points Setup**: A simple spline curve is created using three control points: $P_{\text{in}}$, $S(s)$, and $P_{\text{out}}$.

- **Range of $s$ Values**: The parameter $s$ is varied across a specified range to assess the influence of $S$ on the curve's weight $W$. This analysis highlights the importance of the spline point in shaping the curve.

#### Observations

- **Peaks and Valleys**:
  - **Peaks**: The graph shows peaks at certain $s$ values, indicating regions where the spline point $S$ has a significant impact on the curve's geometry. These points are crucial in maintaining the curve's overall shape and integrity.
  - **Valleys**: The valleys represent points where $S$ contributes less to the curve's definition, suggesting potential areas for simplification without major shape alterations.

- **Central Minimum**:
  - The weight $W$ shows a minimum at $s = 0$, which corresponds to $S$ being in the direct line between $P_{\text{in}}$ and $P_{\text{out}}$. 

- **Symmetry**:
  - The plot exhibits symmetry, indicating balanced contributions from the spline control points. Positive and negative $s$ values might reflect similar weight due to symmetrical properties around the bisector.

![weight_vs_s](https://github.com/user-attachments/assets/cf48aa0c-5b7c-4eb4-8caa-52a86773d692)

**Acknowledgment:** This project utilized ChatGPT to help organize the code and improve documentation.

