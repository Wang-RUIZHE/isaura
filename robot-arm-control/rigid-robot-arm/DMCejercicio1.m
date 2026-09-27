%% Definimos el proceso a controlar
clear all
close all
s=tf('s');
gu=1/((s+1)^4);% fdt y/u
gdv=tf(1,[1 1]);% fdt y/dv (perturbaci�n medible)
gudv=tf(1,[1 1]);% fdt y/udv (perturbaci�n no medible)

%% Se calcula la respuesta del proceso para el horizon de predicci�n definido
n=30;% Horizonte de predicci�n 
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
% Definimos los par�metros de simulaci�n
steptimeDV=35;valueDV=2; %Escal�n en la perturbaci�n medible
steptimeUDV=45;valueUDV=-2; %Escal�n en la perturbaci�n medible
outputnoisegain=0;%el ruido est� entre +-outputnoisegain
inputnoisegain=0;%el ruido est� entre +-inputnoisegain
r=[zeros(15/Ts,1); 12*ones(45/Ts,1)];  % Trayectoria de la referencia
t=(0:Ts:Ts*size(r,1)-Ts)';% Tiempo para la trayectoria de la referencia
Tstop=t(end); %El tiempo de simulaci�n lo fija la referencia que definamos
%% Tarea 3.1
figure
lambda=1; alfa=100; c=1; futref=0;
sim('dmccontrol')
dibuja(Simul,'r','')
c=2;
sim('dmccontrol')
dibuja(Simul,'k','')
c=3;
sim('dmccontrol')
dibuja(Simul,'m','')
c=4;
sim('dmccontrol')
dibuja(Simul,'b','')
c=5;
sim('dmccontrol')
dibuja(Simul,'c','c=1(r),2(k),3(m),4(b),5(c); lambda=1; alfa=100; futref=0')

%% Tarea 3.2
figure
%Par�metros del controlador DMC
c=4; lambda=1; alfa=1; futref=0;

%Completa la tarea

%% Tarea 3.3
figure
%Completa la tarea
% %% Tarea 3.4
% %Ajusta los valores de las siguientes variables seg�n indica la tarea 3.4 de la memoria
% outputnoisegain=1;%el rudio est� entre +-outputnoisegain
% inputnoisegain=0;%el rudio est� entre +-inputnoisegain
% valueDV=0;valueUDV=0;
% c=4; lambda=1; alfa=100; futref=0;
% figure
% %Completa tarea
% figure
% lambda=1; alfa=100; c=4; futref=0;
% sim('dmccontrol')
% dibuja(Simul,'r','')
% lambda=10;
% sim('dmccontrol')
% dibuja(Simul,'k','')
% lambda=100;
% sim('dmccontrol')
% dibuja(Simul,'m','')
% dibuja(Simul,'lambda=1(r),2(k),3(m);alfa=100; futref=0')
%% Tarea 3.5
outputnoisegain=0;%el rudio est� entre +-outputnoisegain
inputnoisegain=0;%el rudio est� entre +-inputnoisegain
valueDV=0;valueUDV=0;
c=4; lambda=1; futref=1;
alfa=0.1
figure
sim('dmccontrol')
dibuja(Simul,'r','')
alfa=0.2;
sim('dmccontrol')
dibuja(Simul,'k','')
alfa=0.4;
sim('dmccontrol')
dibuja(Simul,'m','')
alfa=0.6;
sim('dmccontrol')
dibuja(Simul,'b','')
dibuja(Simul,'alfa=1(r),2(k),3(m),4(b); lambda= 1 ;futref=1')
%Completa tarea

