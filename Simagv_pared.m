						%Simagv_pared.m
% Simula un AGV.

function p=simagv_pared(figura, Xin, sensores, pared,T,d_ref,lado)
p=[];
Mold=xamh(Xin);
Mnew=xamh(Xin);
Xold=Xin;

k1=1/3; %Peso comportamiento seguir recto
k2=1/2; %Peso comportamiento orientación
k3=1/2; %Peso comportamiento distancia

kp=0.5; %Peso comportamiento seguir pasillo.
ko=0.5; %Peso comportamiento evitar obstáculos.

kr=15; %Cte de velocidad
kw=5; %Cte de rapidez de giro

% Nombramiento de sensores
if lado==0
   a=6;b=8;c=7; %Sensores de la derecha
else
   b=20;a=18;c=19; %Sensores de la izquierda
end


while Xold(1)>-10 & Xold(2)<30 & Xold(1)<5	
   dist=Simsensores(pared,sensores,Xold);
   %Creamos vector comportamiento seguir recto:
   v_seguir_recto=[1,0];
   %Creamos vector comportamiento orientación:
   v_orientacion=orientacion_pared(dist(a),dist(b));
   %Creamos vector comportamiento distancia:
   v_distancia=distancia(sensores(c,:),dist(c),d_ref,lado);
   
   v_pared=k1*v_seguir_recto+k2*v_orientacion+k3*v_distancia;
        
   v=kr*sqrt(v_pared(1)^2+v_pared(2)^2);
   ang=atan2(v_pared(2),v_pared(1));
   w=kw*ang;
      
   Xnew=Xold+[v*T*cos(Xold(3)+w*T) v*T*sin(Xold(3)+w*T) w*T]';
   dibuagv(figura,Xold, Xnew);
   pause(0.01)
   Mnew=xamh(Xnew);
   %a=line('xdata',[Xold(1);Xnew(1)],'ydata',[Xold(2);Xnew(2)],'color',[0 0 1]);
   Xold=Xnew;
   p=[p;Xold(1) Xold(2)];
end

   


