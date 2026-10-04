clear; clc; close all;

run('entorno1.m');

figure; hold on; axis equal; grid on;
xlim([0 21]);
ylim([0 21]);

title('Entorno unificado');
xlabel('X');
ylabel('Y');

for i = 1:size(ent,1)

    id = ent(i,8);

    if id == 0
        color = 'k';      % paredes exteriores
        grosor = 3;
    elseif id == 1
        color = 'b';      % pared interior con puerta
        grosor = 3;
    else
        color = 'r';      % obstaculos
        grosor = 2;
    end

    plot([ent(i,1), ent(i,4)], ...
         [ent(i,2), ent(i,5)], ...
         color, 'LineWidth', grosor);
end

% Marcar la puerta
plot([10 12], [10 10], 'g--', 'LineWidth', 4);
text(10.3, 10.5, 'Puerta');

% Robot inicial para primera parte
q_start = [3 7 pi/5];
dibujar_robot(q_start(1), q_start(2), q_start(3));
text(q_start(1)-0.5, q_start(2)-0.6, 'Robot inicial');

% Objetivo para segunda parte
q_goal = [18 18];
plot(q_goal(1), q_goal(2), 'go', ...
     'MarkerSize', 10, 'MarkerFaceColor', 'g');
text(q_goal(1)+0.3, q_goal(2), 'Objetivo');

function dibujar_robot(x,y,theta)
    r = 0.35;
    a = linspace(0,2*pi,50);

    plot(x+r*cos(a), y+r*sin(a), 'm', 'LineWidth', 2);

    quiver(x,y,cos(theta),sin(theta), ...
           0.8, 'm', 'LineWidth', 2, 'MaxHeadSize', 2);
end