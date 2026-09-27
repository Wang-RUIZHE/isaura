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

%% ===== 2. 减速比 =====

N = 80;             % Harmonic Drive 减速比

%% ===== 3. PD 控制器参数 =====

Kp = 80;
Kv = 160;

%% ===== 4. 轨迹参数 =====

q1 = 0;             % 初始位置
qf = 10*pi;         % 终点位置，注意不要再用 q2，避免和输出变量冲突

qprim = pi;         % 最大速度
qsec  = 3*pi;       % 最大加速度

jmax   = 10*pi;     % S曲线参数，当前不用
d_jmax = 50*pi;     % S曲线参数，当前不用

tm = 1e-5;          % 采样时间
textra = 10;        % 轨迹结束后的额外保持时间

%% ===== 5. 轨迹生成 =====

% 梯形轨迹
% [qref, vref, aref, t] = trapez(q1, qf, qprim, qsec, tm, textra);
% nombre_trayectoria = 'Trapezoidal';

% 如果要用七次多项式轨迹：
% 1) 注释上面两行 trapez
% 2) 打开下面两行 pol_7
[qref, vref, aref, jerkref, d_jerkref, t] = pol_7(q1, qf, 10, tm, textra);
nombre_trayectoria = 'Polinomial 7';

samplesimulink = length(qref);
tsamplesimulink = samplesimulink * tm;

%% ===== 6. 无重力弹性关节状态空间模型 =====

Ac = [ ...
    0              1                         0              0;
   -K/(N^2*Jm)    -(Belast/N^2 + bm)/Jm      K/(N*Jm)       Belast/(N*Jm);
    0              0                         0              1;
    K/(N*Je)       Belast/(N*Je)            -K/Je          -(Belast+bL)/Je ];

Bc = [0; Ka*Km/Jm; 0; 0];

Cc = [ ...
    eye(4);
   -K/N^2  -Belast/N^2   K/N   Belast/N ];

Dc = zeros(5,1);

%% ===== 7. 有重力模型参数，后面章节会用 =====

xc = 0.2;           % 质心距离 [m]
m  = 1;             % 质量 [kg]
g  = 9.81;          % 重力加速度 [m/s^2]

Bcg = [ ...
    0              0;
    Ka*Km/Jm       0;
    0              0;
    0              m*g*xc/Je ];

Dcg = zeros(5,2);

%% ===== 8. 奇异摄动控制参数，后面章节会用 =====

Kfp = 1.5;
Kfd = 0.05;

%% ===== 9. 运行 Simulink 模型 =====
% 当前章节：PD del lado del eslabon

 % modelName = 'SS_elasticoPD_q';
modelName = 'SS_elastico_SP19';
% modelName = 'SS_elastico_SP';
% modelName = 'PD_con_G';
 sim(modelName);

%% ===== 10. 读取 Simulink 输出 =====

% 读取连杆真实位置
qreal = q_out;

% 读取连杆真实速度
vreal = qprim_out;

% 如果是数组，取第一列
if isnumeric(qreal)
    qreal = qreal(:,1);
elseif isa(qreal,'timeseries')
    qreal = qreal.Data;
end

if isnumeric(vreal)
    vreal = vreal(:,1);
elseif isa(vreal,'timeseries')
    vreal = vreal.Data;
end

% 转成列向量
qreal = qreal(:);
vreal = vreal(:);

% 重新生成时间轴
t_use = linspace(0, t(end), length(qreal))';

% 去掉 t 中重复的采样点，避免 interp1 报错
[t_unique, ia] = unique(t(:), 'stable');

qref_unique = qref(:);
vref_unique = vref(:);

qref_unique = qref_unique(ia);
vref_unique = vref_unique(ia);

% 重新插值参考轨迹
qref_use = interp1(t_unique, qref_unique, t_use, 'linear', 'extrap');
vref_use = interp1(t_unique, vref_unique, t_use, 'linear', 'extrap');
%% ===== 11. 对齐数据长度 =====

min_len = min([length(qreal), length(vreal), length(qref_use), length(vref_use), length(t_use)]);

qreal = qreal(1:min_len);
vreal = vreal(1:min_len);
qref_use = qref_use(1:min_len);
vref_use = vref_use(1:min_len);
t_use = t_use(1:min_len);

%% ===== 12. 计算均方误差 MSE / ECM =====

MSE_pos = mean((qreal - qref_use).^2);
MSE_vel = mean((vreal - vref_use).^2);

disp(['MSE posicion = ', num2str(MSE_pos)])
disp(['MSE velocidad = ', num2str(MSE_vel)])

%% ===== 13. 画图：位置和速度跟踪 =====

figure

% ----- 位置 -----
subplot(1,2,1)
plot(t_use, qreal, 'b', 'LineWidth', 1.5)
hold on
plot(t_use, qref_use, 'r--', 'LineWidth', 1.5)
grid on
title(['Posicion | ', nombre_trayectoria, ' | MSE = ', num2str(MSE_pos,'%.4e')])
xlabel('Tiempo [s]')
ylabel('Posicion [rad]')
legend('Posicion real','Posicion de referencia','Location','best')

% ----- 速度 -----
subplot(1,2,2)
plot(t_use, vreal, 'b', 'LineWidth', 1.5)
hold on
plot(t_use, vref_use, 'r--', 'LineWidth', 1.5)
grid on
title(['Velocidad | ', nombre_trayectoria, ' | MSE = ', num2str(MSE_vel,'%.4e')])
xlabel('Tiempo [s]')
ylabel('Velocidad [rad/s]')
legend('Velocidad real','Velocidad de referencia','Location','best')

sgtitle(['SP + G + FF  | Kp = ', num2str(Kp), ...
         ', Kv = ', num2str(Kv), ', K = ', num2str(K)])
