function detailed_curve_plot(P, S_points, s_values, bezier_curve_points, upper_envelope, lower_envelope, weights)
    % plot_curve: Plots the Bézier curve, control points, and envelopes with weight annotations.
    % Input: 
    %   P - Matrix of control points
    %   S_points - Intermediate control points S
    %   s_values - s parameters for each segment
    %   bezier_curve_points - Points of the Bézier curve
    %   upper_envelope - Upper envelope \Gamma + \epsilon
    %   lower_envelope - Lower envelope \Gamma - \epsilon
    %   weights - Vector of weights for each control point

    figure;
    hold on;

    % Initialize handles for the legend
    legendHandles = []; % Start with an empty array
    
    % Iterate through each segment to plot the visual elements
    for i = 1:length(s_values)
        p1 = P(i, :);
        p2 = P(i+1, :);
        S = S_points(i, :);
        
        % Plot the direct segment [P_i, P_{i+1}]
        h1 = plot([p1(1), p2(1)], [p1(2), p2(2)], 'k--', 'LineWidth', 1); % Dashed line
        if i == 1
            legendHandles(end+1) = h1; % Add to legend handles only once
        end
        
        % Plot the mediatrix and position of S_i if s_value is not zero
        if s_values(i) ~= 0
            midpoint = (p1 + p2) / 2;
            % Dotted line to S_i
            h2 = plot([midpoint(1), S(1)], [midpoint(2), S(2)], 'k:', 'LineWidth', 1); % Dotted line
            if i == 1
                legendHandles(end+1) = h2; % Add to legend handles only once
            end
            % Mark the S_i point
            h3 = plot(S(1), S(2), 'gx', 'MarkerSize', 10, 'LineWidth', 2); % Green mark
            if i == 1
                legendHandles(end+1) = h3; % Add to legend handles only once
            end
        end
    end
    
    % Plot the Bézier curve
    h4 = plot(bezier_curve_points(:, 1), bezier_curve_points(:, 2), 'b', 'LineWidth', 2); % Blue Bézier curve
    legendHandles(end+1) = h4; % Always add
    
    % Plot the control points
    h5 = plot(P(:, 1), P(:, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Red control points
    legendHandles(end+1) = h5; % Always add
    
    % Plot the envelopes
    h6 = plot(upper_envelope(:, 1), upper_envelope(:, 2), 'm--', 'LineWidth', 1.5); % Upper envelope
    legendHandles(end+1) = h6; % Always add
    h7 = plot(lower_envelope(:, 1), lower_envelope(:, 2), 'm--', 'LineWidth', 1.5); % Lower envelope
    legendHandles(end+1) = h7; % Always add

    % Add weight annotations for each point
    for i = 1:length(P)
        % Display weights using the text function
        text(P(i, 1), P(i, 2), sprintf('W=%.2f', weights(i)), 'FontSize', 10, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
            'Color', 'k', 'FontWeight', 'bold'); % Black text
    end
    
    % Add the legend with appropriate styles and colors
    lgd = legend(legendHandles, ...
        {'Direct Segment [P_i, P_{i+1}]', 'Mediatrix', 'Spline Control Points S', 'Curve \Gamma', 'Control Points P', ...
         '\Gamma + \epsilon', '\Gamma - \epsilon'}, ...
        'Location', 'best');
    set(lgd, 'FontWeight', 'bold');
    
    xlabel('x');
    ylabel('y');
    title('Constructed Curve \Gamma with Bézier Curves and Tolerance Envelopes');
    grid on;
    axis equal;
    hold off;
end
