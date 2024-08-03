function bezier_curve_points = construct_curve(P, S_points)
    % construct_curve: Constructs the quadratic Bézier curve using control points S
    % Input: 
    %   P - Matrix of control points
    %   S_points - Intermediate control points S
    % Output:
    %   bezier_curve_points - Points of the Bézier curve

    % Number of segments
    num_segments = size(P, 1) - 1;
    
    % Number of points per segment for smooth curves
    num_points_per_segment = 100;
    
    % Preallocate memory for Bézier curve points
    bezier_curve_points = zeros(num_segments * num_points_per_segment, 2);

    % Parameter t for Bézier curve
    t = linspace(0, 1, num_points_per_segment);
    T = [((1-t).^2)' 2*(1-t)'.*t' (t.^2)']; % Precompute powers of t
    
    % Control points matrices
    P0 = P(1:end-1, :);
    P1 = S_points;
    P2 = P(2:end, :);

    % Vectorized computation of Bézier curve points
    for i = 1:num_segments
        % Compute each segment points in a vectorized manner
        bezier_curve_points((i-1) * num_points_per_segment + 1 : i * num_points_per_segment, :) = ...
            T(:, 1) * P0(i, :) + T(:, 2) * P1(i, :) + T(:, 3) * P2(i, :);
    end
end
