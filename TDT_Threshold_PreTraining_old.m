function TDT_Threshold_PreTraining_old

%% TDT Threshold Finding training.
%
% No variables are saved in the workspace, only to file.
% syntax: "TDT_Threshold_Training;".

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
    prompt1 = {'Target Display Time (ms):','Orientation'};
    defaultans1 = {'10',''};
else
    ResponseDevice = 'Keyboard';
    prompt1 = {'Target Display Time (ms):','Orientation','T/row keys:','L/column keys:'};
    defaultans1 = {'10','','2','3'};
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
    if isnan(str2double(char(inputs1(1))))
        h = warndlg('Target display time (in miliseconds) must be a number!');
        uiwait(h);
        begin = 0;
    end
    if ~strcmpi(char(inputs1(2)),'-') && ~strcmpi(char(inputs1(2)),'|')
        h = warndlg('Orientation must be either "-" or "|"!');
        uiwait(h);
        begin = 0;
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
%Non-time parameters:
Parameters.VL = str2double(char(inputs2(1))); % Number of lines in each column. Standard is 19.
Parameters.HL = str2double(char(inputs2(2))); % Number of lines in each row. Standard is 19.
Parameters.BackgroundColor = 1; % Color of background. Standard is 1.
Parameters.StimuliColor = 255; % Color of lines and letters in stimuli. Standard is 255.
Parameters.TextColor = 255; % Color of written text. Standard is 255.
Parameters.MaskColor = 200; % Color of mask. Standard is 200.
Parameters.GammaCorrection = 3.2547; % Gamma correction value for the colors.
                                     % Value according to measurements on
                                     % CRT screen at the lab in 03/04/2016.
Parameters.CircleRadius = 9; % The fixation circle radius in pixels. Standard is 9.
Parameters.CircleWidth = 1; % The fixation circle width in pixels. Standard is 1.
Parameters.CrossWidth = 2; % The fixation cross width in pixels. Standard is 2.
Parameters.CrossLength = 30; % The fixation cross length in pixels. Standard is 30.
Parameters.Hjitter = 2; % The horizontal jitter effect- maximum number of pixels each
% line is allowed to shift from its original location. Standard is 2.
Parameters.Vjitter = 2; % The vertical jitter effect. Standard is 2.
Parameters.LineLength = 28; % The length of each background line in pixels. Standard is 28.
Parameters.LineWidth = 2; % The width of each background line in pixels. Standard is 2.
Parameters.LetterLength = 8; % The length of each center letter line in pixels. Standard is 8.
Parameters.LetterWidth = 2; % The width of each center letter line in pixels. Standard is 2.
Parameters.TargetLength = 28; % The length of each target line in pixels. Standard is 28.
Parameters.TargetWidth = 2; % The width of each target line in pixels. Standard is 2.
Parameters.a = str2double(char(inputs2(3))); % Relative size of screen on which to display images.
Parameters.BeepFrequency = 400; % Frequency of error sound in [Hz]. Standard is 400.
Parameters.BeepDuration = 0.08; % Duration of error sound in seconds. Standard is 0.08.
Parameters.BeepVolume = 0.4; % Volume of error sound. Standard is 0.4.

if strcmp(ResponseDevice,'Keyboard')
    Parameters.T_Hor = char(inputs1(3)); % Keys for identifying 'T' for fixation and horizontal for alignment.
    Parameters.L_Ver = char(inputs1(4)); % Keys for identifying 'L' for fixation and vertical for alignment.
end
Parameters.Orientation = char(inputs1(2));

%Times/Durations:
Times.FirstFixation = 3.000; % Time of pre-experiment (dummy) cross-fixation
% block. Standard is 3.000.
Times.FinalFixation = 3.000; % Time of post-experiment (rest) cross-fixation
% block. Standard is 3.000.
Times.FixationBlockBlank = 1.000; % Time of blank screen within each cross-
% fixation block (at the end of the block).
% Standard is 15.000.
Times.Blank = 0.300; % Time of blank screen within each trial. Standard is 0.300.
Times.Mask = 0.100; % Time of mask screen within each trial. Standard is 0.100.
Times.Feedback = 1.000;

