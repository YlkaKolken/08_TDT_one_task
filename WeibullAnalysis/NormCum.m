function z= NormCum(t, T, b, p)

if t<0,
    z= 0;
else
    %z = (1+p*(1-exp(-(t/T).^b)))/2;
    %z=1-exp(-(t/T).^b)/2;
    zz=(t-T)/b;
    z=((1+erf(zz/sqrt(2)))/2+1)/2;
    % -0.0266;
end