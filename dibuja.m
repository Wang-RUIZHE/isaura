function dibuja(Simul,color,texto)
subplot(311)
plot(Simul.time,Simul.signals(1).values(:,1));
hold on
plot(Simul.time,Simul.signals(1).values(:,2),color);
grid minor
ylabel('r & y');
title(texto);
subplot(312)
stairs(Simul.time,Simul.signals(2).values(:,1),color);
hold on
grid minor
ylabel('u');
subplot(313)
stairs(Simul.time,Simul.signals(3).values(:,1),color);
hold on
grid minor
ylabel('Delta u');
xlabel('tiempo(seg)');
end