function [Ptos_free, Ptos_Obst] = Delimita_Cfree(Ptos, entorno)
    N = size(Ptos, 1);   
    Ptos_free = zeros(0, 2); 
    Ptos_Obst = zeros(0, 2);
    
    mapa = extrae_obstaculo(0, entorno);
    ids_obst = unique(entorno(entorno(:,8) > 0, 8)); 

    for i = 1:N
        punto_actual = Ptos(i, :);
        
        % Debe estar DENTRO del mapa (ID 0)
        if verificar_Cfree(punto_actual, mapa)
            % Y debe estar FUERA de cada obstáculo
            choca = false;
            for j = 1:length(ids_obst)
                obst = extrae_obstaculo(ids_obst(j), entorno);
                if verificar_Cfree(punto_actual, obst)
                    choca = true;
                    break;
                end
            end
            
            if ~choca
                Ptos_free = [Ptos_free; punto_actual];
            else
                Ptos_Obst = [Ptos_Obst; punto_actual];
            end
        else
            Ptos_Obst = [Ptos_Obst; punto_actual];
        end
    end
end