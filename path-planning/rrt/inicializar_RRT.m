clear all
close all
% Declaración y representación del entorno:
entorno_practica;     % Declarar la matriz del entorno. 
figure
dibuent(ent,[0,1,0]) % Representar el entorno
axis([-1 22 -1 22])  % Definir los limites.
hold on
grid
expandido=expandir_entorno(ent,1);    % Generación del entorno expandido de un metro.
dibuent(expandido,[0 0 0]);
global arbol
global x_min
global x_max
global y_min
global y_max
% Crear el nodo de inicio:
start=nodo;
start.nombre='inicio';
start.numero=0;
start.x=2;
start.y=2;
start.coste=0;
plot(start.x,start.y,'*')
% Crear el nodo objetivo:
goal=nodo;
goal.nombre='objetivo';
goal.x=16;
goal.y=10;
goal.coste=Inf;
plot(goal.x,goal.y,'o')
lista_puntos=[start.x, start.y];  % Inicializar la lista de nodos del árbol.
nodo0000=start;
max_iteraciones=100;  % Número máximo de iteraciones despues del cual se para la búsqueda:
min_distancia=1;      % Distacia del objetivo a partir de la cual para la busqueda;
long_rama=1;          % Longitud de las ramas
arbol=nodo;
arbol=start;