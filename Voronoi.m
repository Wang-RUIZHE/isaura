clear; clc; close all;

%% ============================================================
% Planificacion de trayectorias basada en Voronoi y obstaculos
% Sin utilizar el toolbox de Matlab
%
% Funciones proporcionadas en las practicas:
% 1. entorno1.m        Cargar entorno y obstaculos
% 2. inter_seg.m       Comprobar interseccion entre segmentos
% 3. Dijkstra.m        Buscar el camino minimo en el grafo
% 4. dib_rectas2.m     Dibujar aristas del roadmap
%
% Procedimiento:
% 1. Cargar entorno
% 2. Extraer los seeds de Voronoi
% 3. Construccion manual de las aristas Voronoi
% 4. Eliminar aristas en colision
% 5. Construir el grafo
% 6. Buscar el camino minimo con Dijkstra
%% ============================================================


%% ============================================================
% 1. Cargar entorno
%% ============================================================

ent = entorno1();

figure;
hold on;
axis equal;
grid on;

xlim([0 21]);
ylim([0 21]);

xlabel('X');
ylabel('Y');

title('Voronoi basado en obstaculos sin toolbox');


%% ============================================================
% 2. Dibujar limites y obstaculos
%% ============================================================

for i = 1:size(ent,1)

    p1 = ent(i,1:2);
    p2 = ent(i,4:5);

    if ent(i,8) == 0

        plot([p1(1) p2(1)], ...
             [p1(2) p2(2)], ...
             'k', ...
             'LineWidth',1);

    else

        plot([p1(1) p2(1)], ...
             [p1(2) p2(2)], ...
             'b', ...
             'LineWidth',1);
    end
end


%% ============================================================
% 3. Extraer los seeds de Voronoi
% Muestreo denso del contorno exterior
% Utilizar vertices de obstaculos
% Las puertas no participan como seeds
%% ============================================================

P = [];

paso_borde = 1.0;

for i = 1:size(ent,1)

    p1 = ent(i,1:2);
    p2 = ent(i,4:5);

    % Contorno exterior
    if ent(i,8) == 0

        longitud = norm(p2-p1);

        n_puntos = max(2, ceil(longitud/paso_borde));

        for s = linspace(0,1,n_puntos)

            p = p1 + s*(p2-p1);

            P = [P; p];
        end

    % Obstaculos cerrados
    elseif ent(i,8) >= 2

        P = [P;
             p1;
             p2];
    end
end

P = unique(round(P,4),'rows');


%% ============================================================
% 4. Construccion manual de las aristas Voronoi
%% ============================================================

aristas = [];

paso = 0.12;
L = 35;

for i = 1:size(P,1)

    for j = i+1:size(P,1)

        pi = P(i,:);
        pj = P(j,:);

        m = (pi + pj)/2;

        v = pj - pi;

        normal = [-v(2), v(1)];

        if norm(normal)==0
            continue;
        end

        normal = normal / norm(normal);

        puntos_borde = [];

        for t = -L:paso:L

            q = m + t*normal;

            % Fuera del mapa
            if q(1)<0 || q(1)>21 || ...
               q(2)<0 || q(2)>21

                continue;
            end

            % Punto dentro de un obstaculo
            if punto_en_obstaculo(q,ent)

                continue;
            end

            % Distancia a todos los seeds
            d = sqrt((P(:,1)-q(1)).^2 + ...
                     (P(:,2)-q(2)).^2);

            [~,idx] = sort(d);

            % Condicion de Voronoi
            if (idx(1)==i && idx(2)==j) || ...
               (idx(1)==j && idx(2)==i)

                puntos_borde = [puntos_borde; q];
            end
        end


        %% ====================================================
        % Conectar puntos de muestreo
        %% ====================================================

        if size(puntos_borde,1) > 1

            for k = 1:size(puntos_borde,1)-1

                p1 = puntos_borde(k,:);
                p2 = puntos_borde(k+1,:);

                if norm(p2-p1) < 2.5*paso

                    if ~segmento_corta_obstaculo(p1,p2,ent)

                        aristas = [aristas;
                                   p1 p2];
                    end
                end
            end
        end
    end
end


%% ============================================================
% Dibujar roadmap Voronoi
%% ============================================================

dib_rectas2(aristas,'g');


%% ============================================================
% 5. Definir punto inicial y objetivo
%% ============================================================

inicio = [2 2];
objetivo = [18 14];

