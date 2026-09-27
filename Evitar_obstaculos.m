								%Evitar_obstaculos.m

%Comportamiento de evitar obstaculos.
%Función q devuelve el vector de repulsión de obstaculos.

function V_sens_def=Evitar_obstaculos(sensores,M,Xnew)

Mnew=xamh(Xnew);
N=length (M);
dist=inf*ones(N,1);

V_sens=zeros(N,2); 

n=4; %Exponente de las distancias
k1=3;%1.5;
k2=1.0;
k3=0.6;
k4=0.4;
k5=0.1;
%   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
K=[k1;k1;k2;k3;k4;k5;k5;k5;k4;k3;k2;k1;k1;k1;k2;k3;k4;k5;k5;k5;k4;k3;k2;k1];
   

for i=1:N
    if M(i)<12
         dist(i)=M(i);
         %Calculo el vector de atraccion hacia el obstaculo y le invierto el signo
         V_sens0(i,:)=([cos(sensores(i,4));sin(sensores(i,4));0;1])';
         V_sens(i,:)=-[V_sens0(i,1) V_sens0(i,2)];
         
    end
end

for i=1:N
   if dist(i)~=inf
      V_sens_def=[0 0];
      for i=1:N
	      V_sens_def=V_sens_def+(K(i)/dist(i)^n)*V_sens(i,:);
  		end
      break;
   else
   	V_sens_def=[0,0];
   end
end
