
function [T b fe llk]=fit_2012_indi(x,pp,N)
w=1;

  %%w=3; %%%7/8/2014
 Starting=[150 4 0.05 ]; 
     

     x=[340 300 260	240 220	200	180	160	140	120	100	80	60	40];  % 
  
     %800 700 500 400 300 260 220 200 180 160 140 120 100 80 60 40
     %800	500	300	260	220	200	180	160	140	120	100	80	60	40	20	10
     %%iASD
     %eccen:
     %400	340	300	260	220	200	180	160	140	120	100	80	60	40	20
    

    
pp= [1.0000	1.0000	0.8333	1.0000	1.0000	0.8333	1.0000	0.8333	0.8333	0.8333	1.0000	0.8333	0.3333	0.5000
];

%smooth
%  pc1=(pc(1:end-1)+pc(2:end))/2;
%  so1=(so(1:end-1)+so(2:end))/2;
 % pp=(pp(1:end-1)+pp(2:end))/2;
  %x=(x(1:end-1)+x(2:end))/2;



%pp=pp';
N=12;  %%!

n=size(pp)

i=1; %%!
for i=1:n(1)  %%to perform only 1 fit 
     p=pp(i,:)

 
        options=optimset('Display','off','FunValCheck','on');
        [estimated_param0 llk0]=fminsearch(@weibfit_mlk,Starting,options,x,p,N,w);
        [estimated_param llk]=fminsearch(@weibfit_mlk,estimated_param0,options,x,p,N,0); %%~
        T=estimated_param(1);
        b=estimated_param(2)
        fe=estimated_param(3)
        
        Tfin(i)=T
        fefin(i)=fe
        figure(i); plot(x,pp(i,:),'-*',x,smooth(pp(i,:),w));
        z = Weibull(x, T, b, 1-fe); hold on; plot(x,z,'r'); hold off;
        legend('data',['Weibull: T=' num2str(T) ',   b=' num2str(b) ',  fe=' num2str(fe ) ',  llk=' num2str(llk)],'Location','SouthEast');
end
end
  

function llk=weibfit_mlk(params,Input,P,N,w)
     t=Input;
     T=params(1); b=params(2);  fe=params(3);
     if w>0     Ps=smooth(P,w)';
        else    Ps=P; end
   % Nc=round(N.*Ps);
  %  Ne=N-Nc;
  
% if T>10 & T<400 & b>0 & fe<=1 & fe>=0 % n=6 %%grand daily avg data n=18

 if T>10 & T<400 & b>1 & fe<=1 & fe>=0 %for one third of  a daily session  %%!% B>3 used in iASD, ISSI 2013
  
  
        Pf= (fe/2+(1-fe)*(1-0.5*exp(-(t/T).^b)))- 10e-5;
  
        llk= -sum(  Nc.*log(Pf)+  Ne.*log(1-Pf) + sum(log(1:N)) - sum(log(1:Nc)) - sum(log(1:Ne))   )   
        if isnan(llk) llk=10e10 ; end
    else
        llk=10e10;
end
end


 
  


