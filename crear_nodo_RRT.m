%% 1. Inicialización de Estructuras RRT
% Definimos el punto de inicio (Start)
start.x = 1; 
start.y = 1;
start.predecesor = 0; % El inicio no tiene padre
start.coste = 0;

% Definimos el punto objetivo (Goal)
goal.x = 20; 
goal.y = 20;
goal.predecesor = []; 
goal.coste = 0;

% Inicializamos el árbol con el nodo de inicio
arbol = start; 

% Inicializamos la lista de puntos (para búsqueda de cercanía)
lista_puntos = [start.x, start.y];

% Parámetros del algoritmo
max_iteraciones = 2000;
min_distancia = 1.5;   % Distancia para considerar que llegamos a la meta
sesgo = 0.1;           % Probabilidad de ir directo al goal (0.1 = 10%)
long_rama = 1.0;       % Paso de expansión
final = 0;

%% 2. Bucle Principal RRT
tic; % Iniciamos el tiempo
i = 1;
x0 = goal.x; % Ahora goal.x ya existe
y0 = goal.y;

while i < max_iteraciones && final == 0
    % Crear un nuevo nodo aleatorio
    % Nota: Asegúrate que tu función 'crear_nodo_RRT' devuelva una estructura con .x, .y y .predecesor
    nuevo_nodo = crear_nodo_RRT(lista_puntos, expandido, long_rama, 0, 21, 0, 21, [goal.x, goal.y], sesgo, i);
    
    % Extraer coordenadas y predecesor
    x = nuevo_nodo.x;
    y = nuevo_nodo.y;
    predecesor = arbol(nuevo_nodo.predecesor + 1);
    
    % Verificar si el segmento está libre de obstáculos
    if Verfificar_Cfree_segmento([x, y], [predecesor.x, predecesor.y], expandido)
        
        % Calcular coste acumulado
        nuevo_nodo.coste = predecesor.coste + sqrt((x - predecesor.x)^2 + (y - predecesor.y)^2);
        
        % Añadir al árbol y a la lista
        arbol = [arbol nuevo_nodo];
        lista_puntos = [lista_puntos; [x, y]];
        
        % Dibujar expansión en vivo
        plot(x, y, '.', 'Color', [0 0.5 0.8]);
        line([x, predecesor.x], [y, predecesor.y], 'Color', [0 0.5 0.8, 0.5]);
        
        % Verificar si el nodo nuevo está cerca del objetivo
        if sqrt((x0-x)^2 + (y0-y)^2) < min_distancia
            if Verfificar_Cfree_segmento([x, y], [x0, y0], expandido)
                goal.predecesor = length(arbol) - 1;
                goal.coste = nuevo_nodo.coste + sqrt((x0-x)^2 + (y0-y)^2);
                arbol = [arbol goal];
                
                line([x, x0], [y, y0], 'Color', [0 0.8 0], 'LineWidth', 2);
                final = 1;
            end
        end
    end
    i = i + 1;
    if mod(i, 100) == 0, drawnow; end % Refrescar gráfica cada 100 iters
end
tiempo_rrt = toc;

%% 3. Dibujar Trayecto y Mostrar Resultados
if final == 1
    % Reconstrucción del camino (Backtracking)
    tray = [goal.x, goal.y];
    curr_idx = length(arbol);
    
    while curr_idx > 1
        padre_idx = arbol(curr_idx).predecesor + 1;
        tray = [tray; arbol(padre_idx).x, arbol(padre_idx).y];
        curr_idx = padre_idx;
        if curr_idx == 1, break; end
    end
    
    % Dibujar ruta final
    plot(tray(:,1), tray(:,2), 'r', 'LineWidth', 4);
    
    % Mostrar datos en la figura
    res_str = sprintf('RRT: Coste = %.2f | Tiempo = %.4f s', arbol(end).coste, tiempo_rrt);
    title(res_str, 'FontSize', 12);
    
    fprintf('RRT completado en %.4f segundos. Coste: %.2f\n', tiempo_rrt, arbol(end).coste);
else
    title('RRT: No se encontró solución');
end