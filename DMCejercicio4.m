%% Definimos el proceso a controlar
clear all
close all
s=tf('s');
% fdt y/u
gu=(1-2*s)/(s+1)^3;
% fdt y/dv (perturbaci�n medible) 
gdv=tf(1,[0.5 1]);
% fdt y/udv (perturbaci�n no medible) 
gudv=tf(1,[0.5 1]);
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
%% Definimos los pa�metros de simulatici�n
% Escalones en las perturbaciones y ruido en la entrada y salida
steptimeDV=20;valueDV=0; 
steptimeUDV=30;valueUDV=0;
outputnoisegain=0;%el rudio est� entre +-outputnoisegain
inputnoisegain=0;%el rudio est� entre +-inputnoisegain
% Trayectoria de la referecia
r=[zeros(round(10/Ts),1); 1*ones(round(40/Ts),1)];  % reference trajectory
t=(0:Ts:Ts*size(r,1)-Ts)';%time for reference trajectory
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia qe fijemos
%% Tarea 3.12
figure
%Completa la tarea