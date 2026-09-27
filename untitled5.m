clear; clc; close all;

%% ============================================================
% 基于障碍物的 Voronoi 路径规划
% 不使用 Matlab toolbox
%
% 显示内容：
% 黑色：地图外边界
% 蓝色：障碍物
% 绿色：Voronoi roadmap
% 红色：最终路径
%% ============================================================

%% 1. 参数设置

mostrar_puntos = false;     % false = 不显示采样点
paso_borde = 1.0;           % 外边界采样间隔
paso = 0.12;                % Voronoi 采样步长
L = 35;                     % 垂直平分线采样长度
tol_nodo = 0.20;            % 节点合并容差

inicio = [2 2];
objetivo = [18 14];

K_conexion = 100;             % 起点/终点连接到最近几个 Voronoi 节点

%% 2. 加载环境

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

%% 3. 绘制地图

for i = 1:size(ent,1)

    p1 = ent(i,1:2);
    p2 = ent(i,4:5);

    if ent(i,8) == 0
        plot([p1(1) p2(1)], ...
             [p1(2) p2(2)], ...
             'k', ...
             'LineWidth',2);
    else
        plot([p1(1) p2(1)], ...
             [p1(2) p2(2)], ...
             'b', ...
             'LineWidth',2);
    end
end

%% 4. 提取 Voronoi 生成点
% 外边界 id=0：沿边界加密采样
% 封闭障碍物 id>=2：取障碍物角点
% 中间墙段 id=1：不作为 Voronoi seeds，只用于碰撞检测

P = [];

for i = 1:size(ent,1)

    p1 = ent(i,1:2);
    p2 = ent(i,4:5);

    if ent(i,8) == 0

        longitud = norm(p2-p1);
        n_puntos = max(2, ceil(longitud/paso_borde));

        for s = linspace(0,1,n_puntos)

            p = p1 + s*(p2-p1);
            P = [P; p];
        end

    elseif ent(i,8) >= 2

        P = [P;
             p1;
             p2];
    end
end

P = unique(round(P,4),'rows');

if mostrar_puntos
    plot(P(:,1), ...
         P(:,2), ...
         'ro', ...
         'MarkerFaceColor','r', ...
         'MarkerSize',4);
end

%% 5. 手动构造 Voronoi 边

aristas = [];

for i = 1:size(P,1)

    for j = i+1:size(P,1)

        pi = P(i,:);
        pj = P(j,:);

        m = (pi + pj)/2;
        v = pj - pi;

        normal = [-v(2), v(1)];

        if norm(normal) == 0
            continue;
        end

        normal = normal / norm(normal);

        puntos_borde = [];

        for t = -L:paso:L

            q = m + t*normal;

            if q(1) < 0 || q(1) > 21 || ...
               q(2) < 0 || q(2) > 21
                continue;
            end

            if punto_en_obstaculo(q,ent)
                continue;
            end

            d = sqrt((P(:,1)-q(1)).^2 + ...
                     (P(:,2)-q(2)).^2);

            [~,idx] = sort(d);

            if (idx(1)==i && idx(2)==j) || ...
               (idx(1)==j && idx(2)==i)

                puntos_borde = [puntos_borde; q];
            end
        end

        if size(puntos_borde,1) > 1

            for k = 1:size(puntos_borde,1)-1

                p1 = puntos_borde(k,:);
                p2 = puntos_borde(k+1,:);

                if norm(p2-p1) < 2.5*paso

                    if ~segmento_corta_obstaculo(p1,p2,ent)

                        if mostrar_puntos
                            plot(p1(1),p1(2),'g.','MarkerSize',6);
                            plot(p2(1),p2(2),'g.','MarkerSize',6);
                        end

                        plot([p1(1) p2(1)], ...
                             [p1(2) p2(2)], ...
                             'g', ...
                             'LineWidth',1);

                        aristas = [aristas;
                                   p1 p2];
                    end
                end
            end
        end
    end
end

%% 6. 设置起点和终点

plot(inicio(1), ...
     inicio(2), ...
     'go', ...
     'MarkerFaceColor','g', ...
     'MarkerSize',8);

plot(objetivo(1), ...
     objetivo(2), ...
     'mo', ...
     'MarkerFaceColor','m', ...
     'MarkerSize',8);

%% 7. 从 Voronoi 边中提取 graph 节点

nodos = [];

for i = 1:size(aristas,1)

    p1 = aristas(i,1:2);
    p2 = aristas(i,3:4);

    nodos = agregar_nodo(nodos,p1,tol_nodo);
    nodos = agregar_nodo(nodos,p2,tol_nodo);
end

%% 8. 添加起点和终点

nodos = [nodos;
         inicio;
         objetivo];

