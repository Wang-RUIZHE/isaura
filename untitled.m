% 假设你的地图矩阵叫 ent
ent = entorno_puerta_obstaculo();  % 或直接在这里复制粘贴你的矩阵

figure;
hold on; axis equal;
xlabel('X'); ylabel('Y');
title('🧱 我设计的机器人环境图');

for i = 1:size(ent,1)
    x1 = ent(i,1);
    y1 = ent(i,2);
    x2 = ent(i,4);
    y2 = ent(i,5);
    
    plot([x1 x2], [y1 y2], 'k-', 'LineWidth', 2);  % 黑色线段
end

grid on;
