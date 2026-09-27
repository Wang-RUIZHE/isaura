function dibuent(entorno,color)

N=size(entorno,1);

for i=1:N
   
   line('xdata',[entorno(i,1);entorno(i,4)],'ydata',[entorno(i,2);entorno(i,5)],'color',color);
% linea=line('xdata',X,'ydata',Y,'zdata',Z,'color',color,'erasemode','xor');
  
  end