Times.SOAs = [ 340 300 260 240 220 200 180 160 140 120 100 80 60 40 ]; % SOA (Stimulus-to-mask Onset Asynchrony) within each trial. Standard is 0.220.
Times.Target = str2double(char(inputs1(1)))/1000; % Standard is 0.010.

%% Set up the experiment. DO NOT change this section!

% Applying the gamma correction to the colors and saving the new values.
Parameters.BackgroundColor = ((Parameters.BackgroundColor/255)^(1/Parameters.GammaCorrection))*255;
Parameters.StimuliColor = ((Parameters.StimuliColor/255)^(1/Parameters.GammaCorrection))*255;
Parameters.TextColor = ((Parameters.TextColor/255)^(1/Parameters.GammaCorrection))*255;

% Creating the error sound as a vector in time.
clearvars pahandle;
InitializePsychSound;
Parameters.SampleRate = 44100; %Snd('DefaultRate'); %44100;
Parameters.BeepVec = Parameters.BeepVolume*sin(2*pi*Parameters.BeepFrequency*(1:Parameters.SampleRate*Parameters.BeepDuration)/Parameters.SampleRate);
Parameters.BeepVec = [Parameters.BeepVec(:);zeros(length(Parameters.BeepVec),1);Parameters.BeepVec(:)];
pahandle = PsychPortAudio('Open');
bufferhandle = PsychPortAudio('CreateBuffer' ,pahandle, [Parameters.BeepVec';Parameters.BeepVec']);
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
Parameters.W = [];
Parameters.H = [];
Parameters.Hz = [];
if ~isempty(char(inputs2(4)))
    Parameters.W = str2double(char(inputs2(4))); % screen width
end
if ~isempty(char(inputs2(5)))
    Parameters.H = str2double(char(inputs2(5))); % screen height
end
if ~isempty(char(inputs2(6)))
    Parameters.Hz = str2double(char(inputs2(6)));
end
oldResolution = Screen('Resolution', whichScreen, Parameters.W, Parameters.H, Parameters.Hz);
Resolution = Screen('Resolution', whichScreen);
[window1, ~] = Screen('Openwindow',whichScreen,Parameters.BackgroundColor,[],[],2);
Parameters.W = Resolution.width; % screen width
Parameters.H = Resolution.height; % screen height
Parameters.Hz = Resolution.hz;

% Display blank screen:
Screen(window1,'FillRect',Parameters.BackgroundColor);
Screen('Flip', window1);
% Parameters for the stimuli images creation:
Parameters.m = round(Parameters.a*Parameters.H/Parameters.VL);
Parameters.n = Parameters.m;
% More timing parameters (non-changable):
Times.slack = Screen('GetFlipInterval', window1)/2;

% Set up keyboard for receiving data:
ListenChar(0);
KbQueueCreate;
KbQueueStart;

% Prepare the textures for the fixations:
Circle_Image = TDT_Circle(Parameters);
CircleDisplay = Screen('MakeTexture', window1, Circle_Image);
Cross_Image = TDT_Cross(Parameters);
CrossDisplay = Screen('MakeTexture', window1, Cross_Image);

%% Run experiment.  DO NOT change this section!

% Screen priority
Priority(MaxPriority(window1));
Priority(2);

% Wait screen
HideCursor(whichScreen);

if strcmp(ResponseDevice,'Mouse')
    text = 'Press the mouse to begin';
else
    text = 'Press the space bar to begin';
end
Screen('DrawText',window1,text, (Parameters.W/2)-200, (Parameters.H/2), Parameters.TextColor, Parameters.BackgroundColor);
Screen('Flip',window1);

if strcmp(ResponseDevice,'Mouse')
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

Displays = 84*ones(2,length(Times.SOAs));
Displays(2,:) = 45;
order = zeros(length(Times.SOAs),1);
order(round(length(Times.SOAs)/2)+1:end) = 1;
order = order(randperm(length(Times.SOAs)));
Displays(1,~order) = 76;
order = order(randperm(length(Times.SOAs)));
Displays(2,~order) = 124;
SOAs = Times.SOAs(randperm(length(Times.SOAs)));
imageDisplay = zeros(length(Times.SOAs),2);

