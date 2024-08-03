function [midpoints, directions] = compute_midpoints_and_directions(P)
    % compute_midpoints_and_directions: Calcule les milieux et les directions perpendiculaires pour chaque segment
    % Entrée: 
    %   P - Matrice des points de contrôle
    % Sortie:
    %   midpoints - Milieux des segments
    %   directions - Directions perpendiculaires normalisées
    
    midpoints = (P(1:end-1, :) + P(2:end, :)) / 2;
    directions = [P(2:end, 2) - P(1:end-1, 2), P(1:end-1, 1) - P(2:end, 1)];
    norms = sqrt(sum(directions.^2, 2));
    directions = directions ./ norms; % Normalisation
end
