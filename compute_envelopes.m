function [upper_envelope, lower_envelope] = compute_envelopes(bezier_curve_points, epsilon)
    % compute_envelopes: Compute the envelopes \Gamma + \epsilon and \Gamma - \epsilon
    % Input:
    %   bezier_curve_points - Points of the Bézier curve
    %   epsilon - Error tolerance
    % Output:
    %   upper_envelope - Upper envelope
    %   lower_envelope - Lower envelope

    % Calculate the normal directions to the curve
    dx = gradient(bezier_curve_points(:, 1));
    dy = gradient(bezier_curve_points(:, 2));
    magnitudes = sqrt(dx.^2 + dy.^2);
    normals = [-dy ./ magnitudes, dx ./ magnitudes]; % Combined normal vectors

    % Calculate the envelopes using vectorized operations
    upper_envelope = bezier_curve_points + epsilon * normals;
    lower_envelope = bezier_curve_points - epsilon * normals;
end
