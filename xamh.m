% Crea la matriz homogénea a partir de la posición (estado) y orientación del robot.

function matriz=XaMH(X)

matriz= despl(X(1),X(2),0)*rotaz(X(3));

