function res=anguloEntre2Rectas(pared1,pared2)

x0=pared1(1);
y0=pared1(2);
x1=pared1(4);
y1=pared1(5);

x0BIS=pared2(1);
y0BIS=pared2(2);
x1BIS=pared2(4);
y1BIS=pared2(5);

%nous creons la normal exterieur au segment car nous les avons creer dans
%le sens anti horlogique
normal1=[y1-y0,x0-x1];
normal2=[y1BIS-y0BIS,x0BIS-x1BIS];

%normalisons la normal (mesure de la  normal 1)
pnormal1=normal1/norm(normal1);
pnormal2=normal2/norm(normal2);

ang=acos(pnormal1*pnormal2');
res=(pi-ang);
%resendeg=rad2deg(res)