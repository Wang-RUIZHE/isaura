% UPV - MUAII - PCAR (34398)
% Script de inicializacion y dibujo para Backstepping

clc
clear
close all

%% ===== 1. 物理参数 =====

Ka = 0.18;          % 放大器增益 [A/V]
Km = 0.11;          % 电机转矩常数 [Nm/A]

b  = 1e-2;          % 连杆侧粘性摩擦 [Nms/rad]
K  = 340;          % Harmonic Drive 刚度 [Nm/rad]
Belast = 5;         % Harmonic Drive 弹性阻尼 [Nms/rad]
be = 5e-5;          % 弹性摩擦参数 [Nms/rad]

Je = 0.24;          % 连杆侧惯量 [kg*m^2]
Jm = 0.025e-4;      % 电机侧惯量 [kg*m^2]

bm = 5e-5;          % 电机侧粘性摩擦 [Nms/rad]
bL = b;             % 连杆侧摩擦

xc = 0.2;           % 质心距离 [m]
m  = 1;             % 质量 [kg]
g  = 9.81;          % 重力加速度 [m/s^2]

%% ===== 2. Backstepping 参数 =====

N = 80;             % 减速比

Lambda1 = 35;
Lambda2 = 5000;
Lambda3 = 800;
Lambda4 = 10000;

Kp = 50;
Kv = 10;
Kf = 50;            % 弹性力矩导数反馈增益

%% ===== 3. 虚拟控制变量 =====

v1 = -K/Je;
v2 = m*g*xc/Je;
v3 = K/(N*Je);
v4 = K/(N*Jm);
v5 = 1/Jm;

%% ===== 4. 轨迹参数 =====

q1 = 0;
qf = 2*pi;          % 目标位置，避免和输出变量 q2 混淆

qprim = pi;
qsec  = pi;

jmax   = 10*pi;
d_jmax = 50*pi;

tm = 0.001;
textra = 5;

%% ===== 5. 轨迹生成 =====

% 梯形轨迹
[qref,vref,aref,t] = trapez(q1,qf,qprim,qsec,tm,textra);
nombre_trayectoria = 'Trapezoidal';

% 如果需要七次多项式轨迹，注释上面两行，打开下面两行
% [qref,vref,aref,jerkref,d_jerkref,t] = pol_7(q1,qf,10,tm,textra);
% nombre_trayectoria = 'Polinomial de septimo orden';

samplesimulink = length(qref);
tsamplesimulink = samplesimulink*tm;

%% ===== 6. 有重力状态空间模型 =====

Ac = [ ...
0,       1,                 0,              0;
-K/Je,  -(Belast+bL)/Je,    K/(N*Je),       Belast/(N*Je);
0,       0,                 0,              1;
K/(N*Jm), Belast/(N*Jm),   -K/(N^2*Jm),    -(Belast/N^2 + bm)/Jm ];

Bcg = [ ...
0,  0,              0,  Ka*Km/Jm;
0, -m*g*xc/Je,      0,  0 ]';

Cc = [ ...
eye(4);
[-K/N^2, -Belast/N^2, K/N, Belast/N] ];

Dcg = zeros(5,2);

%% ===== 7. 运行 Simulink 模型 =====

modelName = 'Backstepping';
sim(modelName);

%% ===== 8. 自动读取仿真结果 =====
% 优先使用你模型中改过的 To Workspace 名称：q_out, qprim_out

if exist('q_out','var')
    qreal = q_out;
elseif exist('q','var')
    qreal = q;
else
    error('没有找到位置输出变量。请把 Posicion robot 的 To Workspace 变量名改成 q_out。')
end

if exist('qprim_out','var')
    vreal = qprim_out;
elseif exist('q_prim','var')
    vreal = q_prim;
else
    error('没有找到速度输出变量。请把 Velocidad Robot 的 To Workspace 变量名改成 qprim_out。')
end

% 如果输出是 timeseries，则提取 Data
if isa(qreal,'timeseries')
    qreal = qreal.Data;
end

if isa(vreal,'timeseries')
    vreal = vreal.Data;
end

qreal = qreal(:);
vreal = vreal(:);
qref_use = qref(:);
vref_use = vref(:);
t_use = t(:);

%% ===== 9. 对齐数据长度 =====

min_len = min([length(qreal), length(vreal), length(qref_use), length(vref_use), length(t_use)]);

qreal = qreal(1:min_len);
vreal = vreal(1:min_len);
qref_use = qref_use(1:min_len);
vref_use = vref_use(1:min_len);
t_use = t_use(1:min_len);

%% ===== 10. 计算均方误差 MSE / ECM =====

MSE_pos = mean((qreal - qref_use).^2);
MSE_vel = mean((vreal - vref_use).^2);

disp(['MSE posicion = ', num2str(MSE_pos)])
disp(['MSE velocidad = ', num2str(MSE_vel)])

%% ===== 11. 画图 =====

figure

% ----- 位置 -----
subplot(1,2,1)
plot(t_use,qreal,'b','LineWidth',1.5)
hold on
plot(t_use,qref_use,'r--','LineWidth',1.5)
grid on
title(['Posicion | ', nombre_trayectoria, ' | MSE = ', num2str(MSE_pos,'%.4e')])
xlabel('Tiempo [s]')
ylabel('Posicion [rad]')
legend('Posicion real','Posicion de referencia','Location','best')

% ----- 速度 -----
subplot(1,2,2)
plot(t_use,vreal,'b','LineWidth',1.5)
hold on
plot(t_use,vref_use,'r--','LineWidth',1.5)
grid on
title(['Velocidad | ', nombre_trayectoria, ' | MSE = ', num2str(MSE_vel,'%.4e')])
xlabel('Tiempo [s]')
ylabel('Velocidad [rad/s]')
legend('Velocidad real','Velocidad de referencia','Location','best')

sgtitle(['Backstepping | K = ', num2str(K), ', N = ', num2str(N)])
