function Trayecto = dibujar_camino(Camino,vertices,color)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
J=length(vertices);
N=length(Camino);
plot(vertices(J-1,1),vertices(J-1,2),'b--*','LineWidth',1.5,'MarkerSize',5);
plot(vertices(J,1),vertices(J,2),'b--o','LineWidth',1.5,'MarkerSize',5);
for i=2:N
    Trayecto(i)=line([vertices(Camino(i-1),1),vertices(Camino(i),1)],[vertices(Camino(i-1),2),vertices(Camino(i),2)],'color', color,'LineWidth', 1);
end


end

