tic
inicializar_RRT_Bi;
i=1;
distancia=Inf;
x0=goal.x;
y0=goal.y;
final=0;
aux=0;
tray=[];
tray2=[];
Trayec=[];
%% Primer árbol
while i< max_iteraciones && final==0
    % Crear un nuevo nodo;
    nuevo_nodo= crear_nodo_RRT(lista_puntos,expandido,long_rama,0, 20, 0, 20, [goal.x,goal.y], 0.05,i);
    % Extraer las Coodenadas;
    x=nuevo_nodo.x;
    y=nuevo_nodo.y;
    % Obtener el nodo predecesor del árbol:
    predecesor=arbol(nuevo_nodo.predecesor+1);
    %Actualizar el coste del nodo creado:
    nuevo_nodo.coste=predecesor.coste+nuevo_nodo.coste;
    % Verificar si  la linea entre el ptedecesor y el nodo intersecta algun obstáculo.
    if Verfificar_Cfree_segmento([x,y],[predecesor.x,predecesor.y], ent);
        % Añadirlo al árbol:
        arbol=[arbol nuevo_nodo];
        % Poner al día la lista de puntos:
        lista_puntos=[lista_puntos;[x y]];
        % Representarlo en la gráfica
        plot(x,y,'+','color', [0 0.5 0.5])
        rama=line([nuevo_nodo.x,predecesor.x],[nuevo_nodo.y,predecesor.y], 'color', [0 0.5 0.5]);
        %pause
        %Comprovar si se pueden unir los arboles
        M=size(arbol2);
        j=M(2);
        while j >= 1 && final == 0 %Se verifica si alguna rama del árbol puede alcanzar el otro arbol
            if  calcDist([x,y],[arbol2(j).x,arbol2(j).y])<min_distancia
                if Verfificar_Cfree_segmento([x,y],[arbol2(j).x,arbol2(j).y], ent);  % Verificar que no hay obstáculos en medio
                    rama1=line([nuevo_nodo.x,arbol2(j).x],[nuevo_nodo.y,arbol2(j).y], 'color', [0.5 0.5 0]);
                    aux = 1;
                    final=1;
                 end
             end
             j=j-1;
        end
    end
    %---------------------------------------------------------------------------------
    %% Segundo arbol (igual que el primero)
    if ~final
        % Crear un nuevo nodo;
        nuevo_nodo2= crear_nodo_RRT(lista_puntos2,expandido,long_rama,0, 20, 0, 20, [goal.x,goal.y], 0.05,i);
        % Extraer las Coodenadas;
        x2=nuevo_nodo2.x;
        y2=nuevo_nodo2.y;
        % Obtener el nodo predecesor del árbol:
        predecesor2=arbol2(nuevo_nodo2.predecesor+1);
        %Actualizar el coste del nodo creado:
        nuevo_nodo2.coste=predecesor2.coste+nuevo_nodo2.coste;
        % Verificar si  la linea entre el ptedecesor y el nodo intersecta algun obstáculo.
        if Verfificar_Cfree_segmento([x2,y2],[predecesor2.x,predecesor2.y], ent);
            % Añadirlo al árbol:
            arbol2=[arbol2 nuevo_nodo2];
            % Poner al día la lista de puntos:
            lista_puntos2=[lista_puntos2;[x2 y2]];
            % Representarlo en la gráfica
            plot(x2,y2,'+','color', [0.5 0 0.5])
            rama2=line([nuevo_nodo2.x,predecesor2.x],[nuevo_nodo2.y,predecesor2.y], 'color', [0.5 0 0.5]);
            %pause
            %Comprobar si se pueden unir los arboles
            M=size(arbol);
            j=M(2);
            while j >= 1 && final == 0 %Se verifica si alguna rama del árbol puede alcanzar el otro arbol
                if  calcDist([x2,y2],[arbol(j).x,arbol(j).y])<min_distancia
                    if Verfificar_Cfree_segmento([x2,y2],[arbol(j).x,arbol(j).y], ent);  % Verificar que no hay obstáculos en medio
                        rama1=line([nuevo_nodo2.x,arbol(j).x],[nuevo_nodo2.y,arbol(j).y], 'color', [0.5 0.5 0]);
                        aux = 2;
                        final=1;
                     end
                 end
                 j=j-1;
            end
        end
    end    
    i=i+1;  
end
%% Calcular la distancia del camino que une ambos arboles en funcion de cual se une a cual
if aux==1
    goal.coste=arbol(i).coste+arbol2(j+1).coste+calcDist([arbol(i).x,arbol(i).y],[arbol2(j+1).x,arbol2(j+1).y]);
%Para dibujar el camino
%     while arbol(i).x~=start.x && arbol(i).y~=start.y;
%     tray=[tray;arbol(i).x arbol(i).y];
%     i=arbol(i).predecesor+1;
%     end
%     while arbol2(j+1).x~=goal.x && arbol2(j+1).y~=goal.y;
%     tray2=[tray2;arbol2(j+1).x arbol2(j+1).y];
%     j=arbol2(j+1).predecesor;
%     end
else
    goal.coste=arbol2(i).coste+arbol(j+1).coste+calcDist([arbol2(i).x,arbol2(i).y],[arbol(j+1).x,arbol(j+1).y]);
%Para dibujar el camino
%     while arbol2(i).x~=goal.x && arbol2(i).y~=goal.y;
%     tray2=[tray2;arbol2(i).x arbol2(i).y];
%     i=arbol2(i).predecesor+1;
%     end
%     while arbol(j+1).x~=start.x && arbol(j+1).y~=start.y;
%     tray=[tray;arbol(j+1).x arbol(j+1).y];
%     j=arbol(j+1).predecesor;
%     end
end
Coste=goal.coste
%% Dibujar el trayecto
% tray=[tray;start.x start.y];
% tray=flipud(tray);
% tray2=[tray2;goal.x goal.y];
% Trayec=[tray;tray2];
% plot(Trayec(:,1),Trayec(:,2),'color','red','Linewidth',2)
toc