function results = weibull_analysis(subject,row)

close all;

t = [ 340 300 260 240 220 200 180 160 140 120 100 80 60 40 ]';
T0 = 200;
b0 = 10;
p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);

j = 1;
column = 0;
worksheet = 'ReactivationStudy_analysis updated_R04.02.xlsx';
[~,sheets] = xlsfinfo(worksheet);
sheet = '0';
i=1;
number = num2str(subject);
while strcmp(sheet,'0')
    temp = char(sheets(i));    
    if ~isempty(strfind(temp,number))
        sheet = char(sheets(i));
    end
    i = i+1;
end
[~,~,temp] = xlsread(worksheet,sheet,['A',num2str(row),':ZZ',num2str(row)]);
temp=cell2struct(temp,'value',1);
for i=1:length(temp) 
    if ischar(temp(i).value) && strcmp(temp(i).value,'avg')
            column(j) = i; %#ok<*AGROW>
        j = j+1;
    end
end
results = zeros(length(column),4);
for i = 1:length(column)
    if column(i)<27
        range(i).result = [char(64+column(i)),num2str(row+15)];
        range(i).str = [num2str([char(64+column(i)),num2str(row+1)]),':',num2str([char(64+column(i)),num2str(row+14)])];
    else
        range(i).result = [char(64+floor(column(i)/26)),char(64+rem(column(i),26)),num2str(row+15)];
        range(i).str = [num2str([char(64+floor(column(i)/26)),char(64+rem(column(i),26)),num2str(row+1)]),':',num2str([char(64+floor(column(i)/26)),char(64+rem(column(i),26)),num2str(row+14)])];
    end
    if range(i).result(2)=='@'
        range(i).result(1)=range(i).result(1)-1;
        range(i).result(2)='Z';
        range(i).str(1)=range(i).str(1)-1;
        range(i).str(2)='Z';
        range(i).str(5)=range(i).str(5)-1;
        range(i).str(6)='Z';
    end
    y = xlsread(worksheet,sheet,range(i).str);
    figure(i);
    plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;
    estimated_param = lsqcurvefit('weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
    T_es = estimated_param(1);
    b_es = estimated_param(2);
    p_es = estimated_param(3);
    t80= fzero( 'WeibMinus', 0, [], T_es, b_es, p_es, .8 );
    results(i,:) = [T_es,b_es,t80,p_es];
%     xlswrite(worksheet,[results(i,1);results(i,4)],sheet,num2str(range(i).result));
end
close all;

% temp = xlsread(worksheet,'rawdata','C7:C200');
% I = num2str(find(temp==subject)+6);
% temp = xlsread(worksheet,'rawdata',['W',I,':AQ',I]);
% temp(10:end)=[];
% result = results(:,1)';
% temp(isnan(temp)) = result(isnan(temp));
% xlswrite(worksheet,temp,'rawdata',['W',num2str(I)]);

end
