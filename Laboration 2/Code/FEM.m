function [u, K_global, F_global] = FEM(n_elements, a, f, g, GaussQuadrature)
    n_nodes = n_elements + 1;
    h = 1 / n_elements;
    nodes = linspace(0, 1, n_nodes)';
    
    % Initialisera globala matriser
    K_global = zeros(n_nodes);
    F_global = zeros(n_nodes, 1);
    
    % Konstruktion av systemet
    for i = 1:n_elements
        % Nodpositioner för detta element
        x_left = nodes(i);
        x_right = nodes(i+1);
        
        % Beräkna bidrag till styvhetsmatris och lastvektor med angiven Gausskvadratur
        [K_local, F_local] = GaussQuadrature(x_left, x_right, a, f, h);
        
        % Uppdatera globala matriser
        global_indices = [i, i+1];
        K_global(global_indices, global_indices) = K_global(global_indices, global_indices) + K_local;
        F_global(global_indices) = F_global(global_indices) + F_local;
    end
    
    % Tillämpa randvillkor
    K_global(1, :) = 0;
    K_global(1, 1) = 1;
    F_global(1) = 0;
    F_global(end) = F_global(end) + g * h;
    
    % Lös ekvationssystemet
    u = K_global \ F_global;
end
