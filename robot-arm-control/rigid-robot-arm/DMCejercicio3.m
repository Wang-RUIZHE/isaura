%% Definimos el proceso a controlar
clear all
close all
s=tf('s');
Tau=0.1;
% fdt y/u
gu=(100/(s+10)^2)*(1/(s+1)+0.5/(s+0.05));
% fdt y/dv (perturbaci�n medible) 
gdv=tf(1,[5 1]);
% fdt y/udv (perturbaci�n no medible) 
gudv=tf(1,[5 1]);

%% Se calcula la respuesta del proceso para el horizon de predicci�n definido
%Determina un valor adecuado para los parametros n y Ts
n=valor; % Instantes de predicci�n (orden del modelo)
Ts=valor;%Periodo de control (segundos)
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
%% Definimos los par�metros de simulatici�n
% Escalones en las perturbaciones y ruido en la entrada y salida
steptimeDV=80;valueDV=10; 
steptimeUDV=150;valueUDV=-10;
outputnoisegain=0;%el rudio est� entre +-outputnoisegain
inputnoisegain=0;%el rudio est� entre +-inputnoisegain
% Trayectoria de la referecia
r=[zeros(round(20/Ts),1); 15*ones(round(230/Ts),1)];  % reference trajectory
t=(0:Ts:Ts*size(r,1)-Ts)';%time for reference trajectory
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia qe fijemos
%% Tarea 3.11
figure
%Ajusta los parametros del DMC siguientes
c=valor; lambda=valor; alfa=valor; futref=0;
sim('dmccontrol')
dibuja(Simul,'k','')
Kc=0.2;
Ti=20;
Td=0;
Kpre=-0.0909;
sim('pidccontrol')
dibuja(Simul,'r','DMC(k) PID(k)')