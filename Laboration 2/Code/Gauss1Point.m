function [K_local, F_local] = Gauss1Point(x_left, x_right, a, f, h)
    % Enpunkts Gausskvadratur
    xi = 0;
    w = h;
    
    % Beräkna Gausspunkt i globala koordinater
    x_gauss = (x_left + x_right)/2 + h/2 * xi;
    % Formfunktioner och deras derivator
    N = [(1 - xi)/2, (1 + xi)/2];
    dNdx = [-1/h, 1/h];
    
    % Beräkna bidrag
    K_local = a(x_gauss) * (dNdx' * dNdx) * w;
    F_local = f(x_gauss) * N' * w;
end
