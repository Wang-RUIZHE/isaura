% Devuelve la lista de los vertices(NX3) y la matriz de conexiones (NXN) a partir de la matriz
% del entorno. En la lista de vertices está incluido el obstáculo al que pertenecen (0 si es el marco
% del entorno).

function [vertices,matriz_conexion]=extrae_vertices(entorno)

N=size(entorno,1);          %le nombre de ligne de la matrice
vertices=[entorno(1,1:2) entorno(1,8);entorno(1,4:5) entorno(1,8)];     %on met dans 'vertices' et le numero de l'objet auqel ils appartiennent
matriz_conexion=zeros(N,N);
matriz_conexion(1,2)=1;
matriz_conexion(2,1)=1;

for i=2:N
   fila=entorno(i,:);       %on prend la ligne i de l'environnement
   vert1=[fila(1:2) fila(8)];   %on en extrait les sommets presents ainsi que le numero de l'objet auqel appartiennent les sommets
   vert2=[fila(4:5) fila(8)];
   aux1=0;          %on initialise des variable temporaire qui permettront de voir si l'un des deux sommet courrants appartient deja ou non a la matrice 'Vertices' 
   aux2=0;          %et donnera la numero du sommet auquel il est reliés dans le cas positif
   M=size(vertices,1);
   for j=1:M
      candidato=vertices(j,:);          %on prend l'element candidat de la matrice des sommets
      if vert1==candidato & aux1==0     %on regarde si le candidat est l'un des nouveau sommet
         aux1=j;                        %si oui on donne le numero de ligne qui  correspond au numero du sommet pour lequel on l'a trouve
      elseif vert2==candidato & aux2==0
         aux2=j;
      end
      
      if aux1~=0 & aux2~=0              % si les deux 'aux' sont non nuls a la fois, c'est que les sommets vert1 et vert2 appartiennent deja a la matrice 'vertices'
         break;
      end
   end
   
   if aux1==0 & aux2==0         %si les aux sont toujours nuls c'est que les vert1 et vert2 appartiennent a un nouvel objet
       if vert1==vert2          % il s'agit d'un point seul comme le point start ou goal
           vertices=[vertices;vert1];
           %matriz_conexion(M+1,M+1)=1;
       else                     %sinon il s'agit d'un cote d'un nouvel objet
           vertices=[vertices;vert1;vert2];
		   matriz_conexion(M+1,M+2)=1;
   	       matriz_conexion(M+2,M+1)=1;
        end
   elseif aux1~=0 & aux2==0
      vertices=[vertices;vert2];
      matriz_conexion(M+1,aux1)=1;
      matriz_conexion(aux1,M+1)=1;
   elseif aux2~=0 & aux1==0
      vertices=[vertices;vert1];
      matriz_conexion(M+1,aux2)=1;
      matriz_conexion(aux2,M+1)=1;
   else
      matriz_conexion(aux1,aux2)=1; %si les deux sommets appartiennent deja a matrice des sommets on rajoute juste un liens entre ceux ci dans la matrice de conexion
      matriz_conexion(aux2,aux1)=1;  
   end
end
