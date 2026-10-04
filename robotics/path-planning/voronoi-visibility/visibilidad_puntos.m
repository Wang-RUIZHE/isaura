function [rectas,matriz_costes]=visibilidad_puntos(entorno,Puntos)

N=size(Puntos,1);
M=size(entorno,1);
rectas=[];
matriz_costes=Inf*ones(N);  % Se inicililiza la matriz de costes a valores infinitos.

for i=1:N-1 %Para todos los puntos
   for j=i+1:N
            corta=0; %Inicialmente suponemos que no se cortan.
            for k=1:M %Recorremos todas las rectas del entorno
                 recta=[Puntos(i,:),Puntos(j,:)]; % Rectas formadas por los dos vértices.
                punto=interseccion2d(Puntos(i,:),Puntos(j,:),entorno(k,1:2),entorno(k,4:5)); %nous trouvons l'intersection des 2 droites 
                %si le point appartient au segment de droite de visibilité, il se peut que la droite soit interieur a l'obstacle
                minXvert=min(Puntos(i,1),Puntos(j,1));
                maxXvert=max(Puntos(i,1),Puntos(j,1));
                minYvert=min(Puntos(i,2),Puntos(j,2));
                maxYvert=max(Puntos(i,2),Puntos(j,2));
                test1vert=precision(punto(1)-minXvert);
                test2vert=precision(punto(1)-maxXvert);
                test3vert=precision(punto(2)-minYvert);
                test4vert=precision(punto(2)-maxYvert);
                if (((punto(1)>minXvert) | (test1vert==0)) & ((punto(1)<maxXvert) | (test2vert==0)) & ((punto(2)>minYvert) | (test3vert==0)) & ((punto(2)<maxYvert) | (test4vert==0)))
                    %si le point appartient aussi au segment de droite de l'environnement alors c'est un point d'intersection 
                    minXent=min(entorno(k,1),entorno(k,4));
                    maxXent=max(entorno(k,1),entorno(k,4));
                    minYent=min(entorno(k,2),entorno(k,5));
                    maxYent=max(entorno(k,2),entorno(k,5));
                    test1ent=precision(punto(1)-minXent);
                    test2ent=precision(punto(1)-maxXent);
                    test3ent=precision(punto(2)-minYent);
                    test4ent=precision(punto(2)-maxYent);
                    if (((punto(1)>minXent) | (test1ent==0)) & ((punto(1)<maxXent) | (test2ent==0)) & ((punto(2)>minYent) | (test3ent==0)) & ((punto(2)<maxYent) | (test4ent==0)))
                        %au cas où le point d'intersection est un des sommets de
                        %la droite de visibilité,on ne peut pas le prendre
                        %comme point de 'corte'
%                         p1=Puntos(i);
%                         p2=Puntos(j);
                        p1=Puntos(i,:);
                        p2=Puntos(j,:);
                        a=single(punto(1))==single(p1(1))&single(punto(2))==single(p1(2));
                        b=single(punto(1))==single(p2(1))&single(punto(2))==single(p2(2));
                        c=a|b;       %L'un ou l'autre point apartient au debut ou a la fin de la droite
                        if ~c %Puntos(i,1:2) & punto~=Puntos(j,1:2)
                            corta=1;
                        end
                    end
                end
            end
            if corta==0          
                rectas=[rectas;recta]; 
                  matriz_costes(i,j)=sqrt((recta(1)-recta(3))^2+(recta(2)-recta(4))^2);
                 matriz_costes(j,i)= matriz_costes(i,j);
            end
        end
    end
end
