function visi=dib_rectas(rectas,color)

N =size(rectas,1);

for i=1:N
visi(i)=line('xdata',[rectas(i,1),rectas(i,4)],'ydata',[rectas(i,2),rectas(i,5)],'color',color);
end
