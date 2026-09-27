function [rectas, matriz_costes]=rectas_visibilidad(entorno)

[vertices,matriz_conexion]=extrae_vertices(entorno)

N=size(vertices,1);
M=size(entorno,1);
matriz_costes=Inf*ones(N);  % Se inicililiza la matriz de costes a valores infinitos.
rectas=[];
for i=1:N % Para todos los vértices del entorno.
    for j=i+1:N % Para aquellos que no han sido verificados.
         recta=[vertices(i,:),vertices(j,:)]; % Recta formada por dos vértices.
        if  matriz_conexion(i,j)==1 %si  están ya unidos.
            rectas=[rectas;recta];                    %%%%%%%%%%%%%%%il faut ajoute que la droite doit etre interieur a l'objet
            matriz_costes(i,j)=sqrt((recta(1)-recta(4))^2+(recta(2)-recta(5))^2);
            matriz_costes(j,i)= matriz_costes(i,j);
        else
            matriz_conexion(i,j)~=1 %si no están ya unidos, podrían ser "visibles".
           
            %if recta(1)==10&recta(2)==15
            %    esta=1;
            %end
            corta=0; % Inicialmente suponemos que no se cortan.
            for k=1:M % Recorremos todas las rectas del entorno para verificar si intersect alguna.
                punto=interseccion2d(vertices(i,1:2),vertices(j,1:2),entorno(k,1:2),entorno(k,4:5)); % Punto de intersección entre las rectas.
                % Si el punto pertenece al segmento de visilibidad no es
                % corte.
                minXvert=min(vertices(i,1),vertices(j,1));
                maxXvert=max(vertices(i,1),vertices(j,1));
                minYvert=min(vertices(i,2),vertices(j,2));
                maxYvert=max(vertices(i,2),vertices(j,2));
                test1vert=precision(punto(1)-minXvert);
                test2vert=precision(punto(1)-maxXvert);
                test3vert=precision(punto(2)-minYvert);
                test4vert=precision(punto(2)-maxYvert);
                if ((punto(1)>minXvert) | (test1vert==0)) & ((punto(1)<maxXvert) | (test2vert==0)) & ((punto(2)>minYvert) | (test3vert==0)) & ((punto(2)<maxYvert) | (test4vert==0))
                    %Si el punto pertenece al segmento de entorno tampoco
                    %es de corte.
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
                        p1=vertices(i,1:2);
                        p2=vertices(j,1:2);
                        a=single(punto(1))==single(p1(1))&single(punto(2))==single(p1(2));
                        b=single(punto(1))==single(p2(1))&single(punto(2))==single(p2(2));
                        c=a|b;       %El pto coincide o bien con el principio o con el final de la recta.
                        if ~c % Si no coincide
                            corta=1;
                        end
                    end
                end
            end
            if corta==0 & ((vertices(i,3)~=vertices(j,3)) |(vertices(i,3)==0 & vertices(j,3)==0))           %on verifie juste que les sommets n'appartienne pas au meme objet, seul l'espace de travail peux relier ces sommet interieurement
                rectas=[rectas;recta];                    %%%%%%%%%%%%%%%il faut ajoute que la droite doit etre interieur a l'objet
                matriz_costes(i,j)=sqrt((recta(1)-recta(4))^2+(recta(2)-recta(5))^2);
                 matriz_costes(j,i)= matriz_costes(i,j);
            end
        end
    end
end
