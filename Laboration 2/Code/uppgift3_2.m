clear all;
close all;

% Parametrar
g = 1;
element_sizes = [10, 20, 40, 80, 160, 320, 640, 1280]; % Exempel på olika elementstorlekar att testa
errors_1_point = zeros(size(element_sizes));
errors_2_points = zeros(size(element_sizes));
times_1_point = zeros(size(element_sizes));
times_2_points = zeros(size(element_sizes));

% Fall 1: a(x)=1+x, f(x)=0
a1 = @(x) 1 + x;
f1 = @(x) zeros(size(x));

% Fall 2: a(x)=e^x, f(x)=e^x
a2 = @(x) exp(x);
f2 = @(x) exp(x);

% Referenslösning med mycket fin nätindelning
n_elements_ref = 10000;
[u_ref, ~, ~] = FEM_Gauss(n_elements_ref, a1, f1, g, @Gauss2Points);

% Loop över de olika elementstorlekarna
for i = 1:length(element_sizes)
    n_elements = element_sizes(i);
    
    % Enpunkts Gausskvadratur
    tic;
    [u_1, ~, ~] = FEM_Gauss(n_elements, a1, f1, g, @Gauss1Point);
    times_1_point(i) = toc;
    errors_1_point(i) = L2Error(u_1, u_ref, n_elements, n_elements_ref);
    
    % Tvåpunkts Gausskvadratur
    tic;
    [u_2, ~, ~] = FEM_Gauss(n_elements, a1, f1, g, @Gauss2Points);
    times_2_points(i) = toc;
    errors_2_points(i) = L2Error(u_2, u_ref, n_elements, n_elements_ref);
end

% Log-log plot av fel mot antal element
loglog(element_sizes, errors_1_point, 'r--', 'DisplayName', 'Enpunkts Gausskvadratur');
hold on;
loglog(element_sizes, errors_2_points, 'b-', 'DisplayName', 'Tvåpunkts Gausskvadratur');
hold off;

% Lägg till beskrivningar och en legend
xlabel('Antal element');
ylabel('L^2-norm av felet');
title('Beräkningskomplexitet för FEM_Gauss med olika Gausskvadraturer');
legend('Location', 'northeast'); % Visa legenden

% Funktion för att beräkna L^2-normen av felet
function error = L2Error(u, u_ref, n_elements, n_elements_ref)
    % Antalet noder är n_elements + 1
    n_nodes = n_elements + 1;

    % Interpolera u till samma noder som u_ref
    nodes = linspace(0, 1, n_nodes); % Lägg till denna rad
    nodes_ref = linspace(0, 1, n_elements_ref + 1)';
    u_interp = interp1(nodes, u, nodes_ref, 'linear', 'extrap');

    % Beräkna kvadraten på skillnaden
    error_squared = (u_interp - u_ref).^2;

    % Integrera över intervallet [0,1] för att få L^2-normen av felet
    % Eftersom u_ref är mycket finare kan vi använda trapetsmetoden för approximation
    error = sqrt(trapz(nodes_ref, error_squared));
end

