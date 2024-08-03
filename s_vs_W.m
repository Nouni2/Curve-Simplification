% s_vs_W.m
% This script visualizes the effect of the control point S on the weight W
% Creates a simple Bézier curve [P_in, S(s), P_out] and plots W as a function of s
% It also plots three additional curves for specific values of s in a separate figure

% Define the control points
P_in = [0, 0];  % Start point
P_out = [1, 0]; % End point

% Define the range of s values
s_range = linspace(-10, 10, 1000);  % Vary s from -10 to 10
weights = zeros(size(s_range));     % Initialize weights array

% Define coefficients for the weight calculation
alpha = 0.4; 
beta = 0.3; 
gamma = 0.3;

% Precompute max curvature and distance for normalization
max_curvature = 0; % Initialize with zero
max_distance = 0;  % Initialize with zero

% Loop through each value of s to find max curvature and distance
for i = 1:length(s_range)
    s = s_range(i);
    S = compute_s_point(P_in, P_out, s); % Calculate point S based on s
    
    % Compute curvature and distance
    kappa_i = curvature_measure(P_in, S, P_out);
    d_i = distance_measure(P_in, S, P_out);
    
    % Update max curvature and distance
    max_curvature = max(max_curvature, kappa_i);
    max_distance = max(max_distance, d_i);
end

% Calculate the weight W for each s after determining max values
for i = 1:length(s_range)
    s = s_range(i);
    S = compute_s_point(P_in, P_out, s); % Calculate point S based on s
    
    % Compute curvature, angle, and perpendicular distance for the weight
    kappa_i = curvature_measure(P_in, S, P_out);
    theta_i = angle_measure(P_in, S, P_out);
    d_i = distance_measure(P_in, S, P_out);
    
    % Calculate the weight W with normalization
    weights(i) = alpha * (kappa_i / max_curvature) + ...
                 beta * (1 - theta_i / pi) + ...
                 gamma * (d_i / max_distance);
end

% Find s for max and min weight
[max_weight, max_idx] = max(weights);
[min_weight, min_idx] = min(weights);
s_max_weight = s_range(max_idx);
s_min_weight = s_range(min_idx);

% Plot the weight W as a function of s in a new figure
figure;
plot(s_range, weights, 'b-', 'LineWidth', 2);
xlabel('s');
ylabel('Weight W');
title('Weight W as a Function of Distance s');
grid on;

% Define another figure for Bézier curves for different s values
figure;
hold on;

% Plot the curves for s = 0, s that maximizes W, and s that minimizes W
s_values = [0, -s_max_weight, s_min_weight];
colors = ['r', 'g', 'm'];  % Colors for different curves
labels = {'s = 0', 's = max W', 's = min W'};

for i = 1:length(s_values)
    s = s_values(i);
    S = compute_s_point(P_in, P_out, s);
    
    % Calculate Bézier curve points
    t = linspace(0, 1, 100);
    B_t_x = (1-t).^2 * P_in(1) + 2*(1-t).*t * S(1) + t.^2 * P_out(1);
    B_t_y = (1-t).^2 * P_in(2) + 2*(1-t).*t * S(2) + t.^2 * P_out(2);
    
    % Plot the Bézier curve
    plot(B_t_x, B_t_y, colors(i), 'LineWidth', 2, 'DisplayName', labels{i});
end

xlabel('x');
ylabel('y');
title('Bézier Curves for Different s Values');
grid on;
legend('Location', 'best');
axis equal;
hold off;

% Supporting function to calculate point S based on s
function S = compute_s_point(P_in, P_out, s)
    midpoint = (P_in + P_out) / 2; % Midpoint between P_in and P_out
    direction = [-(P_out(2) - P_in(2)), (P_out(1) - P_in(1))]; % Perpendicular direction
    direction = direction / norm(direction); % Normalize direction
    S = midpoint + s * direction; % Calculate point S
end

% Supporting function to calculate curvature
function kappa_i = curvature_measure(P_prev, P, P_next)
    % Calculate the area of the triangle formed by the three points
    area = 0.5 * abs(P_prev(1) * (P(2) - P_next(2)) + P(1) * (P_next(2) - P_prev(2)) + P_next(1) * (P_prev(2) - P(2)));
    % Calculate the curvature
    kappa_i = 2 * area / (norm(P_prev - P) * norm(P_next - P) * norm(P_next - P_prev));
end

% Supporting function to calculate the angle
function theta_i = angle_measure(P_prev, P, P_next)
    % Calculate the angle between segments [P_prev, P] and [P, P_next]
    v1 = P - P_prev;
    v2 = P_next - P;
    cos_theta = dot(v1, v2) / (norm(v1) * norm(v2));
    theta_i = acos(cos_theta);
end

% Supporting function to calculate the perpendicular distance
function d_i = distance_measure(P_prev, P, P_next)
    % Calculate the perpendicular distance from P to segment [P_prev, P_next]
    line_vec = P_next - P_prev;
    point_vec = P - P_prev;
    cross_prod = abs(det([line_vec; point_vec]));
    d_i = cross_prod / norm(line_vec);
end
