function [weights, max_curvature, max_distance] = weight(P, alpha, beta, gamma)
    % weight: Calculates the weights W_i for each point on the curve
    % Input:
    %   P - Matrix of control points (n x 2)
    %   alpha, beta, gamma - Weighting coefficients for the measures
    % Output:
    %   weights - Vector of weights for each control point
    %   max_curvature - Maximum curvature value
    %   max_distance - Maximum perpendicular distance value
    
    n = size(P, 1);
    weights = ones(n, 1); % Initialize weights with 1

    % Calculate the global maxima for curvature and distance
    [max_curvature, max_distance] = calculate_maxima(P);

    % Calculate weights for each point (excluding the first and last points)
    for i = 2:n-1
        weights(i) = calculate_weight(P(i-1, :), P(i, :), P(i+1, :), alpha, beta, gamma, max_curvature, max_distance);
    end
end

function [max_curvature, max_distance] = calculate_maxima(P)
    % calculate_maxima: Calculates the global maxima for curvature and distance for the curve
    % Input:
    %   P - Matrix of control points (n x 2)
    % Output:
    %   max_curvature - Maximum curvature value
    %   max_distance - Maximum perpendicular distance value
    
    n = size(P, 1);
    curvatures = zeros(n, 1);
    distances = zeros(n, 1);

    % Calculate measures for each point (excluding the first and last points)
    for i = 2:n-1
        curvatures(i) = curvature_measure(P(i-1, :), P(i, :), P(i+1, :));
        distances(i) = distance_measure(P(i-1, :), P(i, :), P(i+1, :));
    end

    % Calculate the global maxima
    max_curvature = max(curvatures);
    max_distance = max(distances);
end

function W_i = calculate_weight(P_prev, P, P_next, alpha, beta, gamma, max_curvature, max_distance)
    % calculate_weight: Calculates the weight W_i for a given point based on curvature, angle, and distance.
    %
    % Input:
    %   P_prev - The previous point P_{i-1}
    %   P      - The current point P_i
    %   P_next - The next point P_{i+1}
    %   alpha  - Weighting coefficient for curvature
    %   beta   - Weighting coefficient for angle
    %   gamma  - Weighting coefficient for perpendicular distance
    %   max_curvature - The maximum curvature value across the entire curve
    %   max_distance  - The maximum perpendicular distance value across the entire curve
    %
    % Output:
    %   W_i    - The calculated weight for point P_i

    % Calculate measures
    kappa_i = curvature_measure(P_prev, P, P_next);
    theta_i = angle_measure(P_prev, P, P_next);
    d_i = distance_measure(P_prev, P, P_next);

    % Calculate the normalized weight
    W_i = alpha * (kappa_i / max_curvature) + beta * (1 - theta_i / pi) + gamma * (d_i / max_distance);
end

function kappa_i = curvature_measure(P_prev, P, P_next)
    % curvature_measure: Calculates the curvature using the area of the triangle formed by the three points.
    %
    % Input:
    %   P_prev - The previous point P_{i-1}
    %   P      - The current point P_i
    %   P_next - The next point P_{i+1}
    %
    % Output:
    %   kappa_i - The curvature at point P_i

    % Calculate the area of the triangle formed by the three points
    area = 0.5 * abs(P_prev(1) * (P(2) - P_next(2)) + P(1) * (P_next(2) - P_prev(2)) + P_next(1) * (P_prev(2) - P(2)));

    % Calculate the curvature
    kappa_i = 2 * area / (norm(P_prev - P) * norm(P_next - P) * norm(P_next - P_prev));
end

function theta_i = angle_measure(P_prev, P, P_next)
    % angle_measure: Calculates the angle between the segments [P_prev, P] and [P, P_next].
    %
    % Input:
    %   P_prev - The previous point P_{i-1}
    %   P      - The current point P_i
    %   P_next - The next point P_{i+1}
    %
    % Output:
    %   theta_i - The angle between the two segments in radians

    % Vectors between the points
    v1 = P - P_prev;
    v2 = P_next - P;

    % Calculate the angle using the dot product
    cos_theta = dot(v1, v2) / (norm(v1) * norm(v2));
    theta_i = acos(cos_theta);
end

function d_i = distance_measure(P_prev, P, P_next)
    % distance_measure: Calculates the perpendicular distance from point P to the segment [P_prev, P_next].
    %
    % Input:
    %   P_prev - The previous point P_{i-1}
    %   P      - The current point P_i
    %   P_next - The next point P_{i+1}
    %
    % Output:
    %   d_i - The perpendicular distance to the segment

    % Vector of the segment
    line_vec = P_next - P_prev;
    point_vec = P - P_prev;

    % Cross product (for perpendicular distance in 2D)
    cross_prod = abs(det([line_vec; point_vec]));
    
    % Calculate the perpendicular distance
    d_i = cross_prod / norm(line_vec);
end
