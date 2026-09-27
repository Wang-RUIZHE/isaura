% --- SCRIPT PRINCIPAL ---
% Llama a la función para obtener la matriz de datos
ent = entorno1(); 

figure;
dibuent(ent, [0, 1, 0]); % Representar original (verde)
axis([-1 22 -1 22]);
hold on;
grid on;

% Usa la matriz 'ent' que acabamos de obtener
expandido = expandir_entorno(ent, 0.5); 
dibuent(expandido, [0 0 0]); % Representar expandido (negro)
%Planificacion
[rectas, matriz]=rectas_visibilidad_expandido(expandido) 
lineas=dib_rectas(rectas,[1 0 0]) 
[Camino, Coste]=Dijkstra(matriz,1,8) 
[vertices]=extrae_vertices(expandido) 
Trayecto = dibujar_camino(Camino,vertices,[0 0 1]) 
