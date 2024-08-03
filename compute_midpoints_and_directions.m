function [midpoints, directions] = compute_midpoints_and_directions(P)
    % compute_midpoints_and_directions: Calculates the midpoints and perpendicular directions for each segment
    % Input: 
    %   P - Matrix of control points
    % Output:
    %   midpoints - Midpoints of the segments
    %   directions - Normalized perpendicular directions
    
    % Calculate midpoints
    midpoints = (P(1:end-1, :) + P(2:end, :)) / 2;

    % Calculate perpendicular directions
    directions = [P(2:end, 2) - P(1:end-1, 2), P(1:end-1, 1) - P(2:end, 1)];

    % Calculate norms and normalize directions
    norms = sqrt(sum(directions.^2, 2));
    directions = directions ./ norms; % Normalization
end
