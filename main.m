% main.m
%% General Parameters
close; clear;
epsilon = 0.2; % Maximum allowed error for simplification

% Weighting coefficients for the weights
alpha = 0.4;
beta = 0.3;
gamma = 0.3;

%% Curve 1: Arbitrary Curve
P1 = [0, 0; 2, 1; 4, 0; 6, 2; 8, 1; 10, 1.5; 12, 0; 14, -1; 16, 0];
s_values1 = [0.5, -0.3, 0.4, -0.2, 0.3, -0.4, 0.2, -0.1];

% Compute S points and plot the original curve
[midpoints1, directions1] = compute_midpoints_and_directions(P1);
S_points1 = compute_spline_control_points(midpoints1, directions1, s_values1);
bezier_curve_points1 = construct_curve(P1, S_points1);

% Compute the envelopes \Gamma + \epsilon and \Gamma - \epsilon
[upper_envelope1, lower_envelope1] = compute_envelopes(bezier_curve_points1, epsilon);

% Calculate the weights for each point
[weights1, ~, ~] = weight(P1, alpha, beta, gamma);

% Display the curve with envelopes and weight annotations
detailed_curve_plot(P1, S_points1, s_values1, bezier_curve_points1, upper_envelope1, lower_envelope1, weights1);
title('Custom Curve');

%% Curve 2: Circular Curve
theta = linspace(0, 2*pi, 50);
x_circle = cos(theta);
y_circle = sin(theta);
P2 = [x_circle', y_circle'];
s_values2 = zeros(1, size(P2, 1) - 1); % No spline modification

% Compute S points and plot the circular curve
[midpoints2, directions2] = compute_midpoints_and_directions(P2);
S_points2 = compute_spline_control_points(midpoints2, directions2, s_values2);
bezier_curve_points2 = construct_curve(P2, S_points2);

% Compute the envelopes \Gamma + \epsilon and \Gamma - \epsilon
[upper_envelope2, lower_envelope2] = compute_envelopes(bezier_curve_points2, epsilon);

% Calculate the weights for each point
[weights2, ~, ~] = weight(P2, alpha, beta, gamma);

% Display the circular curve with envelopes and weight annotations
detailed_curve_plot(P2, S_points2, s_values2, bezier_curve_points2, upper_envelope2, lower_envelope2, weights2);
title('Circular Curve');

%% Curve 3: Dense Curve with Many Close Points
x_dense = linspace(0, 10, 100);
y_dense = sin(x_dense*0.5) + 0.1 * randn(1, 100); % Add some noise
P3 = [x_dense', y_dense'];
s_values3 = 0.1 * randn(1, size(P3, 1) - 1); % Small s for slight variations

% Compute S points and plot the dense curve
[midpoints3, directions3] = compute_midpoints_and_directions(P3);
S_points3 = compute_spline_control_points(midpoints3, directions3, s_values3);
bezier_curve_points3 = construct_curve(P3, S_points3);

% Compute the envelopes \Gamma + \epsilon and \Gamma - \epsilon
[upper_envelope3, lower_envelope3] = compute_envelopes(bezier_curve_points3, epsilon);

% Calculate the weights for each point
[weights3, ~, ~] = weight(P3, alpha, beta, gamma);

% Display the dense curve with envelopes and weight annotations
detailed_curve_plot(P3, S_points3, s_values3, bezier_curve_points3, upper_envelope3, lower_envelope3, weights3);
title('Dense Curve');

%% Curve Simplification

% Define control points and parameters
P = [0, 0; 
     2, 1; 
     4, 0; 
     6, 2; 
     8, 1; 
     10, 1.5; 
     12, 0; 
     14, -1; 
     16, 0;
     18, 0.5;  
     20, -1;   
     22, 0.5;  
     24, 0];   

s_values = [0.5, -0.3, 0.4, -0.2, 0, -0.4, 0.2, -0.1, 0.2, -0.3, 0.1, 0.4];   

% Compute midpoints and directions for the original curve
[midpoints, directions] = compute_midpoints_and_directions(P);

% Compute the spline control points for the original curve
S_points = midpoints + directions .* s_values';

% Construct the original Bézier curve
bezier_curve_points = construct_curve(P, S_points);

% Calculate weights for each control point
[weights, ~, ~] = weight(P, alpha, beta, gamma);

% Plot the original curve using the simplified function
plot_curve(P, S_points, bezier_curve_points, true, weights); % Display with weights
title('Original Curve (Step 0)');

% Set the minimum number of control points we want to keep
min_points = 2;

% Initialize step counter
step = 1;

% Simplification loop
while size(P, 1) > min_points
    % Simplify the curve by removing the control point with the minimal weight
    [P_simplified, weights_simplified, bezier_curve_points_simplified] = simplify_curve(P, alpha, beta, gamma, s_values);

    % Update the original points for the next iteration
    P = P_simplified;
    
    % Compute midpoints and directions for the simplified curve
    [midpoints_simplified, directions_simplified] = compute_midpoints_and_directions(P_simplified);

    % Compute the spline control points for the simplified curve
    S_points_simplified = midpoints_simplified + directions_simplified .* s_values(1:end-1)'; % Update to use simplified points

    % Plot the simplified curve using the simplified function
    plot_curve(P_simplified, S_points_simplified, bezier_curve_points_simplified, true, weights_simplified); % Display with weights
    title(['Simplified Curve (Step ', num2str(step), ')']);
    
    % Update s_values to match the simplified points
    s_values = s_values(1:end-1);
    
    % Increment step counter
    step = step + 1;
    
    % Pause to visualize each simplification step
    pause(1);  % Pause for 1 second between plots
end
