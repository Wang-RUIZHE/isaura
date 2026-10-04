%% Definimos el proceso a controlar
clear all
close all
s=tf('s');
gu=1/((s+1)^4);% fdt y/u
gdv=tf(1,[1 1]);% fdt y/dv (perturbaci�n medible)
gudv=tf(1,[1 1]);% fdt y/udv (perturbaci�n no medible)

%% Se calcula la respuesta del proceso para el horizon de predicci�n definido
n=30;% Instantes de predicci�n (orden del modelo)
Ts=0.5;% Periodo de control (segundos)
Tstep=(n-1)*Ts;%Horizonte de predicci�n en segundos
[Su,T]=step(gu,(0:Ts:Tstep));%Su recoge la respuesta ante escal�n en u
figure
subplot(211)
plot(T,Su,'-o')
title('Respuesta ante escal�n en u')
xlabel('t(seg)')
ylabel('y')
[Sd,T]=step(gdv,(0:Ts:Tstep));%Sd recoge la respuesta ante escal�n en u
subplot(212)
plot(T,Sd,'-o')
xlabel('t(seg)')
ylabel('y')
title('Respuesta ante escal�n en dv')
%% Definimos los par�metros de simulaci�n
steptimeDV=35;valueDV=2; %Escal�n en la perturbaci�n medible
steptimeUDV=45;valueUDV=-2; %Escal�n en la perturbaci�n medible
outputnoisegain=0;%el ruido est� entre +-outputnoisegain
inputnoisegain=0;%el ruido est� entre +-inputnoisegain
r=[zeros(15/Ts,1); 12*ones(45/Ts,1)];  % Trayectoria de la referencia
t=(0:Ts:Ts*size(r,1)-Ts)';% Tiempo para la trayectoria de la referencia
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia que definamos
%% Simulaci�n y representaci�n de datos
figure
%Par�metros del controlador DMC
c=1; lambda=1; alfa=1; futref=0;
%Simulamos el bucle de control con el DMC
sim('dmccontrol')
%Representamos el resultado
dibuja(Simul,'r','')
lambda=50;
sim('dmccontrol')
dibuja(Simul,'k','')
lambda=100;
sim('dmccontrol')
dibuja(Simul,'m','c=1; lambda=1(r),50(k),100(m); alfa=1; futref=0')