id_inicio = size(nodos,1)-1;
id_objetivo = size(nodos,1);

%% 9. 构造 Dijkstra 代价矩阵
% 重点：
% 这里主要使用 aristas 中的 Voronoi 边建图，
% 不再用“大半径直接连接所有近邻点”，
% 所以路径会尽量沿绿色 Voronoi roadmap 行走。

M = size(nodos,1);
matriz_costes = Inf(M,M);

for i = 1:M
    matriz_costes(i,i) = 0;
end

for i = 1:size(aristas,1)

    p1 = aristas(i,1:2);
    p2 = aristas(i,3:4);

    id1 = buscar_nodo(nodos,p1,tol_nodo);
    id2 = buscar_nodo(nodos,p2,tol_nodo);

    if id1 > 0 && id2 > 0

        coste = norm(p1-p2);

        matriz_costes(id1,id2) = coste;
        matriz_costes(id2,id1) = coste;
    end
end

%% 10. 只连接起点和终点到最近的 Voronoi 节点

matriz_costes = conectar_punto_a_voronoi( ...
    matriz_costes, ...
    nodos, ...
    id_inicio, ...
    ent, ...
    K_conexion);

matriz_costes = conectar_punto_a_voronoi( ...
    matriz_costes, ...
    nodos, ...
    id_objetivo, ...
    ent, ...
    K_conexion);

%% 11. Dijkstra 搜索路径

[Camino, Coste] = Dijkstra( ...
    matriz_costes, ...
    id_inicio, ...
    id_objetivo);

%% 12. 绘制最终路径

if ~isinf(Coste)

    for i = 1:length(Camino)-1

        p1 = nodos(Camino(i),:);
        p2 = nodos(Camino(i+1),:);

        plot([p1(1) p2(1)], ...
             [p1(2) p2(2)], ...
             'r', ...
             'LineWidth',3);
    end

    disp('找到路径');
    disp(['路径代价 = ', num2str(Coste)]);

else

    disp('没有找到路径');
    disp('可以适当增大 K_conexion，例如 K_conexion = 8');

end

%% 13. 输出信息

disp(['Voronoi 边数量 = ', num2str(size(aristas,1))]);
disp(['Graph 节点数量 = ', num2str(size(nodos,1))]);

%% ============================================================
% 函数 1：判断点是否在障碍物内部
%% ============================================================

function dentro = punto_en_obstaculo(q,ent)

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
% 函数 2：判断线段是否与障碍物相交
%% ============================================================

function corta = segmento_corta_obstaculo(p1,p2,ent)

    corta = false;

    for i = 1:size(ent,1)

        if ent(i,8) == 0
            continue;
        end

        q1 = ent(i,1:2);
        q2 = ent(i,4:5);

        pc = inter_seg(p1,p2,q1,q2);

        if pc(3) == 1
            corta = true;
            return;
        end
    end
end

%% ============================================================
% 函数 3：添加 graph 节点，避免重复节点
%% ============================================================

function nodos = agregar_nodo(nodos,p,tol)

    if isempty(nodos)

        nodos = p;
        return;
    end

    d = sqrt((nodos(:,1)-p(1)).^2 + ...
             (nodos(:,2)-p(2)).^2);

    if min(d) > tol

        nodos = [nodos; p];
    end
end

%% ============================================================
% 函数 4：查找某个点对应的 graph 节点编号
%% ============================================================

function id = buscar_nodo(nodos,p,tol)

    id = 0;

    d = sqrt((nodos(:,1)-p(1)).^2 + ...
             (nodos(:,2)-p(2)).^2);

    [dmin,idx] = min(d);

    if dmin < tol
        id = idx;
    end
end

%% ============================================================
% 函数 5：连接起点/终点到最近的 Voronoi 节点
%% ============================================================

function matriz_costes = conectar_punto_a_voronoi( ...
    matriz_costes, ...
    nodos, ...
    id_punto, ...
    ent, ...
    K)

    p = nodos(id_punto,:);
    candidatos = [];

    for i = 1:size(nodos,1)

        if i == id_punto
            continue;
        end

        q = nodos(i,:);

        if ~segmento_corta_obstaculo(p,q,ent)

            d = norm(p-q);

            candidatos = [candidatos;
                          i d];
        end
    end

    if isempty(candidatos)
        return;
    end

    [~,orden] = sort(candidatos(:,2));
    candidatos = candidatos(orden,:);

    K = min(K,size(candidatos,1));

    for i = 1:K

        id_vecino = candidatos(i,1);
        coste = candidatos(i,2);

        matriz_costes(id_punto,id_vecino) = coste;
        matriz_costes(id_vecino,id_punto) = coste;
    end
end