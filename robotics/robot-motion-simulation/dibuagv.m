% Traslada o gira un objeto según la matriz homogénea dada.

function dibuagv(agv,xold,xnew)

Mold=xamh(xold);
Mnew=xamh(xnew);
M=Mnew*inv(Mold);

dibuobj(agv,M);

