function plot_curve(P, S_points, s_values, bezier_curve_points, upper_envelope, lower_envelope, weights)
    % plot_curve: Tracé de la courbe de Bézier, des points de contrôle et des enveloppes avec annotations des poids.
    % Entrée: 
    %   P - Matrice des points de contrôle
    %   S_points - Points de contrôle intermédiaires S
    %   s_values - Paramètres s pour chaque segment
    %   bezier_curve_points - Points de la courbe de Bézier
    %   upper_envelope - Enveloppe supérieure \Gamma + \epsilon
    %   lower_envelope - Enveloppe inférieure \Gamma - \epsilon
    %   weights - Vecteur des poids pour chaque point de contrôle

    figure;
    hold on;

    % Handles pour la légende
    legendHandles = gobjects(7, 1); % Tableau pour stocker les handles
    
    % Boucle à travers chaque segment pour tracer les éléments visuels
    for i = 1:length(s_values)
        p1 = P(i, :);
        p2 = P(i+1, :);
        S = S_points(i, :);
        
        % Trace le segment direct [P_i, P_{i+1}] en blanc
        if i == 1
            legendHandles(1) = plot([p1(1), p2(1)], [p1(2), p2(2)], 'w--', 'LineWidth', 1); % Ligne pointillée blanche
        else
            plot([p1(1), p2(1)], [p1(2), p2(2)], 'w--', 'LineWidth', 1);
        end
        
        % Trace la médiatrice et la position de S_i si s_value n'est pas zéro
        if s_values(i) ~= 0
            midpoint = (p1 + p2) / 2;
            % Pointillé jusqu'à S_i
            if i == 1
                legendHandles(2) = plot([midpoint(1), S(1)], [midpoint(2), S(2)], 'w:', 'LineWidth', 1); % Ligne pointillée blanche
            else
                plot([midpoint(1), S(1)], [midpoint(2), S(2)], 'w:', 'LineWidth', 1);
            end
            % Marque le point S_i
            if i == 1
                legendHandles(3) = plot(S(1), S(2), 'gx', 'MarkerSize', 10, 'LineWidth', 2); % Marque verte
            else
                plot(S(1), S(2), 'gx', 'MarkerSize', 10, 'LineWidth', 2);
            end
        end
    end
    
    % Trace la courbe de Bézier
    legendHandles(4) = plot(bezier_curve_points(:, 1), bezier_curve_points(:, 2), 'b', 'LineWidth', 2); % Courbe Bézier bleue
    
    % Trace les points de contrôle
    legendHandles(5) = plot(P(:, 1), P(:, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Points de contrôle rouges
    
    % Trace les enveloppes
    legendHandles(6) = plot(upper_envelope(:, 1), upper_envelope(:, 2), 'm--', 'LineWidth', 1.5); % Enveloppe supérieure
    legendHandles(7) = plot(lower_envelope(:, 1), lower_envelope(:, 2), 'm--', 'LineWidth', 1.5); % Enveloppe inférieure

    % Ajouter des annotations de poids pour chaque point
    for i = 1:length(P)
        % Affiche les poids en utilisant la fonction text
        text(P(i, 1), P(i, 2), sprintf('W=%.2f', weights(i)), 'Color', 'yellow', 'FontSize', 10, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    
    % Ajout de la légende avec les styles et couleurs appropriés
    legend(legendHandles, ...
        {'Direct Segment [P_i, P_{i+1}]', 'Mediatrice', 'Spline Control Points S', 'Curve \Gamma', 'Control Points P', ...
         '\Gamma + \epsilon', '\Gamma - \epsilon'}, ...
        'TextColor', 'white', 'Location', 'best', 'Color', 'black');
    
    xlabel('x', 'Color', 'white');
    ylabel('y', 'Color', 'white');
    title('Constructed Curve \Gamma with Bézier Curves and Tolerance Envelopes', 'Color', 'white');
    grid on;
    % set(gca, 'Color', 'k', 'XColor', 'white', 'YColor', 'white'); % Fond et axes en noir
    axis equal;
    hold off;
end
