% function [nuevo_nodo] = crear_nodo_RRT(lista_puntos,entorno,longitud,objetivo, sesgo,numero)
function [nuevo_nodo] = crear_nodo_RRT_Connect(lista_puntos,entorno,longitud,x_min, x_max, y_min, y_max, objetivo, sesgo,numero)
% global x_min
% global x_max
% global y_min
% global y_max;
Condicion=1;  % Condicion de que este en cFree
Condicion2=1;  % Condicion de que se pueda unir con algunos vecino sin intersectar nigun obstáculo.
corta=1;
cond=1;
N=max(entorno(:,8));  % Numero de obstaculos en el entorno.
while Condicion2 ==1   % Hasta encontrar un punto que está en Cfree y se pueda conectar con algún vecino
 Condicion=1;  % Condicion de que este en cFree
% Buscar Punto que esté en Cfree:
    while Condicion
        Condicion=0;
        punto=crear_pto_aleatorio_RRT(x_min, x_max, y_min, y_max, objetivo, sesgo);
          for j=0:N
            [obstaculo] = extrae_obstaculo(j,entorno);
            if ~verificar_Cfree(punto, obstaculo)
            Condicion=1;
            end
        end   
    end
% % Se busca el vecino más próximo:
    x=punto(1);
    y=punto(2);
    % Ordenar los puntos según su distancia al nuevo nodo.
    [puntos, distancias,num] = Ordenar_ptos(punto,lista_puntos);
    % La distancia entre el nodo más próximo y q_near:
    M=size(puntos,1);
    i=1;
    while i<=M  && corta==1

        q_near=puntos(i,:);
        numero_predecesor=num(i);
        d=distancias(i);
        numero_predecesor=num(i)-1;

        Vector=[x-q_near(1),y-q_near(2)];
        Vector_unitario=Vector/d;
        q_new_candidato=[x y];
        while cond;
        %comprobar si se puede trazar el camino hasta el punto generado    
            if ~Verfificar_Cfree_segmento(q_new_candidato,q_near,entorno)
                %Si no se puede, acercar el punto a q_near hasta que se pueda
                 q_new_candidato=q_new_candidato-Vector_unitario*longitud; 
             else
                 cond=0;
            end
        end
        corta=0; %Inicialmente suponemos que no se cortan.
        if corta==0     
                        % % % Añadir el nuevo nodo:
            q_new=q_new_candidato;
            dist=calcDist(q_new,q_near);
            nuevo_nodo=nodo;
            nuevo_nodo.nombre=sprintf('nodo%04d',numero);
            nuevo_nodo.numero=numero;
            sprintf('nodo%04d',numero);
            nuevo_nodo.predecesor=numero_predecesor;
            nuevo_nodo.x=q_new(1);
            nuevo_nodo.y=q_new(2);
            nuevo_nodo.coste=dist;
            Condicion2=0; 
        end
        i=i+1;
    end   

end    