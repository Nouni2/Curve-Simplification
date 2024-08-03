function [weights, max_curvature, max_distance] = weight(P, alpha, beta, gamma)
    % weight: Calcule les poids W_i pour chaque point sur la courbe
    % Entrée:
    %   P - Matrice des points de contrôle (n x 2)
    %   alpha, beta, gamma - Coefficients de pondération pour les mesures
    % Sortie:
    %   weights - Vecteur des poids pour chaque point de contrôle
    %   max_curvature - Valeur maximale de courbure
    %   max_distance - Valeur maximale de distance perpendiculaire
    
    n = size(P, 1);
    weights = ones(n, 1); % Initialiser les poids avec 1

    % Calculer les maxima globaux de courbure et de distance
    [max_curvature, max_distance] = calculate_maxima(P);

    % Calcul des poids pour chaque point (sauf le premier et le dernier)
    for i = 2:n-1
        weights(i) = calculate_weight(P(i-1, :), P(i, :), P(i+1, :), alpha, beta, gamma, max_curvature, max_distance);
    end
end

function [max_curvature, max_distance] = calculate_maxima(P)
    % calculate_maxima: Calcule les maxima globaux de courbure et de distance pour la courbe
    % Entrée:
    %   P - Matrice des points de contrôle (n x 2)
    % Sortie:
    %   max_curvature - Valeur maximale de courbure
    %   max_distance - Valeur maximale de distance perpendiculaire
    
    n = size(P, 1);
    curvatures = zeros(n, 1);
    distances = zeros(n, 1);

    % Calcul des mesures pour chaque point (sauf le premier et le dernier)
    for i = 2:n-1
        curvatures(i) = curvature_measure(P(i-1, :), P(i, :), P(i+1, :));
        distances(i) = distance_measure(P(i-1, :), P(i, :), P(i+1, :));
    end

    % Calcul des maxima globaux
    max_curvature = max(curvatures);
    max_distance = max(distances);
end

function W_i = calculate_weight(P_prev, P, P_next, alpha, beta, gamma, max_curvature, max_distance)
    % calculate_weight: Calcule le poids W_i pour un point donné en fonction de la courbure, de l'angle et de la distance.
    %
    % Entrées:
    %   P_prev - Le point précédent P_{i-1}
    %   P      - Le point actuel P_i
    %   P_next - Le point suivant P_{i+1}
    %   alpha  - Coefficient de pondération pour la courbure
    %   beta   - Coefficient de pondération pour l'angle
    %   gamma  - Coefficient de pondération pour la distance perpendiculaire
    %   max_curvature - La valeur maximale de courbure sur l'ensemble de la courbe
    %   max_distance  - La valeur maximale de distance perpendiculaire sur l'ensemble de la courbe
    %
    % Sortie:
    %   W_i    - Le poids calculé pour le point P_i

    % Calculer les mesures
    kappa_i = curvature_measure(P_prev, P, P_next);
    theta_i = angle_measure(P_prev, P, P_next);
    d_i = distance_measure(P_prev, P, P_next);

    % Calculer le poids normalisé
    W_i = alpha * (kappa_i / max_curvature) + beta * (1 - theta_i / pi) + gamma * (d_i / max_distance);
end

function kappa_i = curvature_measure(P_prev, P, P_next)
    % curvature_measure: Calcule la courbure en utilisant l'aire du triangle formé par les trois points.
    %
    % Entrées:
    %   P_prev - Le point précédent P_{i-1}
    %   P      - Le point actuel P_i
    %   P_next - Le point suivant P_{i+1}
    %
    % Sortie:
    %   kappa_i - La courbure au point P_i

    % Calculer l'aire du triangle formé par les trois points
    area = 0.5 * abs(P_prev(1) * (P(2) - P_next(2)) + P(1) * (P_next(2) - P_prev(2)) + P_next(1) * (P_prev(2) - P(2)));

    % Calculer la courbure
    kappa_i = 2 * area / (norm(P_prev - P) * norm(P_next - P) * norm(P_next - P_prev));
end

function theta_i = angle_measure(P_prev, P, P_next)
    % angle_measure: Calcule l'angle entre les segments [P_prev, P] et [P, P_next].
    %
    % Entrées:
    %   P_prev - Le point précédent P_{i-1}
    %   P      - Le point actuel P_i
    %   P_next - Le point suivant P_{i+1}
    %
    % Sortie:
    %   theta_i - L'angle entre les deux segments en radians

    % Vecteurs entre les points
    v1 = P - P_prev;
    v2 = P_next - P;

    % Calculer l'angle en utilisant le produit scalaire
    cos_theta = dot(v1, v2) / (norm(v1) * norm(v2));
    theta_i = acos(cos_theta);
end

function d_i = distance_measure(P_prev, P, P_next)
    % distance_measure: Calcule la distance perpendiculaire du point P au segment [P_prev, P_next].
    %
    % Entrées:
    %   P_prev - Le point précédent P_{i-1}
    %   P      - Le point actuel P_i
    %   P_next - Le point suivant P_{i+1}
    %
    % Sortie:
    %   d_i - La distance perpendiculaire au segment

    % Vecteur du segment
    line_vec = P_next - P_prev;
    point_vec = P - P_prev;

    % Produit vectoriel (pour une distance perpendiculaire en 2D)
    cross_prod = abs(det([line_vec; point_vec]));
    
    % Calculer la distance perpendiculaire
    d_i = cross_prod / norm(line_vec);
end
