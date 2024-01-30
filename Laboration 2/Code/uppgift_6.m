close all;
clear all;

N = 1000;
epsilon_values = [0.1, 0.01, 0.001, 0.0001, 0.00001];

figure;
hold on;

for epsilon = epsilon_values
    x = linspace(epsilon, 1, N+1); % Nodal points

    % Initialize stiffness matrix A and load vector b
    A = zeros(N+1);
    b = zeros(N+1, 1);

    % Assembly of stiffness matrix A
    for i = 1:N
        h = x(i+1) - x(i);
        
        xi = x(i);
        xi1 = x(i+1);
        A(i,i) = A(i,i) + (xi1^2 - xi^2)/(2*h);
        A(i,i+1) = A(i,i+1) - (xi1^2 - xi^2)/(2*h);
        A(i+1,i) = A(i+1,i) - (xi1^2 - xi^2)/(2*h);
        A(i+1,i+1) = A(i+1,i+1) + (xi1^2 - xi^2)/(2*h);
    end

    % Apply boundary conditions
    A(1,:) = 0; A(1,1) = 1; b(1) = 1; % u_0 = 1
    A(N+1,:) = 0; A(N+1,N+1) = 1; b(N+1) = 0; % u_N = 0

    u = A\b;

    plot(x, u, 'DisplayName', sprintf('\\epsilon = %g', epsilon));
end

hold off;
xlabel('x');
ylabel('U(x)');
ylim([0, 1]);
title('Approximation of U(x) using FEM for various \epsilon');
legend show;