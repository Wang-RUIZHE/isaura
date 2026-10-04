function [punto_int] = interseccion_normal(punto,segmento)
% Devuelve el punto de intersección entre un segmento y la normal desde
% otro punto a este segmento.

angulo=segmento(7);
punto_aux=[punto(1)+cos(angulo),punto(2)+sin(angulo)];
punto_int=interseccion2d(punto,punto_aux,segmento(1:3),segmento(4:6));

end
