% tic
inicializar_RRT;
i=1;
distancia=Inf;
x0=goal.x;
y0=goal.y;
const=3;
long_rama=0.05
[vertices]=extrae_vertices(expandido);
rad=8;%radio para buscar optimizaciones        
%const*(log(length(vertices))/length(vertices))^(1/2);
tray=[goal.x goal.y];
tic
while i< max_iteraciones
    % Crear un nuevo nodo;
    nuevo_nodo= crear_nodo_RRT(lista_puntos,expandido,long_rama,0, 100, 0, 100, [goal.x,goal.y], 0.05,i);
    %Representar el nodo
    plot(nuevo_nodo.x,nuevo_nodo.y,'+','color','blue')
    j=1;
    near=[];
    %Obtener los vecinos
    while j<length(arbol);
        if calcDist([arbol(j).x,arbol(j).y],[nuevo_nodo.x,nuevo_nodo.y])<=rad;
            near=[near;arbol(j)];
        end
        j=j+1;
    end
    x=nuevo_nodo.x;
    y=nuevo_nodo.y;
    % Obtener el nodo predecesor del árbol:
    predecesor=arbol(nuevo_nodo.predecesor+1);
    %Actualizar el coste del nodo creado:
    nuevo_nodo.coste=predecesor.coste+nuevo_nodo.coste;
    %Obtener el predecesor con menor coste y actualizarlo
    for k=1:1:length(near)
        if arbol(near(k).numero+1).coste+calcDist([arbol(near(k).numero+1).x,arbol(near(k).numero+1).y],[nuevo_nodo.x,nuevo_nodo.y])<nuevo_nodo.coste && Verfificar_Cfree_segmento([x,y],[arbol(near(k).numero+1).x,arbol(near(k).numero+1).y], expandido)
            nuevo_nodo.predecesor=arbol(near(k).numero+1).numero;
            nuevo_nodo.coste=arbol(near(k).numero+1).coste+calcDist([arbol(near(k).numero+1).x,arbol(near(k).numero+1).y],[nuevo_nodo.x,nuevo_nodo.y]);
            predecesor=arbol(near(k).numero+1);
        end   
    end
    %Si el nuevo nodo y su predecesor no intersectan con un obstaculo se
    %añade al árbol y se unen
    if Verfificar_Cfree_segmento([x,y],[predecesor.x,predecesor.y], expandido)
        arbol=[arbol nuevo_nodo];
        lista_puntos=[lista_puntos;[x y]];
        rama=line([nuevo_nodo.x,predecesor.x],[nuevo_nodo.y,predecesor.y], 'color', 'blue');
    end
    %Ver si los vecinos tienen un coste menor con el nuevo nodo
    for k=1:1:length(near)
        if nuevo_nodo.coste+calcDist([arbol(near(k).numero+1).x,arbol(near(k).numero+1).y],[nuevo_nodo.x,nuevo_nodo.y])<arbol(near(k).numero+1).coste && Verfificar_Cfree_segmento([x,y],[arbol(near(k).numero+1).x,arbol(near(k).numero+1).y], expandido)
            arbol(near(k).numero+1).predecesor=nuevo_nodo.numero;
            arbol(near(k).numero+1).coste=nuevo_nodo.coste+calcDist([arbol(near(k).numero+1).x,arbol(near(k).numero+1).y],[nuevo_nodo.x,nuevo_nodo.y]);
            rama=line([nuevo_nodo.x,arbol(near(k).numero+1).x],[nuevo_nodo.y,arbol(near(k).numero+1).y], 'color', 'green');
        end
    end
        %pause
    i=i+1;
end
%Una vez lleagado al max de iteraciones ver nodos vecinos del
%goal
near=[];
j=1;
while j<length(arbol);
    if calcDist([arbol(j).x,arbol(j).y],[goal.x,goal.y])<=rad;
        near=[near;arbol(j)];
    end
    j=j+1;
end
%Coger el de menor coste de los vecinos del goal
for k=1:1:length(near)
    if arbol(near(k).numero+1).coste+calcDist([arbol(near(k).numero+1).x,arbol(near(k).numero+1).y],[goal.x,goal.y])<goal.coste && Verfificar_Cfree_segmento([goal.x,goal.y],[arbol(near(k).numero+1).x,arbol(near(k).numero+1).y], expandido)
        goal.predecesor=arbol(near(k).numero+1).numero;
        goal.coste=arbol(near(k).numero+1).coste+calcDist([arbol(near(k).numero+1).x,arbol(near(k).numero+1).y],[goal.x,goal.y]);
        predecesor=arbol(near(k).numero+1);
    end   
end
%Si se puede unir se une
if Verfificar_Cfree_segmento([goal.x,goal.y],[predecesor.x,predecesor.y], expandido)
    arbol=[arbol goal];
    lista_puntos=[lista_puntos;[goal.x goal.y]];
    rama=line([goal.x,predecesor.x],[goal.y,predecesor.y], 'color', 'green');
end
Coste=goal.coste
%% Dibujar trayecto
num=i;
while arbol(num+1).x~=start.x || arbol(num+1).y~=start.y
   tray=[tray;arbol(num+1).x arbol(num+1).y];
   num=arbol(num+1).predecesor;
end
tray=[tray;start.x start.y];
plot(tray(:,1),tray(:,2),'color','red','Linewidth',2)
toc
% legend([l1 l2])