function [P_simplified, weights_simplified, bezier_curve_points] = simplify_curve(P, alpha, beta, gamma, s_values)
    % simplify_curve: Simplifies the Bézier curve by removing the control point with the minimal weight
    % Input:
    %   P - Matrix of control points
    %   alpha, beta, gamma - Weighting coefficients
    %   s_values - Parameters s for each segment
    % Output:
    %   P_simplified - Simplified control points
    %   weights_simplified - Weights of the simplified control points
    %   bezier_curve_points - Recalculated Bézier curve points

    % Calculate initial weights
    [weights, ~, ~] = weight(P, alpha, beta, gamma);

    % Identify the point with the minimal weight (excluding the first and last points)
    [~, min_index] = min(weights(2:end-1));
    min_index = min_index + 1; % Adjust for correct indexing

    % Remove the point with the minimal weight
    P_simplified = P;
    P_simplified(min_index, :) = [];

    % Recalculate S points and the curve
    [midpoints, directions] = compute_midpoints_and_directions(P_simplified);
    S_points = midpoints + directions .* s_values(1:end-1)'; % Make sure s_values length matches P_simplified
    bezier_curve_points = construct_curve(P_simplified, S_points);

    % Recalculate weights
    [weights_simplified, ~, ~] = weight(P_simplified, alpha, beta, gamma);
end
