function err = weibulltmp(estimated_param,t,y,handle)
% weibull_err

% p_es = estimated_param(1);
T_es = estimated_param(1)/1000;
b_es = estimated_param(2);
%p_es = estimated_param(3);


z = Weibulltmp(t/1000, T_es, b_es); 
err = norm(z-y);

% option: display optimization process
set(gcf,'DoubleBuffer','on');set(handle,'ydata',z);drawnow;pause(.04)