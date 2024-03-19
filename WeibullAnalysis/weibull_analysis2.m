function weibull_analysis2

clearvars;
close all;

WriteColumn = 'M';
ReadColumns = 'FG';
CheckColumn = 'E';

T0 = 200;
b0 = 10;
p0 = 1;
start = [T0 ; b0 ; p0];
options = optimset('TolX',0.1);

worksheet = 'data.xlsx';
[~,sheets] = xlsfinfo(worksheet);
sheet = char(sheets(1));
% xlswrite(worksheet,0,sheet,[WriteColumn,'2']);
% xlswrite(worksheet,0,sheet,[CheckColumn,'2']);
temp = xlsread(worksheet,sheet,[WriteColumn,':',WriteColumn]);
check = xlsread(worksheet,sheet,[CheckColumn,':',CheckColumn]);
Row1 = length(temp)+2;
stop = 0;
while ~stop
    if isempty(xlsread(worksheet,sheet,[CheckColumn,num2str(Row1)]))
        Row1 = Row1+1;
    elseif xlsread(worksheet,sheet,[CheckColumn,num2str(Row1)])~=1
        Row1 = Row1+1;
    else
        stop = 1;
    end
end

while ~isempty(Row1)
    
    Row2 = Row1 + min(find(check(Row1:end)==1,1),find(isnan(check(Row1:end)),1))-1;
    if isempty(Row2)
        Row2 = Row1 + find(check(Row1:end)==1,1)-1;
    end
    if isempty(Row2)
        Row2 = length(check)+1;
    end
    results = zeros(Row2-Row1+1,2);
    temp = xlsread(worksheet,sheet,[ReadColumns(1),num2str(Row1),':',ReadColumns(2),num2str(Row2)]);
    temp(isnan(temp(:,2)),:)=[];
    [t,b] = sort(temp(:,1));
    y = temp(b,2);
    figure(1);
    fprintf(['Row ',num2str(Row1),'\n']);
    plot(t,y,'ro');hold on; h = plot(t,y,'b'); hold off;
    estimated_param = lsqcurvefit('weibull_err1',start, t, y, [0 0 0], [inf inf 1], options, h );
    T_es = estimated_param(1);
    %b_es = estimated_param(2);
    p_es = estimated_param(3);
    %t80 = fzero( 'WeibMinus', 0, [], T_es, b_es, p_es, .8 );
    results(:,1) = T_es;
    results(:,2) = p_es;
    close all;
    xlswrite(worksheet,results,sheet,[WriteColumn,num2str(Row1)]);
    Row1 = Row2 + find(check(Row2:end)==1,1);
    
end

end