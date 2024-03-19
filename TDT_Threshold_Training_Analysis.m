function TDT_Threshold_Training_Analysis

% This function calculates a Weibull analysis for a single session in an
% output file from the TDT_Threshold_Training function.

% Asking for subject name or number:
prompt = {'Subject Name/Number:'};
dlg_title = 'Name Choosing';

% Checking if the subject exists, if not asking again:
while 1
    inputs = inputdlg(prompt,dlg_title,1);
    if isempty(inputs)
        return
    end
    SubjectName = char(inputs(1));
    filename = ['TDT_Subject_',num2str(SubjectName),'_Results.mat'];
    if ~isempty(dir(filename))
        break
    end
    h = warndlg(['Subject ',SubjectName,' does not exist!']);
    uiwait(h);
end

% If no threshold training results exist for the subject, a warning
% displays and afterwards the function terminates:
W = whos(matfile(filename));
Continue = 0;
for i = 1:length(W)
    if strcmp(W(i).name,'ThresholdTraining')
        load(filename);
        Continue = 1;
        break
    end
end
if ~Continue
    h = warndlg(['Threshold Training for Subject ',SubjectName,' does not exist!']);
    uiwait(h);
    return
end

% Asking for session number. If the number if illegal or the session does
% not exist, the function asks again:
prompt = {'Session:'};
dlg_title = 'Session Choosing';
begin = 0;
while ~begin
    inputs = inputdlg(prompt,dlg_title,1);
    begin = 1;
    if isempty(inputs)
        return
    end
    Session = str2double(char(inputs(1)));
    if isnan(Session)
        h = warndlg('The Session must be a number!');
        uiwait(h);
        begin = 0;
    end
    if length(ThresholdTraining.Parameters)<Session %#ok<*NODEF>
        h = warndlg(['No Data for Session ',num2str(Session),' for subject ',num2str(SubjectName),'!']);
        uiwait(h);
        begin = 0;
    end
end

% Checking if a Initial training struct exists to save it again:
SaveInitialTraining = 0;
W = whos;
for i = 1:length(W)
    if strcmp(W(i).name,'InitialTraining')
        SaveInitialTraining = 1;
        break
    end
end

% Weibull analysis:
% Parameters for the analysis:
start = [200; 10; 1];
options = optimset('TolX',0.1);
% The SOA times vector:
T = sort(unique(ThresholdTraining.Times(Session).SOAs,'stable'),'descend')';
figure;
% The average success ratio per SOA:
y = mean(ThresholdTraining.Output(Session).SOASuccess(:,2,:),3);
% Plotting the results:
plot(T,y,'ro');
hold on;
h = plot(T,y,'b');
hold on;
% Calculating the Weibull fit:
temp = lsqcurvefit('weibull_err1',start, T, y, [0 0 0], [inf inf 1], options, h );
% Saving the Weibull fit results:
ThresholdTraining.WeibullAnalysis(Session).T_es = temp(1);
ThresholdTraining.WeibullAnalysis(Session).b_es = temp(2);
ThresholdTraining.WeibullAnalysis(Session).p_es = temp(3);
ThresholdTraining.WeibullAnalysis(Session).t80 = fzero( 'WeibMinus', 0, [], temp(1), temp(2), temp(3), .8 );
% Plotting the Weibull fit curve:
z = Weibull(T, temp(1), temp(2), temp(3));
plot(T,z,'b');
% Displaying the results on top of the graph:
legend('data',['Weibull: T= ' num2str(temp(1)) ',   b= ' num2str(temp(2)) ',  t80= ' num2str(ThresholdTraining.WeibullAnalysis(Session).t80) ', p= ' num2str(temp(3))]);
disp(['Estimated t80: ' num2str(ThresholdTraining.WeibullAnalysis(Session).t80)]);

% Saving the figure under the subject name in a local backup folder, a
% drive backup folder, and in the MATLAB's current folder.
% When the backup folders do not exist, no backup is saved and a
% warning message displays:
try
    saveas(gcf,['C:\Backups\','Weibull_Graph_Subject_',SubjectName,'_Session_Number_',num2str(Session),datestr(now,'dd.mm.yy-HHMMSS'),'.fig']);
catch
    fprintf('''C:\\Backups'' folder does not exist, and no local backup figure saved!\n');
end
try
    saveas(gcf,['Z:\Yehuda\Backups\','Weibull_Graph_Subject_',SubjectName,'_Session_Number_',num2str(Session),datestr(now,'dd.mm.yy-HHMMSS'),'.fig']);
catch
    fprintf('''Z:\\Yehuda\\Backups'' folder does not exist, and no drive backup figure saved!\n');
end
saveas(gcf,['Weibull_Graph_Subject_',SubjectName,'_Session_Number_',num2str(Session),'.fig']);
    
% Saving the data under the subject name in a local backup folder, a
% drive backup folder, and in the MATLAB's current folder.
% When the backup folders do not exist, no backup is saved and a
% warning message displays:
if SaveInitialTraining
    try
        save(['C:\Backups\',filename,'_PostWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining', 'InitialTraining');
    catch
        fprintf('''C:\\Backups'' folder does not exist, and no local backup saved!\n');
    end
    try
        save(['Z:\Yehuda\Backups\',filename,'_PostWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining', 'InitialTraining');
    catch
        fprintf('''Z:\\Yehuda\\Backups'' folder does not exist, and no drive backup saved!\n');
    end
    save(filename, 'SubjectName', 'ThresholdTraining', 'InitialTraining');
else
    try
        save(['C:\Backups\',filename,'_PostWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining');
    catch
        fprintf('''C:\\Backups'' folder does not exist, and no local backup saved!\n');
    end
    try
        save(['Z:\Yehuda\Backups\',filename,'_PostWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining');
    catch
        fprintf('''Z:\\Yehuda\\Backups'' folder does not exist, and no drive backup saved!\n');
    end
    save(filename, 'SubjectName', 'ThresholdTraining');
end

end
