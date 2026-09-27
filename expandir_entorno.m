function sal1 = expandir_entorno(entorno, d)
    sal1 = [];
    if isempty(entorno), return; end
    ids_objetos = unique(entorno(:,8));
    
    for k = 1:length(ids_objetos)
        id_actual = ids_objetos(k);
        obj = entorno(entorno(:,8) == id_actual, :);
        m = size(obj, 1);
        
        if id_actual == 1 % Caso Muros (ID 1)
            for i = 1:m
                sal1 = [sal1; crear_paralela_muro(obj(i,:), d)];
                sal1 = [sal1; crear_paralela_muro(obj(i,:), -d)];
            end
            continue;
        end
        
        % Perímetro (0) se encoge, Obstáculos crecen
        dist = -d; 
        if id_actual == 0, dist = d; end 
        
        V = [obj(:,1), obj(:,2)];
        V_exp = zeros(m, 2);
        for i = 1:m
            v_ant = V(mod(i-2, m) + 1, :);
            v_act = V(i, :);
            v_sig = V(mod(i, m) + 1, :);
            
            L1 = (v_act - v_ant) / (norm(v_act - v_ant) + 1e-6);
            L2 = (v_sig - v_act) / (norm(v_sig - v_act) + 1e-6);
            n1 = [-L1(2), L1(1)];
            n2 = [-L2(2), L2(1)];
            
            bisectriz = (n1 + n2);
            denominador = (1 + dot(n1, n2));
            if denominador < 0.1
                V_exp(i, :) = v_act + dist * n1;
            else
                V_exp(i, :) = v_act + (dist * bisectriz / denominador);
            end
        end
        
        obj_nuevo = obj;
        for i = 1:m
            idx_sig = mod(i, m) + 1;
            obj_nuevo(i, 1:2) = V_exp(i, :);     
            obj_nuevo(i, 4:5) = V_exp(idx_sig, :); 
            % Recalcular Normal para que apunte hacia el interior del objeto
            dx = obj_nuevo(i, 4) - obj_nuevo(i, 1);
            dy = obj_nuevo(i, 5) - obj_nuevo(i, 2);
            obj_nuevo(i, 7) = atan2(dx, -dy); 
        end
        sal1 = [sal1; obj_nuevo];
    end
end

function seg_out = crear_paralela_muro(seg, d)
    dx = seg(4) - seg(1); dy = seg(5) - seg(2);
    L = sqrt(dx^2 + dy^2);
    nx = -dy/L; ny = dx/L;
    seg_out = seg;
    seg_out(1) = seg(1) + d*nx; seg_out(2) = seg(2) + d*ny;
    seg_out(4) = seg(4) + d*nx; seg_out(5) = seg(5) + d*ny;
    seg_out(7) = atan2(dx, -dy);
end