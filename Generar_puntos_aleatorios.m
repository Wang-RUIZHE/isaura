% Devuelve N puntos aleatorios con coordenadas entre x_min y x_max,y_min,
% y_max.

function [Puntos] = Generar_puntos_aleatorios(N,x_min,x_max,y_min, y_max)

Puntos=[];

for i=1:N
    x=(x_max-x_min)*rand+x_min;
     y=(y_max-y_min)*rand+y_min;
     Puntos(i,:)=[x,y];     
end

end