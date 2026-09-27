function dentro = verificar_Cfree(punto, poligono)
    % Detecta si un punto está dentro de un polígono (id_actual)
    if isempty(poligono)
        dentro = 0; return; 
    end
    
    x = punto(1); y = punto(2);
    dentro = false;
    m = size(poligono, 1);
    
    for i = 1:m
        x1 = poligono(i, 1); y1 = poligono(i, 2);
        x2 = poligono(i, 4); y2 = poligono(i, 5);
        
        % Algoritmo de cruce de aristas
        if ((y1 > y) ~= (y2 > y)) && ...
           (x < (x2 - x1) * (y - y1) / (y2 - y1) + x1)
            dentro = ~dentro;
        end
    end
end