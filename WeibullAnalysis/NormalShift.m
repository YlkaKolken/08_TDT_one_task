close all;
clear all;
fit=1; %'norm'; %'weib'; 
subject='Yaron';file_name='yaron_34';
%subject='Rivka';file_name='rivka_34';
%subject='Dmitry';file_name='dmitry_34';
LN2=log(2);
%WeibCorr=0.337; %to set threshold to 81.6% correct
WeibCorr=0; %to set threshold to 75% correct

load(file_name);

t = nfdat(:,1);  y = nfdat(:,2); 
figure(4);plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;
T0 = 6; b0 = 2; p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);
if(fit=='norm')[estimated_param err] = lsqcurvefit('NormCum_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
else [estimated_param err] = lsqcurvefit('Weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
end
    r2_0=1-err/(var(y)*length(y))
% Display results
T_es = estimated_param(1);b_es = estimated_param(2);p_es = estimated_param(3);
if(fit=='norm')z = NormCum(t, T_es, b_es, p_es); 
    Tnf=T_es+WeibCorr*b_es; Snf=b_es;
else z = Weibull(t, T_es, b_es, p_es); 
 Tnf=T_es*LN2.^(1/b_es); Snf=b_es;
end
figure(5); semilogx(t,y,'ro');hold on; semilogx(t,z,'b');

t = col3dat(:,1);  y = col3dat(:,2); 
figure(4);plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;
T0 = 6; b0 = 2; p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);
if(fit=='norm')[estimated_param err] = lsqcurvefit('NormCum_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
else [estimated_param err] = lsqcurvefit('Weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
end
    r2_0=1-err/(var(y)*length(y))
% Display results
T_es = estimated_param(1);b_es = estimated_param(2);p_es = estimated_param(3);
if(fit=='norm') z = NormCum(t, T_es, b_es, p_es);
    Tc3=T_es+WeibCorr*b_es; Sc3=b_es;
else z = Weibull(t, T_es, b_es, p_es); 
 Tc3=T_es*LN2.^(1/b_es); Sc3=b_es;
end
figure(5); semilogx(t,y,'ro');hold on; semilogx(t,z,'b');

t = col4dat(:,1);  y = col4dat(:,2); 
figure(4);plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;
T0 = 6; b0 = 2; p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);
if(fit=='norm')[estimated_param err] = lsqcurvefit('NormCum_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
else [estimated_param err] = lsqcurvefit('Weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
end
    r2_0=1-err/(var(y)*length(y))
% Display results
T_es = estimated_param(1);b_es = estimated_param(2);p_es = estimated_param(3);
if(fit=='norm') z = NormCum(t, T_es, b_es, p_es);
    Tc4=T_es+WeibCorr*b_es; Sc4=b_es;
else z = Weibull(t, T_es, b_es, p_es); 
 Tc4=T_es*LN2.^(1/b_es); Sc4=b_es;
end
figure(5); semilogx(t,y,'ro');hold on; semilogx(t,z,'b');


t = orth3dat(:,1); y = orth3dat(:,2); 
figure(4);plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;
T0 = 6; b0 = 2; p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);
if(fit=='norm')[estimated_param err] = lsqcurvefit('NormCum_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
else[estimated_param err] = lsqcurvefit('Weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
end
    r2_0=1-err/(var(y)*length(y))
% Display results
T_es = estimated_param(1);b_es = estimated_param(2);p_es = estimated_param(3);
if(fit=='norm') z = NormCum(t, T_es, b_es, p_es);
    To3=T_es+WeibCorr*b_es; So3=b_es;
else z = Weibull(t, T_es, b_es, p_es); 
 To3=T_es*LN2.^(1/b_es); So3=b_es;
end
figure(5); semilogx(t,y,'ro');hold on; semilogx(t,z,'b');


t = orth4dat(:,1); y = orth4dat(:,2); 
figure(4);plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;
T0 = 6; b0 = 2; p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);
if(fit=='norm')[estimated_param err] = lsqcurvefit('NormCum_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
else[estimated_param err] = lsqcurvefit('Weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
end
    r2_0=1-err/(var(y)*length(y))
% Display results
T_es = estimated_param(1);b_es = estimated_param(2);p_es = estimated_param(3);
if(fit=='norm') z = NormCum(t, T_es, b_es, p_es);
    To4=T_es+WeibCorr*b_es; So4=b_es;
else z = Weibull(t, T_es, b_es, p_es); 
 To4=T_es*LN2.^(1/b_es); So4=b_es;
end
figure(5); semilogx(t,y,'ro');hold on; semilogx(t,z,'b');
legend(['Tnf= ' num2str(Tnf) '   Snf= ' num2str(Snf)],['Tc3= ' num2str(Tc3) '    Sc3= ' num2str(Sc3)],['Tc4= ' num2str(Tc4) '    Sc4= ' num2str(Sc4)],['To3= ' num2str(To3) '    So3= ' num2str(So3)],['To4= ' num2str(To4) '    So4= ' num2str(So4)]);
s3=Tnf-Tc3;s4=Tnf-Tc4;so3=Tnf-To3;so4=Tnf-To4;

title(subject); 
figure(1);
plot(nfdat(:,1),nfdat(:,2),col3dat(:,1)+s3,col3dat(:,2),col4dat(:,1)+s4,col4dat(:,2),orth3dat(:,1)+so3,orth3dat(:,2),orth4dat(:,1)+so4,orth4dat(:,2));
legend('nf',['s3=' num2str(s3)],['s4=' num2str(s4)],['so3=' num2str(so3)],['so4=' num2str(so4)])
title(subject);
