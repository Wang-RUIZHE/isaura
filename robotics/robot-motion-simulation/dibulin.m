%modifica una línea según la matriz de transformación dada.

function dibulin(lin,matriz)
	
	[P1 P2]=extrae(lin);
	P3=matriz*P1;
	P4=matriz*P2;
	modlin(lin,P3,P4);

