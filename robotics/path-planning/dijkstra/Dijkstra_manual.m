function [Camino, Coste]=Dijkstra_manual(matriz_costes)

N=size(matriz_costes,1);
cerrados=  N-1;
abiertos=[];
costes=[];
caminos=[];

% Inicializar abiertos, caminos, coste:
j=1;
for i=1:N
      if i~=N-1
  		    abiertos=[abiertos;i];
    		  caminos=[caminos;N-1,i];
            costes=[costes;matriz_costes(N-1,i)];
            if i==N
               i_final=j;
            end
            j=j+1;
         else
            caminos=[caminos;N-1,-1];
            costes(i)=0;
         end
end
   
   %Bucle:
   
   indice=1;
   menor=N-1;
%    caminos
%    costes
%    pause
   
   while indice<=N & menor~=N
   
   % Obtener el nodo de menor coste de abiertos
   
   M=length(abiertos);
   coste_min=Inf;

   for i=1:M
      if costes(abiertos(i))<coste_min;
          menor=abiertos(i);
         coste_min=costes(abiertos(i));
      end
   end
%   menor
  % Extraer "Menor" de "Abiertos":
  
   temp_abiertos=[];
      for i=1:M
	         if abiertos(i)~=menor
               temp_abiertos=[temp_abiertos,abiertos(i)];
         end   
      end
      abiertos=temp_abiertos;
      cerrados=[cerrados;menor];
      
      
      % Comparar costes y poner al día
      
      caminos=[caminos -ones(N,1 )];
      
      for i=1:M-1
         n=abiertos(i);
         if costes(n)>coste_min+matriz_costes(menor,n)
            costes(n)=coste_min+matriz_costes(menor,n);
            k=1;
            aux=[];
            
            while caminos(menor,k)~=-1
               aux(k)=caminos(menor,k);
               k=k+1;
            end
            aux=[aux n];
            %a=length(aux);
            caminos(n,1:k)=aux;
            b=size(caminos,2);
            caminos(n,k+1:b)=-ones(1,size(k+1-b,2));
         end
      end
      indice=indice+1;
%       caminos
%       costes
%       pause
  end
   
  
   % Eliminar los -1's:
      
  Camino_aux=caminos( N,:);
  
  i=1;
  while Camino_aux(i)~=-1
      Camino(i)=Camino_aux(i);
      i=i+1;
  end
  
 Coste=costes(N);
   
