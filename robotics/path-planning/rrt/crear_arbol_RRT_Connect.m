tic
inicializar_RRT_Bi;
i=1;
distancia=Inf;
x0=goal.x;
y0=goal.y;
final=0;
pred=[start.x start.y];
pred2=[goal.x goal.y];
num_nod=1;
num_nod2=1;
tray=[];
tray2=[];
Trayec=[];
while i< max_iteraciones && final==0;

    % Crear un nuevo nodo;
    nuevo_nodo= crear_nodo_RRT_Connect(lista_puntos,expandido,long_rama,0, 20, 0, 20, [goal.x,goal.y], 0.05,num_nod);
    % Extraer las Coodenadas;
    x=nuevo_nodo.x;
    y=nuevo_nodo.y;
    xV=nuevo_nodo.x;
    yV=nuevo_nodo.y;
    ind=num_nod;
    % Obtener el nodo predecesor del árbol:
    predecesor=arbol(nuevo_nodo.predecesor+1);
    vector=[x-predecesor.x,y-predecesor.y];
    vector_unitario=vector/calcDist([x,y],[predecesor.x,predecesor.y]);
    plot(nuevo_nodo.x,nuevo_nodo.y,'+','color',[0 0.5 0.5])
    rama=line([nuevo_nodo.x,predecesor.x],[nuevo_nodo.y,predecesor.y], 'color', [0 0.5 0.5]);
    if calcDist([x,y],[predecesor.x,predecesor.y])<=1; %Esto es para el caso de que el punto generado esté cerca de q_near
        % Poner al día la lista de puntos:
        lista_puntos=[lista_puntos;[x y]];
        pred=[pred;predecesor.x predecesor.y];
        % Representarlo en la gráfica
        plot(x,y,'+','color', [0 0.5 0.5])
        num_nod=num_nod+1;
        nuevo_nodo.coste=predecesor.coste+nuevo_nodo.coste;
        arbol=[arbol nuevo_nodo];
    end
    while calcDist([x,y],[predecesor.x,predecesor.y])>=1; % 1 es la distancia entre nodos
        % Verificar si  la linea entre el ptedecesor y el nodo intersecta algun obstáculo.
        nuevo_nodo.nombre=sprintf('nodo%04d',num_nod);
        nuevo_nodo.numero=num_nod;
        sprintf('nodo%04d',num_nod);
        nuevo_nodo.x=x;
        nuevo_nodo.y=y;
        % Actualizar el coste del nodo
        nuevo_nodo.coste=predecesor.coste+calcDist([x,y],[predecesor.x,predecesor.y]);
        % Añadirlo al árbol:
        arbol=[arbol nuevo_nodo];
        % Poner al día la lista de puntos:
        lista_puntos=[lista_puntos;[x y]];
        pred=[pred;predecesor.x predecesor.y];
        % Representarlo en la gráfica
        plot(x,y,'+','color', [0 0.5 0.5])
        %Actualizar las coordenadas del siguiente nodo
        x=x-vector_unitario(1);
        y=y-vector_unitario(2);
        num_nod=num_nod+1;
    end
%pause
    M=size(lista_puntos2);
    %Comprobar si el ultimo nodo del primer arbol puede unirse al segundo
    %arbol
    j=M(1);
    while j>=1 && final==0
        if Verfificar_Cfree_segmento([xV,yV],[arbol2(j).x,arbol2(j).y],expandido)
            rama=line([xV,arbol2(j).x],[yV,arbol2(j).y], 'color', [0.5 0.5 0]);
            final=1;
            aux=1;% Variable auxiliar para saber que arbol se une a cual
        end
        j=j-1;
    end
 %% --------------------------------------------------------------------------------
