% demo_tarea1.m
clear; close all; clc;

% Cargar entorno y sensores
ent = entorno1();
Sensores;

dibuent(ent, [0 0 1]); 
hold on;

% Crear robot
Robot = creaAGV();

X = [2 2 pi/4]';     % 这里设置垂直向上
M0 = xamh(X);
dibuobj(Robot, M0);

Xold = X;

dibuagv(Robot, Xold, X);

T = 0.1;
d_ref = 2;
lado = 0;
kr = 1.3;
kw = 1.0;
fase = 1;

punto_meta = [19 19];   % centro aproximado de la puerta
v_up = [0 1];

for k = 1:500

    dist = Simsensores(ent, sens, X);

    % Comportamiento seguir pared
    v_seguir = [1 0];
    v_orient = orientacion_pared(dist(6), dist(8));
    v_dist = distancia(sens(7,:), dist(7), d_ref, lado);
    v_pared = (1/3)*v_seguir + (1/2)*v_orient + (1/2)*v_dist;

    % Comportamiento evitar obstaculos
    v_avoid = Evitar_obstaculos(sens, dist, X);

    % Atracción hacia la puerta
    v_meta = punto_meta - X(1:2)';
    v_meta = v_meta / (norm(v_meta) + 1e-6);

    % Corrección lateral hacia la zona de la puerta
    v_corr = [13 - X(1), 0];
    v_corr = v_corr / (norm(v_corr) + 1e-6);

  % Máquina de estados
if fase == 1
    % Fase 1: evitar obstáculo al principio
    v_result = 0.4*v_pared + 0.6*v_avoid;

    if X(2) > 8
        fase = 2;
        disp('Fase 2: seguir pared');
    end

elseif fase == 2
    % Fase 2: seguir pared
    v_result = 0.7*v_pared + 0.2*v_avoid + 0.1*v_up;

    if X(2) > 8 && X(1) > 7
        fase = 3;
        disp('Fase 3: atravesar puerta con detección reactiva');
    end

elseif fase == 3
    % Fase 3: atravesar puerta, pero seguir detectando pared y obstáculos

    % Si hay obstáculo cerca, domina evitar obstáculo
    if min(dist) < 1.2
        v_result = 0.7*v_avoid + 0.2*v_meta + 0.1*v_pared;
        disp('Fase 3: evitando obstáculo');

    % Si no hay obstáculo, avanzar hacia la puerta/meta
    else
        v_result = 0.65*v_meta + 0.20*v_pared + 0.15*v_avoid;
    end

    % Condición de parada cerca de la meta
    if norm(X(1:2)' - punto_meta) < 0.6
        disp('Tarea completada');
        break;
    end
end

    % Actualización cinemática
    vel = kr * norm(v_result);
    ang = atan2(v_result(2), v_result(1));
    w = kw * ang;

   Xnew = X + [
    vel*T*cos(X(3) + w*T);
    vel*T*sin(X(3) + w*T);
    w*T
];

% ===== 限制机器人不能跑出地图 =====
x_min = 0.3;
x_max = 20.7;

y_min = 0.3;
y_max = 20.7;

Xnew(1) = max(x_min, min(x_max, Xnew(1)));
Xnew(2) = max(y_min, min(y_max, Xnew(2)));

dibuagv(Robot, X, Xnew);
X = Xnew;
    X = Xnew;

    pause(0.05);
end

disp('Misión 1 completada');