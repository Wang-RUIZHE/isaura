function Robot = creaAGV()
% Crea el AGV en las coordeanadas (0,0,0).

color=[0 0.3 1];

lin1=line('xdata',[-0.2;0.8]','ydata',[0.4;0.4]','zdata',[0;0]','color',color,'erasemode','xor');
lin2=line('xdata',[0.8;0.8]','ydata',[0.4;-0.4]','zdata',[0;0]','color','red','erasemode','xor');
lin3=line('xdata',[-0.2;0.8]','ydata',[-0.4;-0.4]','zdata',[0;0]','color',color,'erasemode','xor');
lin4=line('xdata',[-0.2;-0.2]','ydata',[-0.4;0.4]','zdata',[0;0]','color',color,'erasemode','xor');

Robot=[lin1;lin2;lin3;lin4];
end
