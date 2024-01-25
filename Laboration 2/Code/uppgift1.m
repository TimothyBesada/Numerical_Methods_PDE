clear all;
close all;

% Parametrar
n_elements = 100;
n_elements_ref = 10000;
n_nodes = n_elements + 1;
g = 1;

% Funktioner
a = @(x) exp(x);
f = @(x) exp(x);

nodes = linspace(0, 1, n_nodes)'; % Noder
nodes_ref = linspace(0, 1, n_elements_ref + 1)';

% Använd FEM med enpunkts Gausskvadratur
[u_1, K_global_1, F_global_1] = FEM(n_elements, a, f, g, @Gauss1Point);

% Använd FEM med tvåpunkts Gausskvadratur
[u_2, K_global_2, F_global_2] = FEM(n_elements, a, f, g, @Gauss2Points);

% Beräkna referenslösningen
[u_ref, ~, ~] = FEM(n_elements_ref, a, f, g, @Gauss2Points);

% Visualisera resultaten i en gemensam plot
plot(nodes, u_1, 'r--', 'DisplayName', 'Enpunkts Gausskvadratur');
hold on;
plot(nodes, u_2, 'b-', 'DisplayName', 'Tvåpunkts Gausskvadratur');
plot(nodes_ref, u_ref, 'g', 'DisplayName', 'Referenslösning');
hold off;

% Lägg till beskrivningar och en legend
xlabel('Position längs staven');
ylabel('Temperatur');
title('Jämförelse av FEM med olika Gausskvadraturer och referenslösning');
legend('Location', 'southeast'); % Visa legenden
