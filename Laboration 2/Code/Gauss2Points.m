function [K_local, F_local] = Gauss2Points(x_left, x_right, a, f, h)
    % Tvåpunkts Gausskvadratur
    xi = [-1/sqrt(3), 1/sqrt(3)];
    w = [1, 1] * h/2;
    
    % Initialisera lokala matriser
    K_local = zeros(2, 2);
    F_local = zeros(2, 1);
    
    % Beräkna bidrag till styvhetsmatris och lastvektor
    for j = 1:length(w)
        % Beräkna Gausspunkt i globala koordinater
        x_gauss = (x_left + x_right)/2 + h/2 * xi(j);
        % Formfunktioner och deras derivator
        N = [(1 - xi(j))/2, (1 + xi(j))/2];
        dNdx = [-1/h, 1/h];
        
        % Beräkna bidrag
        K_local = K_local + a(x_gauss) * (dNdx' * dNdx) * w(j);
        F_local = F_local + f(x_gauss) * N' * w(j);
    end
end