plot(inicio(1), ...
     inicio(2), ...
     'go', ...
     'MarkerFaceColor','m', ...
     'MarkerSize',3);

plot(objetivo(1), ...
     objetivo(2), ...
     'mo', ...
     'MarkerFaceColor','m', ...
     'MarkerSize',3);


%% ============================================================
% 6. Extraer nodos del roadmap Voronoi
%% ============================================================

nodos = [];

tol_nodo = 0.20;

for i = 1:size(aristas,1)

    p1 = aristas(i,1:2);
    p2 = aristas(i,3:4);

    nodos = agregar_nodo(nodos,p1,tol_nodo);
    nodos = agregar_nodo(nodos,p2,tol_nodo);
end


%% ============================================================
% 7. Anadir inicio y objetivo al grafo
%% ============================================================

nodos = [nodos;
         inicio;
         objetivo];

id_inicio = size(nodos,1)-1;
id_objetivo = size(nodos,1);


%% ============================================================
% 8. Construir matriz de costes para Dijkstra
%% ============================================================

M = size(nodos,1);

matriz_costes = Inf(M,M);

for i = 1:M
    matriz_costes(i,i) = 0;
end


%% ============================================================
% 9. Conectar nodos cercanos sin colision
%% ============================================================

radio = 1;

for i = 1:M

    for j = i+1:M

        p1 = nodos(i,:);
        p2 = nodos(j,:);

        if norm(p1-p2) < radio

            if ~segmento_corta_obstaculo(p1,p2,ent)

                coste = norm(p1-p2);

                matriz_costes(i,j) = coste;
                matriz_costes(j,i) = coste;
            end
        end
    end
end


%% ============================================================
% 10. Buscar el camino usando Dijkstra.m
%% ============================================================

[Camino, Coste] = Dijkstra( ...
    matriz_costes, ...
    id_inicio, ...
    id_objetivo);


%% ============================================================
% 11. Dibujar trayectoria final
%% ============================================================

if ~isinf(Coste)

    for i = 1:length(Camino)-1

        p1 = nodos(Camino(i),:);
        p2 = nodos(Camino(i+1),:);

        plot([p1(1) p2(1)], ...
             [p1(2) p2(2)], ...
             'k', ...
             'LineWidth',1);
    end

    disp('Camino encontrado');
    disp(['Coste del camino = ', num2str(Coste)]);

else

    disp('No se encontro un camino');
    disp('Se puede aumentar el valor de radio');

end


%% ============================================================
% 12. Mostrar informacion
%% ============================================================

disp(['Numero de aristas Voronoi = ', num2str(size(aristas,1))]);
disp(['Numero de nodos del grafo = ', num2str(size(nodos,1))]);


%% ============================================================
% Funcion 1:
% Comprobar si un punto esta dentro de un obstaculo
%% ============================================================

function dentro = punto_en_obstaculo(q, ent)

    dentro = false;

    ids = unique(ent(:,8));
    ids = ids(ids > 0);

    for i = 1:length(ids)

        filas = ent(ent(:,8)==ids(i),:);

        xs = [filas(:,1); filas(:,4)];
        ys = [filas(:,2); filas(:,5)];

        xmin = min(xs);
        xmax = max(xs);

        ymin = min(ys);
        ymax = max(ys);

        if q(1) >= xmin && q(1) <= xmax && ...
           q(2) >= ymin && q(2) <= ymax

            dentro = true;
            return;
        end
    end
end


%% ============================================================
% Funcion 2:
% Comprobar interseccion con obstaculos
%% ============================================================

function corta = segmento_corta_obstaculo(p1,p2,ent)

    corta = false;

    for i = 1:size(ent,1)

        % No comprobar el contorno exterior
        if ent(i,8) == 0
            continue;
        end

        q1 = ent(i,1:2);
        q2 = ent(i,4:5);

        % Uso de la funcion inter_seg.m
        pc = inter_seg(p1,p2,q1,q2);

        % pc(3)=1 indica interseccion
        if pc(3) == 1

            corta = true;
            return;
        end
    end
end


%% ============================================================
% Funcion 3:
% Anadir nodos al grafo
%% ============================================================

function nodos = agregar_nodo(nodos,p,tol)

    if isempty(nodos)

        nodos = p;
        return;
    end

    d = sqrt((nodos(:,1)-p(1)).^2 + ...
             (nodos(:,2)-p(2)).^2);

    % Evitar nodos duplicados o muy cercanos
    if min(d) > tol

        nodos = [nodos; p];
    end
end