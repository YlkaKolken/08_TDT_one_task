function TDT_Threshold_PreTraining

%% TDT Threshold Finding training.
%
% No variables are saved in the workspace, only to file.
% syntax: "TDT_Threshold_PreTraining;".

%% Get parameters through GUI.

str = {'Mouse','Keyboard'};
[Selection,~] = listdlg('PromptString','Select Response Device:',...
                         'SelectionMode','single',...
                         'ListString',str);
                     
if isempty(Selection)
    return
end
                     
if Selection==1
    ResponseDevice = 'Mouse';
    prompt1 = {'Subject Name/Number:','Session:','Day:','Group:',...
               'Target Display Time (ms):','Orientation'};
    defaultans1 = {'','','','','10',''};
else
    ResponseDevice = 'Keyboard';
    prompt1 = {'Subject Name/Number:','Session:','Day:','Group:',...
               'Target Display Time (ms):','Orientation','T/row keys:','L/column keys:'};
    defaultans1 = {'','','','','10','','2','3'};
end
prompt2 = {'Number of Vertical Lines:','Number of Horizontal Lines:','Relative Size:',...
           'Screen Width:','Screen Height:','Screen Refresh Rate (Hz):'};
defaultans2 = {'19','19','0.93','1152','864','100'};

dlg_title = 'Parameters Choosing';
num_lines = 1;
begin = 0;

