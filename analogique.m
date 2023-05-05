% 参数和物理量
M_MPM = 0.38e-3; % kg
P_MPM = M_MPM * 9.81; % N
course = 0.1e-3; % m
mu_f = 0.4; % 无单位

% 时间向量
t = linspace(0, 0.01, 1000); % s

% 位置x向量（这里只是一个示例，你需要根据实际问题确定位置x的变化）
pos_x = linspace(0, 0.1e-3, 1000); % m

% 计算Fx_M、Fx_EM和Fz_EM
ix = 1; % 假设电流为1A
Fx_EM = ix * (2.1252E+18 * pos_x.^6 - 9.7281E+07 * pos_x.^5 - 5.0226E+10 * pos_x.^4 + 1.3028E+00 * pos_x.^3 + 4.9317E+02 * pos_x.^2 - 1.0385E-07 * pos_x + 1.3115E-03);
Fz_EM = ix * (-1.4456E+07 * pos_x.^3 + 1.2642E-05 * pos_x.^2 - 2.9536E-01 * pos_x + 9.3282E-14);

% 计算Ftotal_x（合力在x轴上的分量）
Ftotal_x = Fx_EM;

% 计算Ftotal_z（合力在z轴上的分量）
Ftotal_z = P_MPM + Fz_EM;

% 计算净重
Wnet = M_MPM * 9.81 - Ftotal_z;

% 计算库仑摩擦力
Ff = Wnet * mu_f;

% 计算加速度
a = (Ftotal_x - Ff) / M_MPM;

% 使用积分函数计算速度
v = cumtrapz(t, a);

% 使用积分函数计算位移
x = cumtrapz(t, v);
index = find(x>course);
x(index(1):end)=course;
v(index(1):end)=0;
a(index(1):end)=0;
Ftotal_x(index(1):end)=0;
% 绘制力、加速度、速度和位移随时间的变化
figure;
subplot(4, 1, 1);
plot(t, Ftotal_x);
title('Force vs. Time');
ylabel('Force (N)');
xlabel('Time (s)');

subplot(4, 1, 2);
plot(t, a);
title('Acceleration vs. Time');
ylabel('Acceleration (m/s^2)');
xlabel('Time (s)');

subplot(4, 1, 3);
plot(t, v);
title('Velocity vs. Time');
ylabel('Velocity (m/s)');
xlabel('Time (s)');

subplot(4, 1, 4);
plot(t, x);
title('Displacement vs. Time');
ylabel('Displacement (m)');
xlabel('Time (s)');

% figure;
% plot(pos_x, Fx_EM);
