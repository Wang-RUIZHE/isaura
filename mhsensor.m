% Devuelve la matriz homogénea de un sensor US con respecto
% al sistema de coordenadas del AGV.

function matriz=MHsensor(matriz_sensores, sensor)

matriz=despl(matriz_sensores(sensor,1),matriz_sensores(sensor, 2),matriz_sensores(sensor, 3))*rotaz(matriz_sensores(sensor, 4));