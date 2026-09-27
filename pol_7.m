function [qref qdref qddref q3dref q4dref t]=pol_7(qi,qf,tf,paso,tex)

%Numero de muestras ó instantes a simular (sin contar los de tex)
N_instantes=round(tf/paso); 
%Numero de instantes extra a simular
N_extra=round(tex/paso);
%Numero total de isntantes
N_tot=N_instantes+N_extra+1;

%INICIALIZACIÓN DE q

%1- Calcular coeficientes:  a0, a1...a5
%a0, a1...a5 son vectores columna de (N_articulaciones)x1

    
factores=[1     0       0       0       0       0       0          0;
          1     tf      tf^2    tf^3    tf^4    tf^5    tf^6    tf^7;
          0     1       0       0       0       0       0          0;
          0     1       2*tf    3*tf^2  4*tf^3  5*tf^4  6*tf^5  7*tf^6;
          0     0       2       0       0       0        0         0;       
          0     0       2       6*tf    12*tf^2 20*tf^3 30*tf^4  42*tf^5;
          0     0       0       6       0       0        0         0;
          0     0       0       6       24*tf   60*tf^2 120*tf^3 210*tf^4];
equalto=[qi;qf;0;0;0;0;0;0];

solucion=factores^-1*equalto;

a0=solucion(1); 
a1=solucion(2); 
a2=solucion(3); 
a3=solucion(4); 
a4=solucion(5); 
a5=solucion(6); 
a6=solucion(7);
a7=solucion(8);

%2- Evaluar expresion de qref(t), vref(t), aref(t) para cada instante de
%tiempo
%Equivale a: construir matriz "q", de dimensiones N_instantes x ( N_articulaciones )    
% q_ant=zeros(1,N_articulaciones); %pos de instante anterior de tiempo para cada 
%articulación
for fila=1:N_tot %Recorre filas
    
tiempo=(fila-1)*paso; %Calculo del instante

    if tiempo > tf %Sí se ha llegado a la posición final        
    qref(fila)=qf;
    qdref(fila)=0;
    qddref(fila)=0;
    qdddref(fila)=0;
    q3dref(fila)=0;
    q4dref(fila)=0;
    else %No se ha llegado a la posición final
%pos        
qref(fila)=a7*tiempo^7+a6*tiempo^6+a5*tiempo^5+a4*tiempo^4+a3*tiempo^3+a2*tiempo^2+a1*tiempo+a0;
%vel
qdref(fila)=7*a7*tiempo^6+6*a6*tiempo^5+5*a5*tiempo^4+4*a4*tiempo^3+3*a3*tiempo^2+2*a2*tiempo+a1;
%acc
qddref(fila)=42*a7*tiempo^5+30*a6*tiempo^4+20*a5*tiempo^3+12*a4*tiempo^2+6*a3*tiempo+2*a2; 
%jerk
q3dref(fila)=210*a7*tiempo^4+120*a6*tiempo^3+60*a5*tiempo^2+24*a4*tiempo+6*a3;
%derivada del jerk
q4dref(fila)=840*a7*tiempo^3+360*a6*tiempo^2+120*a5*tiempo+24*a4;
    end
end
 

[qref]=[qref]';
[qdref]=[qdref]';
[qddref]=[qddref]';
[q3dref]=[q3dref]';
[q4dref]=[q4dref]';
t=[0:paso:tf+tex];

[t]=[t]';

