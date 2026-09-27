function lineas=dib_rectas2(rectas,color)

N =size(rectas,1);

for i=1:N
lineas(i)=line('xdata',[rectas(i,1),rectas(i,3)],'ydata',[rectas(i,2),rectas(i,4)],'color',color);
end
