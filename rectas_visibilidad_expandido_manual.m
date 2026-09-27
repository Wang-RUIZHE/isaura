function [rectas, matriz_costes, vertices ]=rectas_visibilidad_expandido_manual(entorno,ini,fin)

[vertices,matriz_conexion]=extrae_vertices(entorno); %Se extraen los vertices
if(size(vertices,1) < size(matriz_conexion,1)) %Caso especial
    matriz_conexion(end,:)=[];
    matriz_conexion(:,end)=[];
end
ini=horzcat(ini,-1); %Se asigna como objeto ficticio los nuevos vertices
fin=horzcat(fin,-1);
vertices=[vertices;ini;fin]; %Se añaden los nuevos vertices a la lista de vertices
N=size(vertices,1);
M=size(entorno,1);
mAux = zeros(N-2,2); 
matriz_conexion=horzcat(matriz_conexion,mAux); %Se rellena la matriz de conexion
matriz_conexion=vertcat(matriz_conexion,zeros(2,N)); %Se rellena la matriz de conexion
matriz_costes=Inf*ones(N);  % Se inicililiza la matriz de costes a valores infinitos.
rectas=[];
for i=1:N % Para todos los vértices del entorno.
    for j=i+1:N % Para aquellos que no han sido verificados.
         recta=[vertices(i,:),vertices(j,:)]; % Recta formada por dos vértices.
        if  matriz_conexion(i,j)==1 %si  están ya unidos.
            rectas=[rectas;recta];  %debemos agregar que la línea esta dentro del objeto
            matriz_costes(i,j)=sqrt((recta(1)-recta(4))^2+(recta(2)-recta(5))^2);
            matriz_costes(j,i)= matriz_costes(i,j);
        else
            matriz_conexion(i,j)~=1; %si no están ya unidos, podrían ser "visibles".
           
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
                        %si el punto de intersección es uno de los vértices de la línea de visibilidad, no se puede tomar como como punto de corte
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
            if corta==0 & ((vertices(i,3)~=vertices(j,3)) |(vertices(i,3)==0 & vertices(j,3)==0))           %sólo comprobamos que los vértices no pertenecen al mismo objeto, sólo el espacio de trabajo puede enlazar estos vértices internamente
                rectas=[rectas;recta];                    %%%%%%%%%%%%%%%debemos agregar que la línea esta dentro del objeto
                matriz_costes(i,j)=sqrt((recta(1)-recta(4))^2+(recta(2)-recta(5))^2);
                 matriz_costes(j,i)= matriz_costes(i,j);
            end
        end
    end
end
