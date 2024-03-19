function z= Weibull(t, T, b, p)

if t<0,
    z= 0;
else
    z = (1+p*(1-exp(-(t/T).^b)))/2;
    %z=1-exp(-(t/T).^b)/2;
    % -0.0266;
end