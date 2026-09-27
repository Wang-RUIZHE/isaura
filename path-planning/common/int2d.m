									%int2d.m
% Deduce la intersección de la recta de dirección del sensor 
% a partir de la matriz de transformación homogénea con una pared.

function [d,punto]=int2d(pared,sens,agv)

sensor= agv*mhsensor(sens,1);

maxrango=sens(6);
ancho_haz=sens(5);
normal_pared=pared(7);
px=sensor(1,4); %Coordenada global x del sensor
py=sensor(2,4); %Coordenada global y del sensor
px1=pared(1); %Inicio de la pared coordenada X
px2=pared(4); %Final de la pared coordenada X
py1=pared(2); %Inicio de la pared coordenada Y
py2=pared(5); %Fina de la pared coordenada Y
%Proyección del vector x local del sensor en el X global
nx=sensor(1,1); %=cos (tetha)
%Proyección del vector y local del sensor en el Y global
ny=sensor(2,1); %=sen (tetha)
dx=px1-px2; %Longitud de la pared en X
dy=py1-py2; %Longitud de la pared en Y
angulo_sensor=atan2(ny,nx); %Devuelve el angulo del sensor en coord globales.
if angulo_sensor<0
angulo_sensor=2*pi+angulo_sensor;% Normaliza el angulo entre 0 y 2pi
end

%Transformo las coordenadas del vector normal de la pared
% a un vector en pi/2 que es restarle su mismo vector y 
% sumarle pi/2 y compruebo que el angulo transformado
% del sensor esta entre 0 y 2*pi.

%v_pared_transf=pared(7)-pared(7)+pi/2;
ang_sensor_transf=angulo_sensor-pared(7);
if ang_sensor_transf<=2*pi & ang_sensor_transf>=pi
  ang_sensor_transf=ang_sensor_transf-2*pi;%Normaliza el angulo entre -pi y pi
elseif ang_sensor_transf>2*pi
  ang_sensor_transf=ang_sensor_transf-2*pi;
end


%if (ang_sensor_transf>0)&(ang_sensor_transf<pi)
if (ang_sensor_transf<(-ancho_haz/2))|(ang_sensor_transf>(ancho_haz/2))
   d=maxrango;
   x=Inf;
   y=Inf;
   
   elseif dx==0    %pared vertical
   x=px1;
   if nx ~=0   %sensor no vertical  
      y=py+ny*(px1-px)/nx;
   else
      y=py;
   end
   
elseif dy == 0   %pared horizontal
   y=py1;
   if ny ~= 0   %sensor no horizontal 
      x=px+nx*(py1-py)/ny;
   else
      x=px;
   end
   
   
else
   %Aplico Cramer   
D0=det([1 0 -nx 0;0 1 -ny 0;1 0 0 -dx;0 1 0 -dy]);
D1=det([px 0 -nx 0;py 1 -ny 0;px1 0 0 -dx;py1 1 0 -dy]);
D2=det([1 px -nx 0;0 py -ny 0;1 px1 0 -dx;0 py1 0 -dy]);
x=D1/D0;
y=D2/D0;
end

d=sqrt((x-px)^2+(y-py)^2);  %Distancia del sensor al pto
if d > maxrango   %Comprueba si sobrepasa el max_rango
   d=maxrango;
end

punto=[x;y];


%Con lo siguiente evito que el sensor apunte a un pto q no esté
% en la pared física (no en la línea) o en su linea de acción
% (frente al sensor).
% xo=k*vx=xf   k=(xf-xo)/vx>0
k=(x-px)/nx;
if x>max(px1,px2) | x< min(px1,px2)|y>max(py1,py2) | y< min(py1,py2) | k<0
   d=maxrango;
   punto=[Inf;Inf];
end




