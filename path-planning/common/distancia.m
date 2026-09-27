%Esta funcion no funciona aqui, aunque en obstaculos si.
%Si lado=0 es para una pared por la derecha
%y si lado~=0 es para una pared por la izquierda

function vector=distancia(sensorc,distc,d_ref,lado)

if distc==sensorc(6)
   %Si el sensor no detecta nada que siga recto
   vector=[0,0];
else   
   vector=[0,(d_ref-distc)/distc];
end

if lado==1
   vector=-vector;
end
