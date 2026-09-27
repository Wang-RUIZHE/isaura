%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Calcul de la droite parallele         %
%              a un segment donné               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function v=paralela_segmento(segm,d)
x0=segm(1);
y0=segm(2);
x1=segm(4);
y1=segm(5);

v=segm;

%nous creons la normal exterieur au segment car nous les avons creer dans
%le sens anti horlogique
normal=[y1-y0,x0-x1];
angulo= segm(7)+pi;
normal=[cos(angulo),sin(angulo)];
%normalisons la normal (mesure de la  normal 1)
pnormal=normal/norm(normal);

%nous prenons la normal normalisée que nous multiplions par la distnce desirée
dnormal=d*pnormal; 

%nous placons la normal en p0 pour obtenir un point de la droite parallele située a la distance d desiréee
x2=x0+dnormal(1);
y2=y0+dnormal(2);

x3=x1+dnormal(1);
y3=y1+dnormal(2);
%line([x2;x3],[y2;y3],'color','green'); %Dibujamos normal

%retourne le segment parallele
v(1)=x2;
v(2)=y2;
v(4)=x3;
v(5)=y3;

%x2 e y2 son el punto de la recta paralela deseada
%devolveremos en v los datos necesario de la recta parametrica A B C

