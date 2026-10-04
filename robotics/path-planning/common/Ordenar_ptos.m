function [puntos, distancias,num] = Ordenar_ptos(Punto,lista_puntos)
%Ordena los puntos de una lista según la proximidad  al "Punto".

N=size(lista_puntos,1);
% Obtener las distancias:
for i=1:N
d(i)=sqrt((Punto(1)-lista_puntos(i,1))^2+(Punto(2)-lista_puntos(i,2))^2);
end

[distancias,num]=sort(d);

for i=1:N
    puntos(i,:)=lista_puntos(num(i),:);
end
