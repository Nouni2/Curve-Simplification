function bezier_curve_points = construct_curve(P, S_points)
    % construct_curve: Construit la courbe de Bézier quadratique en utilisant les points de contrôle S
    % Entrée: 
    %   P - Matrice des points de contrôle
    %   S_points - Points de contrôle intermédiaires S
    % Sortie:
    %   bezier_curve_points - Points de la courbe de Bézier

    % Nombre de segments
    num_segments = size(P, 1) - 1;
    bezier_curve_points = [];

    % Construire chaque segment de Bézier
    for i = 1:num_segments
        p0 = P(i, :);
        p1 = S_points(i, :);
        p2 = P(i+1, :);
        
        % Paramètre t pour la courbe de Bézier
        t = linspace(0, 1, 100); % Plus de points pour une courbe lisse
        
        % Calcul des points de la courbe de Bézier
        B_t_x = (1-t).^2 * p0(1) + 2*(1-t).*t * p1(1) + t.^2 * p2(1);
        B_t_y = (1-t).^2 * p0(2) + 2*(1-t).*t * p1(2) + t.^2 * p2(2);
        
        % Ajouter les points au tableau des courbes
        B_t = [B_t_x' B_t_y']; % Transpose pour correspondre à la structure des lignes
        bezier_curve_points = [bezier_curve_points; B_t];
    end
end
