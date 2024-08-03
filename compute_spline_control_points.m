function S_points = compute_spline_control_points(midpoints, directions, s_values)
    % compute_spline_control_points: Calcule les points de contrôle S en utilisant les médiatrices et les valeurs s
    % Entrée: 
    %   midpoints - Milieux des segments
    %   directions - Directions perpendiculaires normalisées
    %   s_values - Paramètres s pour chaque segment
    % Sortie:
    %   S_points - Points de contrôle intermédiaires S
    
    S_points = midpoints + directions .* s_values';
end
