function [upper_envelope, lower_envelope] = compute_envelopes(bezier_curve_points, epsilon)
    % compute_envelopes: Calculer les enveloppes \Gamma + \epsilon et \Gamma - \epsilon
    % Entrée:
    %   bezier_curve_points - Points de la courbe de Bézier
    %   epsilon - Tolérance d'erreur
    % Sortie:
    %   upper_envelope - Enveloppe supérieure
    %   lower_envelope - Enveloppe inférieure

    % Calculer les directions normales à la courbe
    dx = gradient(bezier_curve_points(:, 1));
    dy = gradient(bezier_curve_points(:, 2));
    magnitudes = sqrt(dx.^2 + dy.^2);
    normals_x = -dy ./ magnitudes;
    normals_y = dx ./ magnitudes;

    % Calculer les enveloppes
    upper_envelope = bezier_curve_points + epsilon * [normals_x normals_y];
    lower_envelope = bezier_curve_points - epsilon * [normals_x normals_y];
end
