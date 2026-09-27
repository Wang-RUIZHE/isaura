%% Definimos el proceso a controlar
clear all
close all
s=tf('s');
Tau=0.1;
% fdt y/u
gu=1/((Tau*s+1));
gu.OutputDelay=1;
% fdt y/dv (sin perturbaci�n medible) 
gdv=tf(0,1);
% fdt y/udv (sin perturbaci�n no medible) 
gudv=tf(0,1);
%% Se calcula la respuesta del proceso para el horizon de predicci�n definido
%Determina un valor adecuado para los parametros n y Ts
n=30; % Instantes de predicci�n (orden del modelo)
Ts=0.1;%Periodo de control (segundos)
Tstep=(n-1)*Ts;%Prediction horizon in seconds
[Su,T]=step(gu,(0:Ts:Tstep));
figure
subplot(211)
plot(T,Su,'-o')
title('Escal�n en u')
xlabel('t(seg)')
ylabel('y')
[Sd,T]=step(gdv,(0:Ts:Tstep));
subplot(212)
plot(T,Sd,'-o')
xlabel('t(seg)')
ylabel('y')
title('Escal�n en dv')
%% Definimos los par�metros de simulaci�n
% Escalones en las perturbaciones y ruido en la entrada y salida
steptimeDV=10;valueDV=0; 
steptimeUDV=15;valueUDV=0;
outputnoisegain=0;%el rudio est� entre +-outputnoisegain
inputnoisegain=0;%el rudio est� entre +-inputnoisegain
% Trayectoria de la referecia
r=[zeros(round(2/Ts),1); 12*ones(round(8/Ts),1)];  % reference trajectory
t=(0:Ts:Ts*size(r,1)-Ts)';%time for reference trajectory
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia qe fijemos
%% Tarea 3.6
%Ajusta los siguentes paramtros segun indica la tarea 3.6 de la memoria
c=4; lambda=1; alfa=1;
figure
futref=1;
sim('dmccontrol')
dibuja(Simul,'k','')
futref=0;
sim('dmccontrol')
dibuja(Simul,'m','')
subplot(3,1,1)
title('Respuesta del Sistema (y) vs Referencia (r)')
legend('Ref', 'futref=1', 'futref=0')
grid on
subplot(3,1,2)
title('Acción de Control (u)')
ylabel('u')
grid on
subplot(3,1,3)
title('Incremento de Control (\Delta u)')
ylabel('\Delta u')
xlabel('Tiempo (seg)')
grid on
% Título general para la ventana
sgtitle('Comparativa DMC: c=4, \lambda=1, \alpha=1');
%Completa la tarea
%% Tarea 3.7
r=[zeros(round(2/Ts),1); 3.75*(0:Ts:4)'; 15*ones(round(8/Ts),1)];  % reference trajectory
t=(0:Ts:Ts*size(r,1)-Ts)';%time for reference trajectory
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia qe fijemos
c=4; lambda=1; alfa=1;
figure
futref=1;
sim('dmccontrol')
dibuja(Simul,'k','')
futref=0;
sim('dmccontrol')
dibuja(Simul,'m','')
subplot(3,1,1)
title('Respuesta del Sistema (y) vs Referencia (r)')
legend('Ref', 'futref=1', 'futref=0')
grid on
subplot(3,1,2)
title('Acción de Control (u)')
ylabel('u')
grid on
subplot(3,1,3)
title('Incremento de Control (\Delta u)')
ylabel('\Delta u')
xlabel('Tiempo (seg)')
grid on
% Título general para la ventana
sgtitle('Comparativa DMC: c=4, \lambda=1, \alpha=1');
%Completa la tarea

%% Tarea 3.8
%Completa la tarea
%% Tarea 3.8
r=[zeros(round(2/Ts),1); 12*ones(round(8/Ts),1)];  % reference trajectory
t=(0:Ts:Ts*size(r,1)-Ts)';%time for reference trajectory
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia qe fijemos
c=4; lambda=1; alfa=1;futref=0;
figure
gu.OutputDelay = 1;
sim('dmccontrol')
dibuja(Simul,'k','')
gu.OutputDelay = 1.1;
sim('dmccontrol')
dibuja(Simul,'r','')
gu.OutputDelay = 1.2;
sim('dmccontrol')
dibuja(Simul,'m','')
sim('dmccontrol')
dibuja(Simul,'m','c=4; alfa=1 ,lamba=1,theta=1(k), thetha=1.1(r),thetha=1.2(m) ')

%% Tarea 3.9
r=[zeros(round(2/Ts),1); 12*ones(round(8/Ts),1)];  % reference trajectory
t=(0:Ts:Ts*size(r,1)-Ts)';%time for reference trajectory
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia qe fijemos
figure
c=4; lambda=10; alfa=1;futref=0;
figure
gu.OutputDelay = 1;
sim('dmccontrol')
dibuja(Simul,'k','')
gu.OutputDelay = 1.1;
sim('dmccontrol')
dibuja(Simul,'r','')
gu.OutputDelay = 1.2;
sim('dmccontrol')
dibuja(Simul,'m','')
sim('dmccontrol')
dibuja(Simul,'m','c=4; alfa=1 ,lamba=10,theta=1(k), thetha=1.1(r),thetha=1.2(m) ')

%Completa la tarea
%El parametros que hay que ir modificando es gu.OutputDelay pero ahora
%lambda=10

%% Tarea 3.10
gu.OutputDelay=1;%dejamos el retardo a 1
figure
%Ajusta los parametros del DMC siguientes
c=4; lambda=1; alfa=1
futuref=0;
sim('dmccontrol')
dibuja(Simul,'r','')

Kc=0.05;

Ti=0.1;
Td=0.0;
Kpre=0;
sim('pidccontrol')
dibuja(Simul,'K','Kc=0.5,Ti=0.1,Td=0.0, Kpre=0')