% Extrae un obstáculo de un entorno.

function [obstaculo] = extrae_obstaculo(numero,entorno)
if numero> max(entorno(:,8))
    disp('El entormo no contiene tantos obstáculos')
    return
end

obstaculo=[];
N= size( entorno,1);  % Numero de filas.

for i=1:N
    if entorno(i,8)==numero
        obstaculo=[obstaculo;entorno(i,:)];
    end
end

