% simplification_animation.m

% Clear workspace and close all figures
clear;
close all;

% Set parameters for weights
alpha = 0.4; % Curvature weight
beta = 0.3;  % Angle weight
gamma = 0.3; % Distance weight

% Define denser control points for the animation
P = [0, 0; 
     1, 1; 
     2, 1.5;
     3, 2; 
     4, 1.5;
     5, 0; 
     6, -1; 
     7.5, 1; 
     9, 3; 
     10.5, 1.5;
     12, 0; 
     13.5, 1; 
     15, 2; 
     16.5, 0;
     18, -2; 
     19.5, -0.5; 
     21, 1; 
     22.5, 0.5; 
     24, 0];

% Updated s_values to match the denser P
s_values = [0.7, -0.5, 0.6, -0.3, -0.4, 0.5, -0.4, -0.6, 0.3, -0.2, 0.5, 0.4, -0.6, -0.4, 0.3, 0.2, 0.4, -0.2];

% Calculate initial midpoints and directions
[midpoints, directions] = compute_midpoints_and_directions(P);

% Calculate initial spline control points
S_points = compute_spline_control_points(midpoints, directions, s_values);

% Construct the initial Bézier curve
bezier_curve_points = construct_curve(P, S_points);

% Calculate initial weights
[weights, ~, ~] = weight(P, alpha, beta, gamma);

% Plot the original curve
figure;
axis equal;
hold on;

% Plot initial curve
h_curve = plot(bezier_curve_points(:, 1), bezier_curve_points(:, 2), 'b-', 'LineWidth', 2);
h_P = plot(P(:, 1), P(:, 2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
h_S = plot(S_points(:, 1), S_points(:, 2), 'gx', 'MarkerSize', 8, 'LineWidth', 2);

% Annotate weights
h_text = gobjects(length(P), 1);
for i = 1:length(P)
    h_text(i) = text(P(i, 1), P(i, 2), sprintf('W=%.2f', weights(i)), 'FontSize', 10, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'Color', 'k', 'FontWeight', 'bold');
end

title('Original Curve (Step 0)');
xlim([min(P(:, 1)) - 1, max(P(:, 1)) + 1]);
ylim([min(P(:, 2)) - 1, max(P(:, 2)) + 1]);
grid on; % Add grid to the plot
axis equal;
pause(1);

% Set the minimum number of control points we want to keep
min_points = 2;

% Initialize step counter
step = 1;

% Set the boolean flag for saving the GIF
save_gif = false; % Set to true if you want to save the animation as a GIF

% Prepare for GIF creation if needed
if save_gif
    filename = 'simplification_animation.gif'; % Output file name
    frameDelay = 0.1; % Delay between frames in seconds

    % Capture initial frame for GIF
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', frameDelay);
end

% Simplification loop
while size(P, 1) > min_points
    % Simplify the curve by removing the control point with the minimal weight
    [P_simplified, weights_simplified, ~] = simplify_curve(P, alpha, beta, gamma, s_values);

    % Compute midpoints and directions for the simplified curve
    [midpoints_simplified, directions_simplified] = compute_midpoints_and_directions(P_simplified);

    % Compute the spline control points for the simplified curve
    S_points_simplified = compute_spline_control_points(midpoints_simplified, directions_simplified, s_values(1:end-1));

    % Recalculate the Bézier curve points for the simplified curve
    bezier_curve_points_simplified = construct_curve(P_simplified, S_points_simplified);

    % Interpolate the Bézier curve points to have the same size
    bezier_curve_points_simplified = interp1(linspace(0, 1, size(bezier_curve_points_simplified, 1)), ...
        bezier_curve_points_simplified, linspace(0, 1, size(bezier_curve_points, 1)));

    % Get the index of the removed point
    [~, min_index] = min(weights(2:end-1));
    min_index = min_index + 1; % Adjust for zero-indexing

    % Animate the morphing process
    for t = linspace(0, 1, 50)
        % Initialize arrays for interpolated points
        P_interpolated = zeros(size(P));
        S_interpolated = zeros(size(S_points));
        
        % Interpolate control points, excluding the removed point
        for i = 1:length(P_simplified)
            if i < min_index % Before the removed point
                P_interpolated(i, :) = (1 - t) * P(i, :) + t * P_simplified(i, :);
            elseif i >= min_index && (i + 1) <= length(P) % After the removed point
                P_interpolated(i, :) = (1 - t) * P(i + 1, :) + t * P_simplified(i, :);
            end
        end

        % Morph the removed point towards its closest neighbor
        if min_index < length(P)
            P_interpolated(min_index, :) = (1 - t) * P(min_index, :) + t * P(min_index - 1, :);
        end

        % Interpolate spline points
        for i = 1:min(length(S_points_simplified), length(S_points))
            if i < min_index && i <= length(S_points) && i <= length(S_points_simplified)
                S_interpolated(i, :) = (1 - t) * S_points(i, :) + t * S_points_simplified(i, :);
            elseif i >= min_index && (i + 1) <= length(S_points) && i <= length(S_points_simplified)
                S_interpolated(i, :) = (1 - t) * S_points(i + 1, :) + t * S_points_simplified(i, :);
            end
        end

        % Interpolate Bézier curve points
        bezier_interpolated = (1 - t) * bezier_curve_points + t * bezier_curve_points_simplified;

        % Update plot data
        set(h_curve, 'XData', bezier_interpolated(:, 1), 'YData', bezier_interpolated(:, 2));
        set(h_P, 'XData', P_interpolated(:, 1), 'YData', P_interpolated(:, 2));
        set(h_S, 'XData', S_interpolated(:, 1), 'YData', S_interpolated(:, 2));

        % Update annotations
        for i = 1:length(h_text)
            if i <= length(P_interpolated)
                set(h_text(i), 'Position', P_interpolated(i, :), ...
                    'String', sprintf('W=%.2f', weights(i)));
            else
                set(h_text(i), 'Position', [NaN, NaN], 'String', '');
            end
        end

        % Set axis limits and title
        title(['Morphing to Step ', num2str(step)]);
        grid on; % Ensure grid is on during animation
        drawnow;

        % Capture and save the current frame to GIF if save_gif is true
        if save_gif
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind, cm] = rgb2ind(im, 256);
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', frameDelay);
        end
    end

    % Update for next iteration
    P = P_simplified;
    S_points = S_points_simplified;
    bezier_curve_points = bezier_curve_points_simplified;
    weights = weights_simplified;
    s_values = s_values(1:end-1);
    step = step + 1;

    % Clear the plot for next morphing, without deleting plot objects
    delete(h_curve);
    delete(h_P);
    delete(h_S);
    delete(h_text);
    
    % Plot the simplified curve after morphing
    h_curve = plot(bezier_curve_points(:, 1), bezier_curve_points(:, 2), 'b-', 'LineWidth', 2);
    h_P = plot(P(:, 1), P(:, 2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
    h_S = plot(S_points(:, 1), S_points(:, 2), 'gx', 'MarkerSize', 8, 'LineWidth', 2);
    h_text = gobjects(length(P), 1);
    for i = 1:length(P)
        h_text(i) = text(P(i, 1), P(i, 2), sprintf('W=%.2f', weights(i)), 'FontSize', 10, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
            'Color', 'k', 'FontWeight', 'bold');
    end
    title(['Simplified Curve (Step ', num2str(step), ')']);
    grid on; % Keep grid on for the final plot
    pause(1);
end
