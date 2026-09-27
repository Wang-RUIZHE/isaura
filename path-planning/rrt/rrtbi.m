% rrtbi.m
t_inicio = tic; 
i = 1; final = 0;

while i < max_iteraciones && final == 0
    % --- ÁRBOL 1 (Inicio -> Meta) ---
    nuevo_nodo = crear_nodo_RRT(lista_puntos, expandido, long_rama, 0, 21, 0, 21, [goal.x, goal.y], sesgo, i);
    
    idx_p1 = nuevo_nodo.predecesor + 1;
    if idx_p1 > length(arbol), idx_p1 = length(arbol); end
    padre1 = arbol(idx_p1);
    
    if Verfificar_Cfree_segmento([nuevo_nodo.x, nuevo_nodo.y], [padre1.x, padre1.y], expandido)
        nuevo_nodo.coste = padre1.coste + nuevo_nodo.coste;
        % Concatenación segura de estructuras
        arbol(end+1) = nuevo_nodo; 
        lista_puntos = [lista_puntos; [nuevo_nodo.x nuevo_nodo.y]];
        
        plot(nuevo_nodo.x, nuevo_nodo.y, '+', 'Color', [0 0.5 0.5]);
        line([nuevo_nodo.x, padre1.x], [nuevo_nodo.y, padre1.y], 'Color', [0 0.5 0.5]);
        
        % Revisar conexión con Arbol 2
        for j = 1:length(arbol2)
            if sqrt((nuevo_nodo.x-arbol2(j).x)^2 + (nuevo_nodo.y-arbol2(j).y)^2) < min_distancia
                if Verfificar_Cfree_segmento([nuevo_nodo.x, nuevo_nodo.y], [arbol2(j).x, arbol2(j).y], expandido)
                    idx_arbol1 = length(arbol);
                    idx_arbol2 = j;
                    final = 1; break;
                end
            end
        end
    end
    
    if final; break; end

    % --- ÁRBOL 2 (Meta -> Inicio) ---
    nuevo_nodo2 = crear_nodo_RRT(lista_puntos2, expandido, long_rama, 0, 21, 0, 21, [start.x, start.y], sesgo, i);
    
    idx_p2 = nuevo_nodo2.predecesor + 1;
    if idx_p2 > length(arbol2), idx_p2 = length(arbol2); end
    padre2 = arbol2(idx_p2);
    
    if Verfificar_Cfree_segmento([nuevo_nodo2.x, nuevo_nodo2.y], [padre2.x, padre2.y], expandido)
        nuevo_nodo2.coste = padre2.coste + nuevo_nodo2.coste;
        arbol2(end+1) = nuevo_nodo2;
        lista_puntos2 = [lista_puntos2; [nuevo_nodo2.x nuevo_nodo2.y]];
        
        plot(nuevo_nodo2.x, nuevo_nodo2.y, '+', 'Color', [0.5 0 0.5]);
        line([nuevo_nodo2.x, padre2.x], [nuevo_nodo2.y, padre2.y], 'Color', [0.5 0 0.5]);
        
        for j = 1:length(arbol)
            if sqrt((nuevo_nodo2.x-arbol(j).x)^2 + (nuevo_nodo2.y-arbol(j).y)^2) < min_distancia
                if Verfificar_Cfree_segmento([nuevo_nodo2.x, nuevo_nodo2.y], [arbol(j).x, arbol(j).y], expandido)
                    idx_arbol2 = length(arbol2);
                    idx_arbol1 = j;
                    final = 1; break;
                end
            end
        end
    end
    i = i + 1;
    drawnow limitrate;
end
t_final = toc(t_inicio);

%% Reconstrucción y Resultados
if final
    % Trayectoria desde Árbol 1
    tray1 = []; curr = arbol(idx_arbol1);
    while true
        tray1 = [tray1; curr.x, curr.y];
        if curr.coste == 0, break; end % Llegamos al inicio
        curr = arbol(curr.predecesor + 1);
    end
    tray1 = flipud(tray1);
    
    % Trayectoria desde Árbol 2
    tray2 = []; curr = arbol2(idx_arbol2);
    while true
        tray2 = [tray2; curr.x, curr.y];
        if curr.coste == 0, break; end % Llegamos a la meta
        curr = arbol2(curr.predecesor + 1);
    end
    
    Trayectoria = [tray1; tray2];
    plot(Trayectoria(:,1), Trayectoria(:,2), 'r', 'LineWidth', 3);
    
    Coste_Total = arbol(idx_arbol1).coste + arbol2(idx_arbol2).coste;
    info_str = {['Algoritmo: Bi-RRT'], ['Coste: ', num2str(Coste_Total, '%.2f')], ...
                ['Iteraciones: ', num2str(i)], ['Tiempo: ', num2str(t_final, '%.2f'), 's']};
    text(0.5, 20.5, info_str, 'BackgroundColor', 'w', 'EdgeColor', 'k');
    title('Bi-RRT: Camino Encontrado');
else
    title('Bi-RRT: No se encontró camino');
end