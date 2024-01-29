function FEM_Approximation(epsilon, N)
    % Definiera nodpunkter
    x = linspace(epsilon, 1, N+1);
    
    % Initialisera systemmatrisen och högerledet
    A = zeros(N+1, N+1);
    b = zeros(N+1, 1);
    
    % Applicera randvillkor
    A(1,1) = 1; % För u_0 = 1
    b(1) = 1;
    A(N+1,N+1) = 1; % För u_N = 0
    b(N+1) = 0;
    
    % Fyll i A för de inre punkterna
    for i = 2:N
        h = x(i) - x(i-1);
        A(i, i-1) = 1/h;
        A(i, i) = -2/h;
        A(i, i+1) = 1/h;
    end

    % Löser systemet A*u = b
    u = A \ b;

    % Plotta lösningen
    figure;
    plot(x, u, '-o');
    title(['Lösning U för \epsilon = ', num2str(epsilon)]);
    xlabel('x');
    ylabel('U(x)');

end
