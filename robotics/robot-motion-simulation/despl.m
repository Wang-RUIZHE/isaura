% Devuelve la matriz de desplazamiento del vector[x,y,z].

function A = despl(x,y,z)
	
	

	A =    [1	0	0	x
		0	1	0	y
		0	0	1	z
		0	0	0	1];
