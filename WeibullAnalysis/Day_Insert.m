function Day_Insert

clearvars;
close all;

SubjectColumn = 'A';
WriteColumn = 'L';
DateColumn = 'K';
CheckColumn = 'E';

worksheet = 'data.xlsx';
[~,sheets] = xlsfinfo(worksheet);
sheet = char(sheets(1));

xlswrite(worksheet,0,sheet,[WriteColumn,'2']);
xlswrite(worksheet,0,sheet,[CheckColumn,'2']);
temp = xlsread(worksheet,sheet,[WriteColumn,':',WriteColumn]);
check = xlsread(worksheet,sheet,[CheckColumn,':',CheckColumn]);
Row1 = length(temp)+2;

while Row1<length(check)+1
    
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
    [~,temp] = xlsread(worksheet,sheet,[SubjectColumn,num2str(Row1-1),':',SubjectColumn,num2str(Row1)]);
    if ~strcmp(char(temp(1)),char(temp(2)))
        Day = 1;
    elseif isempty(xlsread(worksheet,sheet,[WriteColumn,num2str(Row1-1)]))
        Day = 1;
    else
        Day = xlsread(worksheet,sheet,[WriteColumn,num2str(Row1-1)])+1;
    end
    [~,temp] = xlsread(worksheet,sheet,[SubjectColumn,num2str(Row1),':',SubjectColumn,'1048576']);
    subject = char(temp(1));
    NextRow = Row1 + find(~strcmp(temp,temp(1)),1)-1;
    if isempty(NextRow)
        NextRow = length(check)+1;
    end
    while Row1<NextRow
        [~,temp] = xlsread(worksheet,sheet,[DateColumn,num2str(Row1),':',DateColumn,num2str(NextRow)]);
        temp = char(temp);
        temp(:,7:end) = [];
        temp = cellstr(temp);
        Length = find(~strcmp(temp,temp(1)),1)-1;
        if isempty(Length)
            Length = NextRow-Row1+1;
        end
        fprintf(['Subject ',subject,', Day ',num2str(Day),'\n']);
        xlswrite(worksheet,Day*ones(Length,1),sheet,[WriteColumn,num2str(Row1)]);
        Row1 = Row1 + Length;
        Day = Day+1;
    end
    
end

end