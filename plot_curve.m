function plot_curve(P, S_points, bezier_curve_points, show_weights, weights)
    % plot_curve: Plots the Bézier curve and control points, optionally showing weights.
    % Input:
    %   P - Matrix of control points
    %   S_points - Intermediate control points S
    %   bezier_curve_points - Points of the Bézier curve
    %   show_weights - Boolean flag to show weights
    %   weights - Vector of weights for each control point (optional)

    figure;
    hold on;

    % Plot the Bézier curve
    plot(bezier_curve_points(:, 1), bezier_curve_points(:, 2), 'b', 'LineWidth', 2); % Blue Bézier curve

    % Plot the control points
    plot(P(:, 1), P(:, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Red control points

    % Plot the intermediate S points
    plot(S_points(:, 1), S_points(:, 2), 'gx', 'MarkerSize', 10, 'LineWidth', 2); % Green S points

    % Optionally add weight annotations for each point
    if show_weights
        for i = 1:length(P)
            % Display weights using the text function
            text(P(i, 1), P(i, 2), sprintf('W=%.2f', weights(i)), 'FontSize', 10, ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
                'Color', 'k', 'FontWeight', 'bold'); % Black text
        end
    end

    xlabel('x');
    ylabel('y');
    title('Bézier Curve with Control Points');
    grid on;
    axis equal;
    hold off;
end


