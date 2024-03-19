clear all
close all


t = [300 260	220	200	180	160	140	120	100	80	60	40	20	10]
T = 2.7;
b = 3.5;
p= 1;
y = [0.1700	0.8300	0.5000	0.3300	0.5000	0.6700	0.3300	0.5000	0.3300	0.5000	0.3300	0.6700	0.5000	0.6700
];

plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;

T0 = 200;
b0 = 10;
p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);
estimated_param = lsqcurvefit('weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );

% Display results

T_es = estimated_param(1);
b_es = estimated_param(2);
p_es = estimated_param(3);

%disp(['Estimated T: ' num2str(T_es)]); %disp(['Estimated b: ' num2str(b_es)]);

z = Weibull(t, T_es, b_es, p_es); 
plot(t,y,'ro');hold on; plot(t,z,'b');
t80= fzero( 'WeibMinus', 0, [], T_es, b_es, p_es, .8 )
legend('data',['Weibull: T= ' num2str(T_es) ',   b= ' num2str(b_es) ',  t80= ' num2str(t80) ', p= ' num2str(p_es)]);
disp(['Estimated t80: ' num2str(t80)]);
