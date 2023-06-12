% Paramètres et grandeurs physiques


best_Kp = 2.8;
best_Ki = 0;
best_Kd = 1.5;
% pid(best_Kp,best_Ki,best_Kd)
pid(0.8,0,3.4/8);
st=1000;
% for Kp=0.1:0.1:3
%     for Ki=0:0.1:3
%         for Kd=0:0.1:3
%             settled_time=pid(Kp,Ki,Kd);
%             if settled_time<st
%                 st=settled_time;
%                 best_Kp=Kp;
%                 best_Ki=Ki;
%                 best_Kd=Kd;
%             end
%         end 
%     end 
% end

function st=pid(Kp,Ki,Kd)
    M_MPM = 0.38e-3; 
    P_MPM = M_MPM * 9.81; 
    course = 0.1e-3; 
    mu_f = 0.4; 
    E=0;
    R=1;
    simulation_time = 20;
    dt = 0.01;
    C_R=0.75;
    object_pos = 0;
    object_acc = 0;
    object_vite = 0;
    integral_term=0;
    
    x = [];
    v=[];
    a=[];
    fx=[];
    e=[];
    for t = 0:dt:simulation_time
        error = course - object_pos;
        control_ix = Kp * error + Ki * integral_term - Kd * object_vite;
        e=[e error];
        Fx_EM = control_ix *(2.1252E+18 * object_pos.^6 - 9.7281E+07 * object_pos.^5 - 5.0226E+10 * object_pos.^4 + 1.3028E+00 * object_pos.^3 + 4.9317E+02 * object_pos.^2 - 1.0385E-07 * object_pos + 1.3115E-03);
        Fz_EM = control_ix *(-1.4456E+07 * object_pos.^3 + 1.2642E-05 * object_pos.^2 - 2.9536E-01 * object_pos + 9.3282E-14);
        
        Ftotal_x = Fx_EM;
        Ftotal_z = P_MPM + Fz_EM;
        Wnet = M_MPM * 9.81 - Ftotal_z;
        Ff = Wnet * mu_f;
        fx=[fx Ftotal_x];
        object_acc = (Ftotal_x - Ff) / M_MPM;
        object_vite = object_vite + object_acc * dt;
        object_pos = object_pos + object_vite * dt;
        
        integral_term = integral_term + error * dt;
        E = E+control_ix.^2*R*dt;
        x = [x object_pos];
        a = [a object_acc];
        v = [v object_vite];
    end
    index = find(abs(e)>0.01*course);
    st = index(end) * dt;
    plot(x);
    fprintf('Total energie:%s\n',E);
end

