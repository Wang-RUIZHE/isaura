										%Vect_objetivo.m

%Comportamiento de atracción al objetivo.
%Función q devuelve el vector dirigido hacia el objetivo.

function [V_atraccion_objetivo,velocidad]=Vect_objetivo(X_obj,Mnew)

   Max_velocidad=2; %Conviene que sea baja
   V_final=[X_obj(1);X_obj(2);0;1];
   V_objetivo=((inv(Mnew)*V_final))';
   V_objetivo=V_objetivo(1,1:2);
   ro=atan2(V_objetivo(2),V_objetivo(1));
   velocidad=sqrt(V_objetivo(1)^2+V_objetivo(2)^2);
   
   if velocidad>Max_velocidad   
      V_atraccion_objetivo=[Max_velocidad*cos(ro) Max_velocidad*sin(ro)];
   else
      V_atraccion_objetivo=V_objetivo;
   end
   
   