% Run experimental trials
for t = 1:length(SOAs)
    
    % Load images into texture array
    
    img1 = TDT_Target(Parameters,Displays(1,t),Displays(2,t));
    img2 = TDT_Mask(Parameters);
    imageDisplay(t,1) = Screen('MakeTexture', window1, img1);
    imageDisplay(t,2) = Screen('MakeTexture', window1, img2);
    
end

% Display blank screen at the end of the cross-fixation block:
Screen(window1, 'FillRect', Parameters.BackgroundColor);
flipTime = Screen('Flip', window1, flipTime + Times.FirstFixation - Times.FixationBlockBlank - Times.slack);

% A loop for each trial:
for t = 1:length(SOAs)
    
    % Show fixation
    Screen('DrawTexture', window1, CircleDisplay);
    if (t ~= 1)
        Screen('Flip', window1);
    else
        Screen('Flip', window1, flipTime + Times.FixationBlockBlank - Times.slack);
    end
    
    if strcmp(ResponseDevice,'Mouse')
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
    Screen(window1, 'FillRect', Parameters.BackgroundColor);
    flipTime = Screen('Flip', window1);
    
    % Show the Target
    Screen('DrawTexture', window1, imageDisplay(t,1));
    flipTime = Screen('Flip', window1, flipTime + Times.Blank - Times.slack);
    
    % Show blank screen SOA
    Screen(window1, 'FillRect', Parameters.BackgroundColor);
    flipTime = Screen('Flip', window1, flipTime + Times.Target - Times.slack);
    
    % Show the mask
    Screen('DrawTexture', window1, imageDisplay(t,2));
    flipTime = Screen('Flip', window1, flipTime + SOAs(t)/1000 - Times.Target - Times.slack);
    
    % Show blank screen
    Screen(window1, 'FillRect', Parameters.BackgroundColor);
    flipTime = Screen('Flip', window1, flipTime + Times.Mask - Times.slack);
    
    % Get responses
    if strcmp(ResponseDevice,'Mouse')
        buttons1 = [0 0 0];
        nonemouse = 0;
        while ~buttons1(1) && ~buttons1(3)
            [~,~,buttons1] = GetMouse;
        end
        if buttons1(3)
            Response = 'L';
        else
            Response = 'T';
        end
        if Response~=Displays(1,t)
            PsychPortAudio('Stop', pahandle);
            PsychPortAudio('UseSchedule', pahandle, 3);
            PsychPortAudio('Start', pahandle);
        end
        buttons2 = buttons1;
        while (~nonemouse && buttons1(1)==buttons2(1) && buttons1(3)==buttons2(3)) || (nonemouse && ~buttons2(1) && ~buttons2(3))
            [~,~,buttons2] = GetMouse;
            if ~any(buttons2)
                nonemouse = 1;
            end
        end
        while any(buttons2)
            [~,~,buttons2] = GetMouse;
        end
    else
        Response = 'T';
        i = 1;
        KbQueueFlush([],2);
        while i<3
            [event, ~] = PsychHID('KbQueueGetEvent');
            if ~isempty(event) && ~event.Pressed && ismember(event.Keycode,[Parameters.L_Ver,Parameters.T_Hor])
                if ismember(event.Keycode,Parameters.L_Ver)
                    if i==1
                        Response = 'L';
                    end
                end
                if i==1 && (Response~=Displays(1,t))
                    PsychPortAudio('Stop', pahandle);
                    PsychPortAudio('UseSchedule', pahandle, 3);
                    PsychPortAudio('Start', pahandle);
                end
                i = i+1;
            end
        end
    end
    pause(1);
    
end

Screen('DrawTexture', window1, CrossDisplay);
flipTime = Screen('Flip', window1);

text = 'Pre-Training finished, please call the instructor';
Screen('DrawText',window1,text, (Parameters.W/2)-350, (Parameters.H/2), Parameters.TextColor, Parameters.BackgroundColor);
Screen('Flip', window1, flipTime + Times.FinalFixation - Times.slack);

KbQueueFlush([],2);
% Wait for subject to press esc:
while 1
    [~,~,keyCode] = KbCheck;
    if keyCode(27)
        break
    end
end

%% End the Training. DO NOT change this section!

% Finish the training:
close all;
PsychPortAudio('Close' ,pahandle);
clearvars pahandle;
Screen(window1,'Close');
sca;
Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz);
KbQueueStop;

end