%arbol que parte del goal (hace lo mismo que el primero)
    % Crear un nuevo nodo;
    if final==0
        nuevo_nodo2= crear_nodo_RRT_Connect(lista_puntos2,expandido,1,0, 20, 0, 20, [start.x,start.y], 0.05,num_nod2);
        % Extraer las Coodenadas;
        x2=nuevo_nodo2.x;
        y2=nuevo_nodo2.y;
        xV2=nuevo_nodo2.x;
        yV2=nuevo_nodo2.y;
        ind2=num_nod2;
        % Obtener el nodo predecesor del árbol:
        predecesor2=arbol2(nuevo_nodo2.predecesor+1);
        vector2=[x2-predecesor2.x,y2-predecesor2.y];
        vector_unitario2=vector2/calcDist([x2,y2],[predecesor2.x,predecesor2.y]);
        plot(nuevo_nodo2.x,nuevo_nodo2.y,'+','color',[0.5 0 0.5])
        rama2=line([nuevo_nodo2.x,predecesor2.x],[nuevo_nodo2.y,predecesor2.y], 'color', [0.5 0 0.5]);
        if calcDist([x2,y2],[predecesor2.x,predecesor2.y])<=1;
            % Poner al día la lista de puntos:
            lista_puntos2=[lista_puntos2;[x2 y2]];
            pred2=[pred2;predecesor2.x predecesor2.y];
            % Representarlo en la gráfica
            plot(x2,y2,'+','color', [0.5 0 0.5])
            num_nod2=num_nod2+1;
            nuevo_nodo2.coste=predecesor2.coste+nuevo_nodo2.coste;
            % Añadirlo al árbol:
            arbol2=[arbol2 nuevo_nodo2];
        end
        while calcDist([x2,y2],[predecesor2.x,predecesor2.y])>=1
            % Verificar si  la linea entre el ptedecesor y el nodo intersecta algun obstáculo.
            nuevo_nodo2.nombre=sprintf('nodo%04d',num_nod2);
            nuevo_nodo2.numero=num_nod2;
            sprintf('nodo%04d',num_nod2);
            nuevo_nodo2.x=x2;
            nuevo_nodo2.y=y2;
            nuevo_nodo2.coste=predecesor2.coste+calcDist([x2,y2],[predecesor2.x,predecesor2.y]);
            % Añadirlo al árbol:
            arbol2=[arbol2 nuevo_nodo2];
            % Poner al día la lista de puntos:
            lista_puntos2=[lista_puntos2;[x2 y2]];
            pred2=[pred2;predecesor2.x predecesor2.y];
            % Representarlo en la gráfica
            plot(x2,y2,'+','color', [0.5 0 0.5])
            x2=x2-vector_unitario2(1);
            y2=y2-vector_unitario2(2);
            num_nod2=num_nod2+1;
        end
%pause
        % Verificar si el nodo nuevo está suficientemente cerca del nodo objetivo.
        M=size(lista_puntos);
        j=M(1);
        while j>=1 && final==0;
            if Verfificar_Cfree_segmento([xV2,yV2],[arbol(j).x,arbol(j).y],expandido);
                rama=line([xV2,arbol(j).x],[yV2,arbol(j).y], 'color', [0.5 0.5 0]);
                final=1;
                aux=2;
            end
            j=j-1;
        end
    i=i+1;
    end
end
%% Calcular la distancia del camino que une ambos arboles en funcion de cual se une a cual
if aux==1
    dist=calcDist([xV,yV],[arbol2(j+1).x,arbol2(j+1).y]);
    goal.coste=arbol(ind+1).coste+arbol2(j+1).coste+dist;
    %Para dibujar el camino
%     while arbol(ind+1).x~=start.x && arbol(ind+1).y~=start.y;
%     tray=[tray;arbol(ind+1).x arbol(ind+1).y];
%     ind=arbol(ind+1).predecesor;
%     end
%     while arbol2(j+1).x~=goal.x && arbol2(j+1).y~=goal.y;
%     tray2=[tray2;arbol2(j+1).x arbol2(j+1).y];
%     j=arbol2(j+1).predecesor;
%     end
else
    dist=calcDist([xV2,yV2],[arbol(j+1).x,arbol(j+1).y]);
    goal.coste=arbol2(ind2+1).coste+arbol(j+1).coste+dist;
%     %Para dibujar el camino
%     while arbol2(ind2+1).x~=goal.x && arbol2(ind2+1).y~=goal.y;
%     tray2=[tray2;arbol2(ind2+1).x arbol2(ind2+1).y];
%     ind2=arbol2(ind2+1).predecesor;
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