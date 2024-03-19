clear all
close all


t = [260 220 200 180 160 140 120]
T = 2.7;
b = 3.5;
y = [1 1 1 0.9733 0.92 0.68 0.4933];

plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;

T0 = 100;
b0 = 0.6;
start = [T0 ; b0];
options = optimset('TolX',0.1);
estimated_param = fminsearch('weibull_err',start,options,t,y,h);

% Display results

T_es = estimated_param(1);
b_es = estimated_param(2);

%disp(['Estimated T: ' num2str(T_es)]); %disp(['Estimated b: ' num2str(b_es)]);

z = Weibull(t, T_es, b_es); 
plot(t,y,'ro');hold on; plot(t,z,'b');
t80= fzero( 'WeibMinus', 0, [], T_es, b_es, .8 )
legend('data',['Weibull: T= ' num2str(T_es) ',   b= ' num2str(b_es) ',  t80= ' num2str(t80)]);
disp(['Estimated t80: ' num2str(t80)]);
