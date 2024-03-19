function z = NormCum_err1(estimated_param, t, handle)
% weibull_err

% p_es = estimated_param(1);
T_es = estimated_param(1); %/1000;
b_es = estimated_param(2);
%p_es = estimated_param(3);

%z = Weibull(t/1000, T_es, b_es, p_es); 
%z = NormCum(t, T_es, b_es, p_es); 
z = NormCum(t, T_es, b_es); 
% option: display optimization process
set(gcf,'DoubleBuffer','on');
set(handle,'ydata',z);
drawnow;
pause(.04)