while ~begin
    
    inputs1 = inputdlg(prompt1,dlg_title,num_lines,defaultans1);
    if isempty(inputs1)
        return
    end
    begin = 1;
    for i=1:length(prompt1)
        if isempty(cell2mat(inputs1(i)))
            h = warndlg('Please enter all inputs!');
            uiwait(h);
            begin = 0;
        end
    end
    if isnan(str2double(char(inputs1(2))))
        h = warndlg('The Session must be a number!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs1(3))))
        h = warndlg('The Day must be a number!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs1(4))))
        h = warndlg('The Group must be a number!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs1(5))))
        h = warndlg('Target display time (in miliseconds) must be a number!');
        uiwait(h);
        begin = 0;
    end
    if ~strcmpi(char(inputs1(6)),'-') && ~strcmpi(char(inputs1(6)),'|')
        h = warndlg('Orientation must be either "-" or "|"!');
        uiwait(h);
        begin = 0;
    end
    SubjectName = char(inputs1(1));
    filename = ['TDT_Threshold_PreTraining_Subject_',num2str(SubjectName),'_Results.mat'];
    if ~isempty(dir(filename))
        load(filename);
        if length(Parameters) == str2double(char(inputs1(2))) %#ok<NODEF>
            choice = questdlg(['TDT Threshold PreTraining results for subject "',SubjectName,'" Session ',char(inputs1(2)),' already exist and will be overwritten, continue?'],'!!WARNING!!','Yes','No','No');
            if strcmp(choice,'No')
                begin = 0;
            end
        end
    end
    
end

begin = 0;
while ~begin
    
    inputs2 = inputdlg(prompt2,dlg_title,num_lines,defaultans2);
    if isempty(inputs2)
        return
    end
    begin = 1;
    if isnan(str2double(char(inputs2(1))))
        h = warndlg('Number of vertical lines must be a number!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs2(2))))
        h = warndlg('Number of horizontal lines must be a number!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs2(3)))) || str2double(char(inputs2(3)))<0 || str2double(char(inputs2(3)))>1 
        h = warndlg('Relative size of screen must be a number between 0 ans 1!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs2(4)))) && ~isempty(char(inputs2(4)))
        h = warndlg('The screen width (in pixels) must be a number!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs2(5)))) && ~isempty(char(inputs2(5)))
        h = warndlg('The screen height (in pixels) must be a number!');
        uiwait(h);
        begin = 0;
    end
    if isnan(str2double(char(inputs2(6)))) && ~isempty(char(inputs2(6)))
        h = warndlg('The screen refresh rate (in Hertz) must be a number!');
        uiwait(h);
        begin = 0;
    end
    
end

%% Parameter tunning. Change values only in this section.

% Changable parameters for the experiment.
% Standard values are for out fMRI experiment in ICHILOV, January 2016.
Session = str2double(char(inputs1(2)));
%Non-time parameters:
Parameters(Session).ResponseDevice = ResponseDevice;
Parameters(Session).Day = str2double(char(inputs1(3)));
Parameters(Session).Group = str2double(char(inputs1(4)));
Parameters(Session).VL = str2double(char(inputs2(1))); % Number of lines in each column. Standard is 19.
Parameters(Session).HL = str2double(char(inputs2(2))); % Number of lines in each row. Standard is 19.
Parameters(Session).BackgroundColor = 1; % Color of background. Standard is 1.
Parameters(Session).StimuliColor = 255; % Color of lines and letters in stimuli. Standard is 255.
Parameters(Session).TextColor = 255; % Color of written text. Standard is 255.
Parameters(Session).MaskColor = 200; % Color of mask. Standard is 200.
Parameters.GammaCorrection = 2.8252; % Gamma correction value for the colors.
                                     % Value according to measurements on
                                     % CRT screen at the TMS room at the lab in 18/09/2016.
% Parameters(Session).GammaCorrection = 2.8303; % Gamma correction value for the colors.
                                              % Value according to measurements on
                                              % CRT screen at the TDT room at the lab in 06/07/2016.
% Parameters(Session).GammaCorrection = 3.2547; % Gamma correction value for the colors.
                                              % Value according to measurements on
                                              % CRT screen at the lab in 03/04/2016.
Parameters(Session).CircleRadius = 9; % The fixation circle radius in pixels. Standard is 9.
Parameters(Session).CircleWidth = 1; % The fixation circle width in pixels. Standard is 1.
Parameters(Session).CrossWidth = 2; % The fixation cross width in pixels. Standard is 2.
Parameters(Session).CrossLength = 30; % The fixation cross length in pixels. Standard is 30.
Parameters(Session).Hjitter = 2; % The horizontal jitter effect- maximum number of pixels each 
                        % line is allowed to shift from its original location. Standard is 2.
Parameters(Session).Vjitter = 2; % The vertical jitter effect. Standard is 2.
Parameters(Session).LineLength = 28; % The length of each background line in pixels. Standard is 28.
Parameters(Session).LineWidth = 2; % The width of each background line in pixels. Standard is 2.
Parameters(Session).LetterLength = 8; % The length of each center letter line in pixels. Standard is 8.
Parameters(Session).LetterWidth = 2; % The width of each center letter line in pixels. Standard is 2.
Parameters(Session).TargetLength = 28; % The length of each target line in pixels. Standard is 28.
Parameters(Session).TargetWidth = 2; % The width of each target line in pixels. Standard is 2.
Parameters(Session).a = str2double(char(inputs2(3))); % Relative size of screen on which to display images.
Parameters(Session).BeepFrequency = 400; % Frequency of error sound in [Hz]. Standard is 400.
Parameters(Session).BeepDuration = 0.08; % Duration of error sound in seconds. Standard is 0.08.
Parameters(Session).BeepVolume = 0.4; % Volume of error sound. Standard is 0.4.

if strcmp(Parameters(Session).ResponseDevice,'Keyboard')
    Parameters(Session).T_Hor = char(inputs1(7)); % Keys for identifying 'T' for fixation and horizontal for alignment.
    Parameters(Session).L_Ver = char(inputs1(8)); % Keys for identifying 'L' for fixation and vertical for alignment.
end
Parameters(Session).Orientation = char(inputs1(6));

%Times/Durations:
Times(Session).FirstFixation = 3.000; % Time of pre-experiment (dummy) cross-fixation
                             % block. Standard is 3.000.
Times(Session).FinalFixation = 3.000; % Time of post-experiment (rest) cross-fixation
                              % block. Standard is 3.000.
Times(Session).FixationBlockBlank = 1.000; % Time of blank screen within each cross-
                                  % fixation block (at the end of the block).
                                  % Standard is 15.000.
Times(Session).Blank = 0.300; % Time of blank screen within each trial. Standard is 0.300.
Times(Session).Mask = 0.100; % Time of mask screen within each trial. Standard is 0.100.
Times(Session).Feedback = 1.000;

Times(Session).SOAs = [ 340 300 260 240 220 200 180 160 140 120 100 80 60 40 ]; % SOA (Stimulus-to-mask Onset Asynchrony) within each trial. Standard is 0.220.
Times(Session).Target = str2double(char(inputs1(5)))/1000; % Standard is 0.010.

%% Set up the experiment. DO NOT change this section!

% Applying the gamma correction to the colors and saving the new values.
Parameters(Session).BackgroundColor = ((Parameters(Session).BackgroundColor/255)^(1/Parameters(Session).GammaCorrection))*255;
Parameters(Session).StimuliColor = ((Parameters(Session).StimuliColor/255)^(1/Parameters(Session).GammaCorrection))*255;
Parameters(Session).TextColor = ((Parameters(Session).TextColor/255)^(1/Parameters(Session).GammaCorrection))*255;

% Creating the error sound as a vector in time.
clearvars pahandle;
InitializePsychSound;
Parameters(Session).SampleRate = 44100; %Snd('DefaultRate'); %44100;
Parameters(Session).BeepVec = Parameters(Session).BeepVolume*sin(2*pi*Parameters(Session).BeepFrequency*(1:Parameters(Session).SampleRate*Parameters(Session).BeepDuration)/Parameters(Session).SampleRate);
Parameters(Session).BeepVec = [Parameters(Session).BeepVec(:);zeros(length(Parameters(Session).BeepVec),1);Parameters(Session).BeepVec(:)];
pahandle = PsychPortAudio('Open');
bufferhandle = PsychPortAudio('CreateBuffer' ,pahandle, [Parameters(Session).BeepVec';Parameters(Session).BeepVec']);
PsychPortAudio('UseSchedule', pahandle, 1);
PsychPortAudio('AddToSchedule', pahandle, bufferhandle);
PsychPortAudio('Start', pahandle);
status = PsychPortAudio('GetStatus', pahandle);
while status.State
    status = PsychPortAudio('GetStatus', pahandle);
end
PsychPortAudio('UseSchedule', pahandle, 2);
PsychPortAudio('AddToSchedule', pahandle, bufferhandle);

% Screen setup
close all;
clear screen;
whichScreen = max(Screen('Screens'));
Parameters(Session).W = [];
Parameters(Session).H = [];
Parameters(Session).Hz = [];
if ~isempty(char(inputs2(4)))
    Parameters(Session).W = str2double(char(inputs2(4))); % screen width
end
if ~isempty(char(inputs2(5)))
    Parameters(Session).H = str2double(char(inputs2(5))); % screen height
end
if ~isempty(char(inputs2(6)))
    Parameters(Session).Hz = str2double(char(inputs2(6)));
end
oldResolution = Screen('Resolution', whichScreen, Parameters(Session).W, Parameters(Session).H, Parameters(Session).Hz);
Resolution = Screen('Resolution', whichScreen);
[window1, ~] = Screen('Openwindow',whichScreen,Parameters(Session).BackgroundColor,[],[],2);
Parameters(Session).W = Resolution.width; % screen width
Parameters(Session).H = Resolution.height; % screen height
Parameters(Session).Hz = Resolution.hz;

% Display blank screen:
Screen(window1,'FillRect',Parameters(Session).BackgroundColor);
Screen('Flip', window1);
% Parameters for the stimuli images creation:
Parameters(Session).m = round(Parameters(Session).a*Parameters(Session).H/Parameters(Session).VL);
Parameters(Session).n = Parameters(Session).m;
% More timing parameters (non-changable):
Times(Session).slack = Screen('GetFlipInterval', window1)/2;

% Set up keyboard for receiving data:
ListenChar(0);
KbQueueCreate;
KbQueueStart;

% Prepare the textures for the fixations:
Circle_Image = TDT_Circle(Parameters(Session));
CircleDisplay = Screen('MakeTexture', window1, Circle_Image);
Cross_Image = TDT_Cross(Parameters(Session));
CrossDisplay = Screen('MakeTexture', window1, Cross_Image);

% Prepare the Output matrices:
Output(Session).Responses = char(84*ones(2,length(Times(Session).SOAs)));
Output(Session).Responses(2,:) = '-';
Output(Session).ResponseTimes = zeros(2,length(Times(Session).SOAs));
Output(Session).Displays = 84*ones(2,length(Times(Session).SOAs));
Output(Session).Displays(2,:) = 45;
Output(Session).SOAs = zeros(1,length(Times(Session).SOAs));

%% Run experiment.  DO NOT change this section!

% Screen priority
Priority(MaxPriority(window1));
Priority(2);

% Wait screen
HideCursor(whichScreen);
itime = GetSecs;

if strcmp(Parameters(Session).ResponseDevice,'Mouse')
    text = 'Press the mouse to begin';
else
    text = 'Press the space bar to begin';
end
Screen('DrawText',window1,text, (Parameters(Session).W/2)-200, (Parameters(Session).H/2), Parameters(Session).TextColor, Parameters(Session).BackgroundColor);
Screen('Flip',window1);

if strcmp(Parameters(Session).ResponseDevice,'Mouse')
    % Wait for subject to press the mouse
    buttons = [0 0 0];
    while ~any(buttons)
        [~,~,buttons] = GetMouse;
        [~,~,keyCode] = KbCheck;
        if keyCode(27)
            close all;
            PsychPortAudio('Close' ,pahandle);
            clearvars pahandle;
            Screen(window1,'Close');
            sca;
            Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz);
            KbQueueStop;
            return
        end
    end
    while any(buttons)
        [~,~,buttons] = GetMouse;
    end
else
    % Wait for subject to press spacebar:
    while 1
        [~,~,keyCode] = KbCheck;
        if keyCode(32)
            break
        elseif keyCode(27)
            close all;
            PsychPortAudio('Close' ,pahandle);
            clearvars pahandle;
            Screen(window1,'Close');
            sca;
            Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz);
            KbQueueStop;
            return
        end
    end
end
        
   
Screen('DrawTexture', window1, CrossDisplay);
flipTime = Screen('Flip', window1);

order = zeros(length(Times(Session).SOAs),1);
order(round(length(Times(Session).SOAs)/2)+1:end) = 1;
order = order(randperm(length(Times(Session).SOAs)));
Output(Session).Displays(1,~order) = 76;
order = order(randperm(length(Times(Session).SOAs)));    
Output(Session).Displays(2,~order) = 124;
Output(Session).SOAs = Times(Session).SOAs(randperm(length(Times(Session).SOAs)));
imageDisplay = zeros(length(Times(Session).SOAs),2);

% Run experimental trials
for t = 1:length(Times(Session).SOAs)

    % Load images into texture array

    img1 = TDT_Target(Parameters(Session),Output(Session).Displays(1,t),Output(Session).Displays(2,t));
    img2 = TDT_Mask(Parameters(Session));
    imageDisplay(t,1) = Screen('MakeTexture', window1, img1);
    imageDisplay(t,2) = Screen('MakeTexture', window1, img2);

end

% Display blank screen at the end of the cross-fixation block:
Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
flipTime = Screen('Flip', window1, flipTime + Times(Session).FirstFixation - Times(Session).FixationBlockBlank - Times(Session).slack);

% A loop for each trial:
for t = 1:length(Times(Session).SOAs)

    % Show fixation
    Screen('DrawTexture', window1, CircleDisplay);
    if (t ~= 1)
        Screen('Flip', window1);
    else
        Screen('Flip', window1, flipTime + Times(Session).FixationBlockBlank - Times(Session).slack);
    end

    if strcmp(Parameters(Session).ResponseDevice,'Mouse')
        % Wait for subject to press the mouse wheel
        buttons = [0 0 0];
        while ~buttons(2)
            [~,~,buttons] = GetMouse;
        end
        while any(buttons)
            [~,~,buttons] = GetMouse;
        end
    else
        KbQueueFlush([],2);
        % Wait for subject to press spacebar:
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(32)
                break
            end
        end
    end

    % Blank screen
    Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
    flipTime = Screen('Flip', window1);

    % Show the Target
    Screen('DrawTexture', window1, imageDisplay(t,1));
    flipTime = Screen('Flip', window1, flipTime + Times(Session).Blank - Times(Session).slack);

    % Show blank screen SOA
    Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
    flipTime = Screen('Flip', window1, flipTime + Times(Session).Target - Times(Session).slack);

    % Show the mask
    Screen('DrawTexture', window1, imageDisplay(t,2));
    flipTime = Screen('Flip', window1, flipTime + Output(Session).SOAs(t)/1000 - Times(Session).Target - Times(Session).slack);

    % Show blank screen
    Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
    flipTime = Screen('Flip', window1, flipTime + Times(Session).Mask - Times(Session).slack);

    % Get responses
    if strcmp(Parameters(Session).ResponseDevice,'Mouse')
        buttons1 = [0 0 0];
        nonemouse = 0;
        while ~buttons1(1) && ~buttons1(3)
            [~,~,buttons1] = GetMouse;
        end
        if buttons1(3)
            Output(Session).Responses(1,t) ='L';
        end
        if Output(Session).Responses(1,t)~=Output(Session).Displays(1,t)
            PsychPortAudio('Stop', pahandle);
            PsychPortAudio('UseSchedule', pahandle, 3);
            PsychPortAudio('Start', pahandle);
        end
        Output(Session).ResponseTimes(1,t) = GetSecs - flipTime;
        buttons2 = buttons1;
        while (~nonemouse && buttons1(1)==buttons2(1) && buttons1(3)==buttons2(3)) || (nonemouse && ~buttons2(1) && ~buttons2(3))
            [~,~,buttons2] = GetMouse;
            if ~any(buttons2)
                nonemouse = 1;
            end
        end
        Output(Session).ResponseTimes(2,t) = GetSecs - flipTime;
        if buttons2(3) && (~buttons1(3) ||  ~buttons2(1))
            Output(Session).Responses(2,t) ='|';
        end
        while any(buttons2)
            [~,~,buttons2] = GetMouse;
        end
    else
        i = 1;
        KbQueueFlush([],2);
        while i<3
            [event, ~] = PsychHID('KbQueueGetEvent');
            if ~isempty(event) && ~event.Pressed && ismember(event.Keycode,[Parameters(Session).L_Ver,Parameters(Session).T_Hor])
                if ismember(event.Keycode,Parameters(Session).L_Ver)
                    if i==1
                        Output(Session).Responses(i,t) ='L';
                    else
                        Output(Session).Responses(i,t) ='|';
                    end
                end
                if i==1 && (Output(Session).Responses(1,t)~=Output(Session).Displays(1,t))
                    PsychPortAudio('Stop', pahandle);
                    PsychPortAudio('UseSchedule', pahandle, 3);
                    PsychPortAudio('Start', pahandle);
                end
                Output(Session).ResponseTimes(i,t) = event.Time - flipTime;
                i = i+1;
            end
        end
    end
    pause(1);

end    

Screen('DrawTexture', window1, CrossDisplay);
flipTime = Screen('Flip', window1);

Output(Session).Successes = char(Output(Session).Responses)==char(Output(Session).Displays);
Output(Session).SortedSuccesses = Output(Session).Successes;
[~,temp] = sort(Output(Session).SOAs,'descend');
Output(Session).SortedSuccesses(1,:) = Output(Session).Successes(1,temp);
Output(Session).SortedSuccesses(2,:) = Output(Session).Successes(2,temp);
text = 'Pre-Training finished, please call the instructor';
Screen('DrawText',window1,text, (Parameters(Session).W/2)-350, (Parameters(Session).H/2), Parameters(Session).TextColor, Parameters(Session).BackgroundColor);
Screen('Flip', window1, flipTime + Times(Session).FinalFixation - Times(Session).slack);

KbQueueFlush([],2);
% Wait for subject to press esc:
while 1
    [~,~,keyCode] = KbCheck;
    if keyCode(27)
        break
    end
end
    
%% End the Try. DO NOT change this section!
    
% Convert output matrices to 'char'. for the fixations the options are 'T'
% or 'L'. For the alignments the options are '-' for horizontal and '|' for
% vertical.
% Both matrices are 3-dimensional: each 3-dimension page is for a try,
% each column in a page is for a trial, the first row is for fixations
% and the second row is for alignments.

Output(Session).Responses = char(Output(Session).Responses);
Output(Session).Displays = char(Output(Session).Displays);
Output(Session).Successes = Output(Session).Responses==Output(Session).Displays;
Output(Session).SortedSuccesses = Output(Session).Successes;
[~,temp] = sort(Output(Session).SOAs,2,'descend');

Output(Session).SortedSuccesses(1,:) = Output(Session).Successes(1,temp);
Output(Session).SortedSuccesses(2,:) = Output(Session).Successes(2,temp);
Output(Session).SOASuccess = Output(Session).SortedSuccesses';

%% End the Training. DO NOT change this section!

% Total runtime of the training:
Output(Session).TotalTrainingTime = GetSecs - itime; 
Output(Session).TotalTrainingTime = [num2str(floor(Output(Session).TotalTrainingTime/60)),':',num2str(rem(Output(Session).TotalTrainingTime,60))]; % Total time of the training.
% The date and time of the experiment:
Output(Session).ExperimentDateTime = datestr(clock);

% Finish the training:
close all;
PsychPortAudio('Close' ,pahandle);
clearvars pahandle;
Screen(window1,'Close');
sca;
Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz);
KbQueueStop;

save(filename, 'SubjectName', 'Parameters', 'Times', 'Output');
save(['Z:\Yehuda\Backups\',filename,datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'Parameters', 'Times', 'Output');

end
