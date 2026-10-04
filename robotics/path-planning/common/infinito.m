function vector=infinito(sensores,dist)

N=length (dist);
V_inf=zeros(N,2); 

n=4; %Exponente de las distancias
k1=3;
k2=1;
k3=0.8;
k4=0;
k5=0;

%   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
K=[k1;k1;k2;k3;k4;k5;k5;k5;k5;k5;k5;k5;k5;k5;k5;k5;k5;k5;k5;k5;k4;k3;k2;k1];
   
for i=1:4
   %Calculo el vector de atraccion hacia el infinito
   V_inf(i,:)=[cos(sensores(i,4)) sin(sensores(i,4))];
end
for i=22:24
   %Calculo el vector de atraccion hacia el infinito
   V_inf(i,:)=[cos(sensores(i,4)) sin(sensores(i,4))];
end

vector=[0 0];
for i=1:4
	vector=vector+(K(i)*dist(i)^n)*V_inf(i,:);
end
for i=22:24
	vector=vector+(K(i)*dist(i)^n)*V_inf(i,:);
end

%Normalizamos el vector
modulo=sqrt(vector(1)^2+vector(2)^2);
vector=vector./modulo;

