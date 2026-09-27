% Devuelve el punto de intersección entre dos rectas dadas por un par de puntos cada una. 
% Si son paralelas devuelve Inf.

function punto=interseccion2d(p1,p2,q1,q2)

% Coordenadas de la primera recta:

x11=p1(1);
x21=p2(1);
y11=p1(2);
y21=p2(2);

% Coordenadas de la segunda recta:

x12=q1(1);
x22=q2(1);
y12=q1(2);
y22=q2(2);


% Si la primera es vertical:

if x11==x21
   % Si la segunda tambien es vertical:
   if x12==x22
      punto=[Inf,Inf];
   else
      punto=[x11,y12+(y22-y12)*(x11-x12)/(x22-x12)];
   end
   
% Si la primera es horizontal:

elseif y11==y21
   % Si la segunda tambien es horizontal:
   if y12==y22
      punto=[Inf,Inf];
   else
      punto=[x12+(x22-x12)*(y11-y12)/(y22-y12),y11];
   end

else
   % Si la primera es inclinada:
   
   % Si la segunda es vertical:
   
   if x12==x22
      punto=[x12,y11+(y21-y11)*(x12-x11)/(x21-x11)];
   % Si la segunda es horizontal:
   elseif y12==y22
		punto=[x11+(x21-x11)*(y22-y11)/(y21-y11),y22];
	% Si ambas son oblicuas:
	else
    % Coeficientes de la primera recta:
	D0=det([x11 1;x21 1]);
	D1=det([y11 1;y21 1]);
	D2=det([x11 y11;x21 y21]);
	a1=D1/D0;
   b1=D2/D0;
   
   % Coeficientes de la segunda recta:

	D0=det([x12 1;x22 1]);
	D1=det([y12 1;y22 1]);
	D2=det([x12 y12;x22 y22]);
	a2=D1/D0;
	b2=D2/D0;

	% Encontrar las coordenadas del punto de intersección:

		if a1==a2
   	% (Caso cuando son paralelas)
   		punto=[Inf Inf];
		else
			D0=det([1 -a1;1 -a2]);
			D1=det([b1 -a1;b2 -a2]);
			D2=det([1 b1;1 b2]);
			x=D2/D0;
			y=D1/D0;
   		punto=[x,y];
      end
   end
end