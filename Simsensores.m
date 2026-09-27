										%Simsensores.m

% Devuelve los valores de los sensores y la coordeanadas de los ptos.

function [sens,ptos]=Simsensores( entorno, sensores, X)

Nsens=size(sensores,1);
Nent=size(entorno,1);
sens=sensores(:,6);
ptos=[];
MH=xamh(X);

for i=1:Nsens
   for j=1:Nent
      [d,pto]=int2d(entorno(j,:),sensores(i,:),MH);
      if d<=sens(i)
         sens(i)=d;
         p=pto';
      end
   end
   ptos=[ptos;p];
end
