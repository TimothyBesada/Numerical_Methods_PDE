
fem_solution;

function fem_solution()
    N = 100;
    epsilons = [0.1, 0.01, 0.001, 0.0001, 0.00001];
    figure;
    hold on;
    for i = 1:length(epsilons)
        epsilon = epsilons(i);
        plot_solution(N, epsilon);
    end
    hold off;
    
    xlabel('x');
    ylabel('U(x)');
    title('Lösningar U(x) för olika \epsilon');
    legend(arrayfun(@(e) ['\epsilon=' num2str(e)], epsilons, 'UniformOutput', false));
end

function plot_solution(N, epsilon)
    nodes = linspace(epsilon, 1, N+1);
    u = solve_system(N, epsilon, nodes);
    
    x_values = linspace(epsilon, 1, 1000);
    U_values = zeros(size(x_values));
    
    for x_idx = 1:length(x_values)
        x = x_values(x_idx);
        for i = 1:N+1
            U_values(x_idx) = U_values(x_idx) + u(i) * phi(i, x, nodes);
        end
    end
    
    plot(x_values, U_values);
end

function val = phi(i, x, nodes)
    if i > 1 && i < length(nodes)
        if x < nodes(i-1) || x > nodes(i+1)
            val = 0;
        elseif x < nodes(i)
            val = (x - nodes(i-1)) / (nodes(i) - nodes(i-1));
        else
            val = (nodes(i+1) - x) / (nodes(i+1) - nodes(i));
        end
    else
        val = 0;
    end
end

function u = solve_system(N, epsilon, nodes)
    % Preallocate a sparse matrix for A
    A = sparse(N+1, N+1);
    
    % Options for increased precision of the numerical integration
    opts = {'ArrayValued', true, 'AbsTol', 1e-10, 'RelTol', 1e-8};
    
    % Compute diagonal entries for boundary nodes
    A(1, 1) = 1; % Dirichlet boundary at node 1
    A(N+1, N+1) = 1; % Dirichlet boundary at node N+1
    
    % Compute elements of A for interior nodes
    for i = 2:N
        A(i, i) = integral(@(x) x .* dphi_dx(i, x, nodes, N, epsilon).^2, epsilon, 1, opts{:});
        for j = [i-1, i+1] % Only adjacent nodes have non-zero entries
            A(i, j) = integral(@(x) x .* dphi_dx(i, x, nodes, N, epsilon) .* dphi_dx(j, x, nodes, N, epsilon), epsilon, 1, opts{:});
        end
    end
    
    
    % Apply the boundary conditions for u0 = 1 and uN = 0
    A(1, 1) = 1;
    A(N+1, N+1) = 1;
    
    b = zeros(N+1, 1); % Load vector
    b(1) = 1; % Boundary condition u0 = 1
    
    % Solve the linear system A * u = b
    u = A\b;
end

function val = dphi_dx(i, x, nodes, N, epsilon)
    % Derivative of the piecewise linear basis function
    h = (1 - epsilon) / N;
    val = zeros(size(x));
    
    if i == 2
            % First interior node, only right part contributes
            val(x >= nodes(i-1) & x < nodes(i)) = 1/h;
        elseif i == N
            % Last interior node, only left part contributes
            val(x > nodes(i) & x <= nodes(i+1)) = -1/h;
        elseif i > 2 && i < N
            % Interior nodes, both left and right parts contribute
            val(x > nodes(i-1) & x < nodes(i)) = 1/h;
            val(x >= nodes(i) & x < nodes(i+1)) = -1/h;
        end
end