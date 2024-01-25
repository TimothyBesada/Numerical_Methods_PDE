clear all;
close all;

% Parametrar
n_elements = 100;
n_nodes = n_elements + 1;
g = 1; % Värmeflöde vid x = 1

% Fall 1: a(x)=1+x, f(x)=0
a1 = @(x) 1 + x;
f1 = @(x) zeros(size(x));

% Fall 2: a(x)=e^x, f(x)=e^x
a2 = @(x) exp(x);
f2 = @(x) exp(x);

nodes = linspace(0, 1, n_nodes)'; % Noder

% Använd FEM för fall 1 med tvåpunkts Gausskvadratur
[u_1, ~, ~] = FEM(n_elements, a1, f1, g, @Gauss2Points);

% Använd FEM för fall 2 med tvåpunkts Gausskvadratur
[u_2, ~, ~] = FEM(n_elements, a2, f2, g, @Gauss2Points);

% Visualisera resultaten i en gemensam plot
plot(nodes, u_1, 'r-', 'DisplayName', 'Fall 1: a(x)=1+x, f(x)=0');
hold on;
plot(nodes, u_2, 'b--', 'DisplayName', 'Fall 2: a(x)=e^x, f(x)=e^x');
hold off;

% Lägg till beskrivningar och en legend
xlabel('Position längs staven');
ylabel('Temperatur');
title('Lösningar för olika a(x) och f(x)');
legend('Location', 'southeast'); % Visa legenden
