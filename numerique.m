% Paramètres et grandeurs physiques
M_MPM = 0.38e-3; % kg
P_MPM = M_MPM * 9.81; % N
course = 0.1e-3; % m
mu_f = 0.4; % 无单位
R=1;
% vecteur de temps
simulation_time = 0.05;
dt = 0.0001;
C_R=0.75;
object_pos = 0;
object_acc = 0;
object_vite = 0;
control_ix=0.01;
x = [];
v=[];
a=[];
fx=[];
e=[];
for t = 0:dt:simulation_time
    error = course - object_pos;
    e=[e error];
    Fx_M = 3.7293E+01 * object_pos - 4.3152E-11;
    Fx_EM = control_ix * (2.1252E+18 * object_pos.^6 - 9.7281E+07 * object_pos.^5 - 5.0226E+10 * object_pos.^4 + 1.3028E+00 * object_pos.^3 + 4.9317E+02 * object_pos.^2 - 1.0385E-07 * object_pos + 1.3115E-03);
    Fz_EM = control_ix * (-1.4456E+07 * object_pos.^3 + 1.2642E-05 * object_pos.^2 - 2.9536E-01 * object_pos + 9.3282E-14);
    
    Ftotal_x = Fx_M + Fx_EM;
    Ftotal_z = P_MPM + Fz_EM;
    Wnet = M_MPM * 9.81 - Ftotal_z;
    Ff = Wnet * mu_f;
    fx=[fx Fx_EM];
    object_acc = (Ftotal_x - Ff) / M_MPM;
    object_vite = object_vite + object_acc * dt;
    object_pos = object_pos + object_vite * dt;

    if object_pos >= course
        object_vite = -C_R*object_vite;
        object_pos = course;
    end
    x = [x object_pos];
    a = [a object_acc];
    v = [v object_vite];
    index = find(abs(e)>0.01*course);
    st = index(end) * dt;
    E = control_ix.^2*R*st;
   
end
fprintf('Total energie:%s\n',E);
plot(x)
