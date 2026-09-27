function Trayecto = dibujar_camino(Camino,vertices,color)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
N=length(Camino);
for i=2:N
    Trayecto(i)=line([vertices(Camino(i-1),1),vertices(Camino(i),1)],[vertices(Camino(i-1),2),vertices(Camino(i),2)],'color', color,'LineWidth', 1.5);
end


end

