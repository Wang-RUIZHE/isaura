%function [punto] = crear_pto_aleatorio_RRT(objetivo, sesgo)
function [punto] = crear_pto_aleatorio_RRT(x_min, x_max, y_min, y_max, objetivo, sesgo)
% Crea un punto aleatorio en los límites dados y con el sesgo dado hacía el
% objetivo.
% global x_min
% global x_max
% global y_min
% global y_max;

x=(x_max-x_min)*rand+x_min+sesgo*objetivo(1);

y=(y_max-y_min)*rand+y_min+sesgo*objetivo(2);

punto=[x,y];

