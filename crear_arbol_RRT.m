tic; % Inicio del cronómetro global

% inicializar_RRT; (Asumimos que ya tienes definido: arbol, goal, start, etc.)
i = 1;
final = 0;
x0 = goal.x;
y0 = goal.y;
sesgo = 0.05;
long_rama = 1.5;
max_iteraciones = 2000; % Asegúrate de tener un límite razonable
min_distancia = 1.0;    % Umbral para conectar con la meta

while i < max_iteraciones && final == 0
    % Crear un nuevo nodo aleatorio
    nuevo_nodo = crear_nodo_RRT(lista_puntos, expandido, long_rama, 0, 20, 0, 20, [goal.x, goal.y], sesgo, i);
    
    % Obtener el nodo predecesor del árbol
    % Se suma 1 porque MATLAB empieza en índice 1 y el ID puede venir de 0
    predecesor = arbol(nuevo_nodo.predecesor + 1);
    
    % Verificar colisión en el nuevo segmento
    if Verfificar_Cfree_segmento([nuevo_nodo.x, nuevo_nodo.y], [predecesor.x, predecesor.y], expandido)
        
        % Actualizar el coste acumulado del nodo
        nuevo_nodo.coste = predecesor.coste + calcDist([nuevo_nodo.x, nuevo_nodo.y], [predecesor.x, predecesor.y]);
        
        % Añadirlo al árbol y a la lista de puntos
        arbol = [arbol nuevo_nodo];
        lista_puntos = [lista_puntos; [nuevo_nodo.x, nuevo_nodo.y]];
        
        % Dibujar la expansión del árbol (Cyan oscuro)
        plot(nuevo_nodo.x, nuevo_nodo.y, '+', 'color', [0 0.5 0.5]);
        line([nuevo_nodo.x, predecesor.x], [nuevo_nodo.y, predecesor.y], 'color', [0 0.5 0.5], 'LineStyle', ':');
        
        % Verificar si estamos cerca del objetivo (Goal)
        dist_meta = sqrt((x0 - nuevo_nodo.x)^2 + (y0 - nuevo_nodo.y)^2);
        if dist_meta < min_distancia
            if Verfificar_Cfree_segmento([nuevo_nodo.x, nuevo_nodo.y], [x0, y0], expandido)
                % Conectar con el goal final
                goal.predecesor = length(arbol) - 1; % Índice del último nodo añadido
                goal.coste = nuevo_nodo.coste + dist_meta;
                arbol = [arbol goal];
                
                line([nuevo_nodo.x, goal.x], [nuevo_nodo.y, goal.y], 'color', [0 0.8 0], 'LineWidth', 2);
                final = 1;
                fprintf('¡Objetivo alcanzado!\n');
            end
        end
    end
    i = i + 1;
end

tiempo_ejecucion = toc; % Fin del tiempo

%% 6. Dibujar Trayecto Final (Backtracking)
if final == 1
    tray = [goal.x, goal.y];
    % Empezamos desde el Goal y vamos hacia atrás usando los índices de 'predecesor'
    curr_idx = length(arbol); % El goal es el último en el árbol
    
    while curr_idx > 1
        % Obtener el índice del padre
        % Dependiendo de cómo guardes 'predecesor', puede ser ID o índice directo
        padre_idx = arbol(curr_idx).predecesor + 1; 
        
        % Guardar coordenadas para el dibujo
        tray = [tray; arbol(padre_idx).x, arbol(padre_idx).y];
        
        % Moverse al padre
        curr_idx = padre_idx;
        
        % Seguridad para evitar bucles infinitos si llegamos al start (ID 0)
        if curr_idx == 1, break; end
    end
    
    % Dibujar el camino óptimo en Rojo
    plot(tray(:,1), tray(:,2), 'r', 'LineWidth', 3);
    
    % Mostrar resultados en figura y consola
    Coste_Total = arbol(end).coste;
    res_str = sprintf('RRT: Coste = %.2f | Tiempo = %.4f s', Coste_Total, tiempo_ejecucion);
    title(res_str);
    
    fprintf('Coste Total: %.2f\n', Coste_Total);
    fprintf('Tiempo: %.4f s\n', tiempo_ejecucion);
else
    title('RRT: No se encontró camino (Límite de iteraciones)');
    fprintf('RRT falló tras %d iteraciones.\n', max_iteraciones);
end