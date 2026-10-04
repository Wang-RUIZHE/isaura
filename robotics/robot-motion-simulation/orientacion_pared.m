									%Orientacion_pared.m

%Si lado=0 es para una pared por la derecha
%y si lado~=0 es para una pared por la izquierda

function vector=orientacion_pared(dista,distb)

dif_dist=dista-distb;
vector=[0,-dif_dist];

