%% 1. Preparación (Asume que ya corriste inicializar_RRT)
tic; 
i = 1;
x0 = goal.x; 
y0 = goal.y;
final = 0;

% --- VARIABLES FALTANTES ---
sesgo = 0.1;           % Probabilidad de ir hacia la meta (antes no definida)
max_iteraciones = 2000; % Límite de intentos
long_rama = 1.0;       % Distancia de cada paso
min_distancia = 1.5;   % Umbral para llegar al objetivo
% ---------------------------

% Límites del mapa
x_min = 0; x_max = 20;
y_min = 0; y_max = 20;

%% 2. Bucle Principal
while i < max_iteraciones && final == 0
    % Llamamos a la función que acabamos de crear
    nuevo_nodo = crear_nodo_RRT(lista_puntos, expandido, long_rama, x_min, x_max, y_min, y_max, [goal.x, goal.y], sesgo, i);
    
    % Referencia al nodo padre en el árbol
    predecesor = arbol(nuevo_nodo.predecesor + 1);
    
    % Verificación de colisión (C-Free)
    if Verfificar_Cfree_segmento([nuevo_nodo.x, nuevo_nodo.y], [predecesor.x, predecesor.y], expandido)
        
        % Cálculo de coste acumulado
        dist_segmento = sqrt((nuevo_nodo.x - predecesor.x)^2 + (nuevo_nodo.y - predecesor.y)^2);
        nuevo_nodo.coste = predecesor.coste + dist_segmento;
        
        % Actualizar árbol y lista de búsqueda
        arbol = [arbol nuevo_nodo];
        lista_puntos = [lista_puntos; [nuevo_nodo.x, nuevo_nodo.y]];
        
        % Dibujo en tiempo real
        plot(nuevo_nodo.x, nuevo_nodo.y, '.', 'Color', [0 0.5 0.8]);
        line([nuevo_nodo.x, predecesor.x], [nuevo_nodo.y, predecesor.y], 'Color', [0 0.5 0.8, 0.3]);
        
        % Check de llegada a meta
        dist_a_goal = sqrt((x0 - nuevo_nodo.x)^2 + (y0 - nuevo_nodo.y)^2);
        if dist_a_goal < min_distancia
            if Verfificar_Cfree_segmento([nuevo_nodo.x, nuevo_nodo.y], [x0, y0], expandido)
                goal.predecesor = length(arbol) - 1;
                goal.coste = nuevo_nodo.coste + dist_a_goal;
                arbol = [arbol goal];
                
                line([nuevo_nodo.x, x0], [nuevo_nodo.y, y0], 'Color', [0 0.8 0], 'LineWidth', 2);
                final = 1;
                fprintf('¡RRT encontró el camino!\n');
            end
        end
    end
    i = i + 1;
    if mod(i, 50) == 0, drawnow; end 
end
tiempo_total = toc;

%% 3. Backtracking (Dibujar ruta final)
if final == 1
    % ... (Tu código de dibujo de ruta roja se mantiene igual)
end