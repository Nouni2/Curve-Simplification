function S_points = compute_spline_control_points(midpoints, directions, s_values)
    % compute_spline_control_points: Calculates the control points S using midpoints and s values
    % Input: 
    %   midpoints - Midpoints of the segments
    %   directions - Normalized perpendicular directions
    %   s_values - s parameters for each segment
    % Output:
    %   S_points - Intermediate control points S
    
    S_points = midpoints + directions .* s_values';
end
