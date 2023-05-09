% Paramètres et grandeurs physiques
M_MPM = 0.38e-3; % kg
P_MPM = M_MPM * 9.81; % N
course = 0.1e-3; % m
mu_f = 0.4; % Sans unité

% vecteur de temps
t = linspace(0, 0.01, 1000); % s

% position x vecteur
pos_x = linspace(0, 0.1e-3, 1000); % m

% Calculer Fx_M, Fx_EM et Fz_EM
ix = 1; % Supposons que le courant est de 1A
Fx_M = 3.7293E+01 * pos_x - 4.3152E-11;
Fx_EM = ix * (2.1252E+18 * pos_x.^6 - 9.7281E+07 * pos_x.^5 - 5.0226E+10 * pos_x.^4 + 1.3028E+00 * pos_x.^3 + 4.9317E+02 * pos_x.^2 - 1.0385E-07 * pos_x + 1.3115E-03);
Fz_EM = ix * (-1.4456E+07 * pos_x.^3 + 1.2642E-05 * pos_x.^2 - 2.9536E-01 * pos_x + 9.3282E-14);

% Calculer Ftotal_x (la composante de la force résultante sur l'axe des x)
Ftotal_x = Fx_M + Fx_EM;

% Calculer Ftotal_z (la composante de la force résultante sur l'axe z)
Ftotal_z = P_MPM + Fz_EM;

% Calculer le poids net
Wnet = M_MPM * 9.81 - Ftotal_z;

% Calcul du frottement
Ff = Wnet * mu_f;

% Calculer l'accélération
a = (Ftotal_x - Ff) / M_MPM;

% Calculer la vitesse à l'aide de la fonction intégrale
v = cumtrapz(t, a);

% Calculer le déplacement à l'aide de la fonction intégrale
x = cumtrapz(t, v);
index = find(x>course);
x(index(1):end)=course;
v(index(1):end)=0;
a(index(1):end)=0;
Ftotal_x(index(1):end)=0;
% Tracer la force, l'accélération, la vitesse et le déplacement dans le temps
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
