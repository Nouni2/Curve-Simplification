% main.m

%% Paramètres Généraux
epsilon = 0.2; % Erreur maximale permise pour la simplification

% Coefficients de pondération pour les poids
alpha = 0.4;
beta = 0.3;
gamma = 0.3;

%% Courbe 1: Courbe Quelconque
P1 = [0, 0; 2, 1; 4, 0; 6, 2; 8, 1; 10, 1.5; 12, 0; 14, -1; 16, 0];
s_values1 = [0.5, -0.3, 0.4, -0.2, 0.3, -0.4, 0.2, -0.1];

% Calculer les points S et tracer la courbe originale
[midpoints1, directions1] = compute_midpoints_and_directions(P1);
S_points1 = compute_spline_control_points(midpoints1, directions1, s_values1);
bezier_curve_points1 = construct_curve(P1, S_points1);

% Calculer les enveloppes \Gamma + \epsilon et \Gamma - \epsilon
[upper_envelope1, lower_envelope1] = compute_envelopes(bezier_curve_points1, epsilon);

% Calculer les poids pour chaque point
[weights1, ~, ~] = weight(P1, alpha, beta, gamma);

% Affichage de la courbe avec les enveloppes et les annotations de poids
plot_curve(P1, S_points1, s_values1, bezier_curve_points1, upper_envelope1, lower_envelope1, weights1);
title('Courbe Quelconque');

%% Courbe 2: Courbe Circulaire
theta = linspace(0, 2*pi, 50);
x_circle = cos(theta);
y_circle = sin(theta);
P2 = [x_circle', y_circle'];
s_values2 = zeros(1, size(P2, 1) - 1); % Aucune modification de spline

% Calculer les points S et tracer la courbe circulaire
[midpoints2, directions2] = compute_midpoints_and_directions(P2);
S_points2 = compute_spline_control_points(midpoints2, directions2, s_values2);
bezier_curve_points2 = construct_curve(P2, S_points2);

% Calculer les enveloppes \Gamma + \epsilon et \Gamma - \epsilon
[upper_envelope2, lower_envelope2] = compute_envelopes(bezier_curve_points2, epsilon);

% Calculer les poids pour chaque point
[weights2, ~, ~] = weight(P2, alpha, beta, gamma);

% Affichage de la courbe circulaire avec les enveloppes et les annotations de poids
plot_curve(P2, S_points2, s_values2, bezier_curve_points2, upper_envelope2, lower_envelope2, weights2);
title('Courbe Circulaire');

%% Courbe 3: Courbe avec Beaucoup de Points Proches
x_dense = linspace(0, 10, 100);
y_dense = sin(x_dense) + 0.1 * randn(1, 100); % Ajouter un peu de bruit
P3 = [x_dense', y_dense'];
s_values3 = 0.1 * randn(1, size(P3, 1) - 1); % Petits s pour de légères variations

% Calculer les points S et tracer la courbe dense
[midpoints3, directions3] = compute_midpoints_and_directions(P3);
S_points3 = compute_spline_control_points(midpoints3, directions3, s_values3);
bezier_curve_points3 = construct_curve(P3, S_points3);

% Calculer les enveloppes \Gamma + \epsilon et \Gamma - \epsilon
[upper_envelope3, lower_envelope3] = compute_envelopes(bezier_curve_points3, epsilon);

% Calculer les poids pour chaque point
[weights3, ~, ~] = weight(P3, alpha, beta, gamma);

% Affichage de la courbe dense avec les enveloppes et les annotations de poids
plot_curve(P3, S_points3, s_values3, bezier_curve_points3, upper_envelope3, lower_envelope3, weights3);
title('Courbe Dense avec Points Proches');
