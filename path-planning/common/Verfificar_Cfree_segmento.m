function free = Verfificar_Cfree_segmento(P1,P2, entorno)
% Verifica si el segmentointersecta con algun obstaculos del entorno.
% Se asume que ambos puntos puntos del segmento están en Cfree.
M=size(entorno,1);
for k=1:M %Recorremos todas las rectas del entorno
                free=1; %Inicialmente suponemos que no se cortan.
                recta=[P1,P2];
                punto=interseccion2d(P1,P2,entorno(k,1:2),entorno(k,4:5)); % Intersección entre la recta y la linea k del entorno.
                
                % Verificar si el punto de intersección se encuentra en las
                % rectas de unión y del entorno 
                minX=min(entorno(k,1),entorno(k,4));
                maxX=max(entorno(k,1),entorno(k,4));
                minY=min(entorno(k,2),entorno(k,5));
                maxY=max(entorno(k,2),entorno(k,5));
                if punto(1)>=minX && punto(1)<=maxX && punto(2)>=minY && punto(2)<=maxY 
                   
                minX=min(recta(1),recta(3));
                maxX=max(recta(1),recta(3));
                minY=min(recta(2),recta(4));
                maxY=max(recta(2),recta(4));
                 if punto(1)>=minX && punto(1)<=maxX && punto(2)>=minY && punto(2)<=maxY 
                    free=0;
                    break
                 end
                end
                
            end
 end


