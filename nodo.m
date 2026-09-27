classdef nodo
    properties 
        numero;
        nombre;   % Tiene que ser un número
        numero_sucesores;
        predecesor;
        nodo_predecesor;
        sucesores;
        nodos_sucesores;
        coste;
        x;
        y;
    end
    
    methods
      function [a,b,c]=nuevo_sucesor(nodo,nuevo, nuevo_nodo)
         if nargin > 0             
             a=[nodo.numero_sucesores]+1;
            b=[[nodo.sucesores] nuevo];
            c=[[nodo.nodos_sucesores] nuevo_nodo];
         end
      end
    end
end
