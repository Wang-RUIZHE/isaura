% Define la tabla de sensores US con respecto al
% origen del vehículo.

%Sensores en el lateral derecho

%		x 		y			z		alpha		ancho_haz	max_rango
sens=[
   	0.8  	0			0			0			pi/2			12;		%1
      0.8	-0.4 		0			0 			pi/2 			12;		%2
    	0.8  	-0.4		0		15*pi/8		pi/2			12;		%3
   	0.8  	-0.4		0		7*pi/4		pi/2			12;		%4
   	0.8  	-0.4		0		13*pi/8		pi/2			12;		%5
   	0.8  	-0.4		0		3*pi/2		pi/2			12;		%6
   	0.3  	-0.4		0		3*pi/2		pi/2			12;		%7
     -0.2  	-0.4		0		3*pi/2		pi/2			12;		%8
     -0.2  	-0.4		0		11*pi/8		pi/2			12;		%9
     -0.2  	-0.4		0		5*pi/4		pi/2			12;		%10
     -0.2  	-0.4		0		9*pi/8		pi/2			12;		%11
     -0.2  	-0.4		0		pi				pi/2			12;		%12
     -0.2  	0			0		pi				pi/2			12;		%13
     -0.2  	0.4		0		pi				pi/2			12;		%14
     -0.2  	0.4		0		7*pi/8		pi/2			12;		%15
     -0.2  	0.4		0		3*pi/4		pi/2			12;		%16
     -0.2  	0.4		0		5*pi/8		pi/2			12;		%17
     -0.2  	0.4		0		pi/2			pi/2			12;		%18
      0.3  	0.4		0		pi/2			pi/2			12;		%19
      0.8  	0.4		0		pi/2			pi/2			12;		%20
      0.8  	0.4		0		3*pi/8		pi/2			12;		%21
      0.8  	0.4		0		pi/4			pi/2			12;		%22
      0.8  	0.4		0		pi/8			pi/2			12;		%23
      0.8  	0.4		0		0				pi/2			12;		%24
];