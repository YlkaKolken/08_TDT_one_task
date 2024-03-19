function TDT_Threshold_Training

%% TDT Threshold training.

% This is the threshold training session for the TDT experiment. This
% function should be used both for the pre-training and for each session.
% In each block the subject performs each SOA a given number of times
% (nTrials) in a random order. There are 14 SOA times as a default.
% The required syntax is: "TDT_Threshold_Training;", or through "TDT;".

%% Get parameters through GUI.

Screens = [{'ViewSonic PF817 Serial Number: QY01400013'};{'ViewSonic PF817 Serial Number: QY01400084'};{'HP P1230 Serial Number: CNV4300070'}];
Gamma = [2.8252,3.4603,2.2437];
Brightness = [33,24,30];
Dates = ['18/09/2016';'07/07/2016';'03/04/2016'];
% Gamma correction value for the colors, and brightness of the screen.
% Values are according to measurements on the dates in the Dates vector.
% The CRT screens are in the following order:
% [TMS room, TDT room,  Old CRT screen]
                                              
% Default values for the GUI screen:

choice.SubjectName = ''; % Subject name or number.
choice.Session = 1; % The session number.

% Parameters not used in the function, only saved for analysis:
choice.Day = 1; % The day number.
choice.Group = ''; % The group number.
choice.Sleep = ''; % Hours of sleep.
choice.Age = ''; % The age of the subject.
choice.Gender = 'Female'; % Gender of the subject.
choice.GenderNumber = 1;

choice.nTrials = 1; % Number of trials for each SOA.
choice.nBlocks = 1; % Number of blocks in the session.
choice.TargetTime = 10; % Target display time in milliseconds. 

% Keyboard keys for response:
choice.TRKeys = ''; % 'T' for fixation and row for alignment.
choice.LCKeys = ''; % 'L' for fixation and column for alignment.

choice.Device = 'Mouse'; % Responce device, could be either 'Mouse' or 'Keyboard'.
choice.DeviceNumber = 1;
choice.Screen = 'TMS Room'; % Screen used, could be either 'TMS Room', 'TDT Room' or 'Old HP'.
choice.ScreenNumber = 1;
choice.ReTraining = 0;
% Number of columns and rows of lines in the backround of the stimuli:
choice.VerticalLines = 19;
choice.HorizontalLines = 19;

choice.RelativeSize = 0.93; % Relative size of the screen on which the stimuli are presented.
% Screen width and hight in pixels and refresh rate in Hz:
choice.ScreenWidth = 1152;
choice.ScreenHeight = 864;
choice.RefreshRate = 100;

choice.Orientation = '-'; % The orientation of the backround lines in the target stimuli, could be either '-' or '|'.
choice.OrientationNumber = 1;

% Position of the target relative to the center of the screen. The offset
% is positive to the right and down, and negative to the left and up. The
% absolute values must be larger than 1 to not hide the center fixation
% letter and small enough to not exit the screen:
choice.TargetHorizontalOffset = 5;
choice.TargetVerticalOffset = 5;

choice.Answer = 1; % A value to control when to exit the GUI.
choice.Load = 0; % A value to control the loading of a previous file.

% "Endless" loop for getting values from the GUI. The loop ends when all
% values are legal and no errors found:
while 1
    choice = choosedialog(choice); % Calling the subfunction defining the GUI.
    if ~choice.Answer
        return
    end
    
    % When clicking the load button, this section checks if a file of the
    % required name is present, and if so, whether a previous session of
    % initial training is present in the file or not. If all is present the
    % data is loaded, otherwise a warning appears:
    if choice.Load
        filename = ['TDT_Subject_',choice.SubjectName,'_Results.mat'];
        if ~isempty(dir(filename))
            load(filename);
            W = whos(matfile(filename));
            Continue = 0;
            for i = 1:length(W)
                if strcmp(W(i).name,'ThresholdTraining')
                    Continue = 1;
                    break
                end
            end
            if Continue
                if isfield(ThresholdTraining,'Parameters')
                    Parameters = ThresholdTraining.Parameters;
                    Session = length(Parameters); 
                    choice = ThresholdTraining.choose(Session); %#ok<*NODEF>
                    choice.Session = Session+1;
                    if choice.Session==2
                        choice.nTrials = 2;
                        choice.nBlocks = 9;
                        choice.ReTraining = 1;
                    else
                        choice.ReTraining = 0;
                    end
                end
                if isfield(ThresholdTraining,'Times')
                    Times = ThresholdTraining.Times;
                end
                if isfield(ThresholdTraining,'Output')
                    Output = ThresholdTraining.Output;
                end
            else
                h = warndlg(['Threshold Training for Subject ',choice.SubjectName,' does not exist']);
                uiwait(h);
            end
        else
            h = warndlg(['Subject ',choice.SubjectName,' does not exist']);
            uiwait(h);
        end
        choice.Load = 0;
        continue
    end
    
    % Checking legality of all the rest of the parameters:
    if isempty(choice.SubjectName)
        h = warndlg('You must enter a subject name/number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.Session)) || isnan(str2double(num2str(choice.Session)))
        h = warndlg('The Session must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.Day)) || isnan(str2double(num2str(choice.Day)))
        h = warndlg('The Day must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.Group)) || isnan(str2double(num2str(choice.Group)))
        h = warndlg('The Group must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.nTrials)) || isnan(str2double(num2str(choice.nTrials)))
        h = warndlg('Number of trials must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.nBlocks)) || isnan(str2double(num2str(choice.nBlocks)))
        h = warndlg('Number of blocks must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.TargetTime)) || isnan(str2double(num2str(choice.TargetTime)))
        h = warndlg('Target time (in milliseconds) must be a number!');
        uiwait(h);
        continue
    end
    if choice.TargetTime>40
        h = warndlg('Target time is more than the shortest SOA time!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.Age)) || isnan(str2double(num2str(choice.Age)))
        h = warndlg('Age must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.Sleep)) || isnan(str2double(num2str(choice.Sleep)))
        h = warndlg('You must enter sleep hours!');
        uiwait(h);
        continue
    end
    if choice.DeviceNumber==2 && (isempty(num2str(choice.TRKeys)) || isempty(num2str(choice.LCKeys)))
        h = warndlg('You must enter keyboard response keys when using the keyboard!');
        uiwait(h);
        continue
    end
    if choice.DeviceNumber==2
        choice.TRKeys = num2str(choice.TRKeys);
        choice.LCKeys = num2str(choice.LCKeys);
        if any(ismember(choice.LCKeys,choice.TRKeys))
            h = warndlg('All T/Row keys must be different than the L/Column keys!');
            uiwait(h);
            continue
        end
    end
    if isempty(num2str(choice.VerticalLines)) || isnan(str2double(num2str(choice.VerticalLines)))
        h = warndlg('The number of vertical lines must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.HorizontalLines)) || isnan(str2double(num2str(choice.HorizontalLines)))
        h = warndlg('The number of horizontal lines must be a number!');
        uiwait(h);
        continue
    end
    if isempty(num2str(choice.RelativeSize)) || isnan(str2double(num2str(choice.RelativeSize))) || choice.RelativeSize<0 || choice.RelativeSize>1
        h = warndlg('Relative size of screen must be a number between 0 ans 1!');
        uiwait(h);
        continue
    end
    if isempty(choice.ScreenWidth) || isnan(str2double(num2str(choice.ScreenWidth)))
        h = warndlg('The screen width (in pixels) must be a number!');
        uiwait(h);
        continue
    end
    if isempty(choice.ScreenHeight) || isnan(str2double(num2str(choice.ScreenHeight)))
        h = warndlg('The screen height (in pixels) must be a number!');
        uiwait(h);
        continue
    end
    if isempty(choice.RefreshRate) || isnan(str2double(num2str(choice.RefreshRate)))
        h = warndlg('The screen refresh rate (in Hertz) must be a number!');
        uiwait(h);
        continue
    end
    if isempty(choice.TargetHorizontalOffset) || isnan(str2double(num2str(choice.TargetHorizontalOffset)))...
        || ~ismember(abs(choice.TargetHorizontalOffset),2:(choice.HorizontalLines-1)/2-1)
        h = warndlg(['The target horizontal offset must be a whole number between 2 and ',num2str((choice.HorizontalLines-1)/2-1),'!',]);
        uiwait(h);
        continue
    end
    if isempty(choice.TargetVerticalOffset) || isnan(str2double(num2str(choice.TargetVerticalOffset)))...
        || ~ismember(abs(choice.TargetVerticalOffset),2:(choice.VerticalLines-1)/2-1)
        h = warndlg(['The target vertical offset must be a whole number between 2 and ',num2str((choice.HorizontalLines-1)/2-1),'!']);
        uiwait(h);
        continue
    end
        
    % Checking if a file for the subject already exists. If so, the old
    % data is loaded to be saved as a new session. If the wanted session
    % already exists, a warning is presented before overwriting.
    filename = ['TDT_Subject_',choice.SubjectName,'_Results.mat'];
    if ~isempty(dir(filename))
        load(filename);
        W = whos(matfile(filename));
        Continue = 0;
        for i = 1:length(W)
            if strcmp(W(i).name,'ThresholdTraining')
                Continue = 1;
                break
            end
        end
        if Continue && isfield(ThresholdTraining,'Parameters') && length(ThresholdTraining.Parameters)>=choice.Session
            question1 = questdlg(['TDT Threshold Training results for subject "',choice.SubjectName,...
                                  '", Session ',num2str(choice.Session),', already exist and will be',...
                                  'overwritten, continue?'],'!!WARNING!!','Yes','No','No');
            if strcmp(question1,'No')
                continue
            else
                if isfield(ThresholdTraining,'Times')
                    Times = ThresholdTraining.Times(1:choice.Session-1);
                end
                if isfield(ThresholdTraining,'Output')
                    Output = ThresholdTraining.Output(1:choice.Session-1);
                end
                if isfield(ThresholdTraining,'Parameters')
                    Parameters = ThresholdTraining.Parameters(1:choice.Session-1);
                end
            end
        end
    end
    
    break % Exit the endless loop.
    
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

% Presenting a warning reminding to check the screen chosen is the correct
% one and that the brightness matches the value:
h = warndlg(['The screen chosen is: ',Screens{choice.ScreenNumber},'. Make sure this is correct. The gamma correction value for this screen is: ',...
             num2str(Gamma(choice.ScreenNumber)),'. Please make sure the brightness is ',num2str(Brightness(choice.ScreenNumber)),...
             '%! These values are updated to: ',Dates(choice.ScreenNumber,:),'.'],'Screen Choosing');
uiwait(h);


%% Parameter tuning. Values in this section are changable.

% Changable parameters for the experiment. change only when absolutely sure
% about the change. The default values are updated to 9/10/2016.

Session = choice.Session;
ThresholdTraining.choose(Session) = choice; % Saving the GUI parameters.
SubjectName = choice.SubjectName; %#ok<*NASGU>

% Visual parameters:
% Parameters from GUI:
Parameters(Session).GammaCorrection = Gamma(choice.ScreenNumber);
Parameters(Session).VL = choice.VerticalLines;
Parameters(Session).HL = choice.HorizontalLines;
Parameters(Session).T_Hor = upper(choice.TRKeys);
Parameters(Session).L_Ver = upper(choice.LCKeys);
Parameters(Session).TargetOffset = [choice.TargetHorizontalOffset,choice.TargetVerticalOffset];
Parameters(Session).Orientation = choice.Orientation;
% Parameters not from GUI:
Parameters(Session).BackgroundColor = 1; % Color of background. Default is 1.
Parameters(Session).StimuliColor = 255; % Color of lines and letters in stimuli. Default is 255.
Parameters(Session).TextColor = 255; % Color of written text. Default is 255.
Parameters(Session).MaskColor = 200; % Color of mask. Default is 200.
Parameters(Session).CircleRadius = 9; % The fixation circle radius in pixels. Default is 9.
Parameters(Session).CircleWidth = 1; % The fixation circle width in pixels. Default is 1.
Parameters(Session).CrossWidth = 2; % The fixation cross width in pixels. Default is 2.
Parameters(Session).CrossLength = 30; % The fixation cross length in pixels. Default is 30.
Parameters(Session).Hjitter = 2; % The horizontal jitter effect- maximum number of pixels each 
                                 % line is allowed to shift from its original location. Default is 2.
Parameters(Session).Vjitter = 2; % The vertical jitter effect. Default is 2.
Parameters(Session).LineLength = 28; % The length of each background line in pixels. Default is 28.
Parameters(Session).LineWidth = 2; % The width of each background line in pixels. Default is 2.
Parameters(Session).LetterLength = 8; % The length of each center letter line in pixels. Default is 8.
Parameters(Session).LetterWidth = 2; % The width of each center letter line in pixels. Default is 2.
Parameters(Session).TargetLength = 28; % The length of each target line in pixels. Default is 28.
Parameters(Session).TargetWidth = 2; % The width of each target line in pixels. Default is 2.

% Sound parameters:
Parameters(Session).BeepFrequency = 400; % Frequency of error sound in [Hz]. Default is 400.
Parameters(Session).BeepDuration = 0.08; % Duration of error sound in seconds. Default is 0.08.
Parameters(Session).BeepVolume = 0.4; % Volume of error sound. Default is 0.4.
Parameters(Session).SampleRate = 44100; % Sound sample rate. Default is 44100;

% Timing parameters:
% Parameters from GUI:
Times(Session).Target = str2double(num2str(choice.TargetTime))/1000; % Target display time.
% Parameters not from GUI:
Times(Session).FirstFixation = 3; % Time of pre-experiment (dummy) cross-fixation block in seconds. Default is 3.
Times(Session).FinalFixation = 3; % Time of post-experiment (rest) cross-fixation block in seconds. Default is 3.
Times(Session).FixationBlockBlank = 1; % Time of blank screen within each cross-fixation block in seconds (at the end of the block). Default is 1.
Times(Session).Blank = 0.300; % Time of blank screen within each trial in seconds. Default is 0.300.
Times(Session).Mask = 0.100; % Time of mask screen within each trial in seconds. Default is 0.100.
Times(Session).SOAs = repmat([ 340 300 260 240 220 200 180 160 140 120 100 80 60 40 ],1,choice.nTrials); % SOA (Stimulus-to-mask Onset Asynchrony) times which will be used in each block.

%% Set up the experiment. DO NOT change this section!

% Parameters regarding the computer system:
Parameters(Session).System.Memory = memory;
Parameters(Session).System.Matlab = ver;
Parameters(Session).System.OS_Version = system_dependent('getwinsys');
Parameters(Session).System.OS = system_dependent('getos');

% Applying the gamma correction to the colors and saving the new values.
Parameters(Session).BackgroundColor = ((Parameters(Session).BackgroundColor/255)^(1/Parameters(Session).GammaCorrection))*255;
Parameters(Session).StimuliColor = ((Parameters(Session).StimuliColor/255)^(1/Parameters(Session).GammaCorrection))*255;
Parameters(Session).TextColor = ((Parameters(Session).TextColor/255)^(1/Parameters(Session).GammaCorrection))*255;
Parameters(Session).MaskColor = ((Parameters(Session).MaskColor/255)^(1/Parameters(Session).GammaCorrection))*255;


% Sound card regarding commands:
clearvars pahandle;
InitializePsychSound;
% Creating the error sound as a vector in time and ready to play:
Parameters(Session).BeepVec = Parameters(Session).BeepVolume*sin(2*pi*Parameters(Session).BeepFrequency*(1:Parameters(Session).SampleRate*Parameters(Session).BeepDuration)/Parameters(Session).SampleRate);
Parameters(Session).BeepVec = [Parameters(Session).BeepVec(:);zeros(length(Parameters(Session).BeepVec),1);Parameters(Session).BeepVec(:)];
pahandle = PsychPortAudio('Open');
bufferhandle = PsychPortAudio('CreateBuffer' ,pahandle, [Parameters(Session).BeepVec';Parameters(Session).BeepVec']);
PsychPortAudio('UseSchedule', pahandle, 1);
PsychPortAudio('AddToSchedule', pahandle, bufferhandle);
% Test the error sound once:
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

% Check for existence of backup folders. If none exist, a warning message
% appears before the experiment continues without backup saves:
if isempty(dir('C:\Backups'))
    question2 = questdlg(['Local backup folder "C:/Backups" not found and no local backups'...
                          ' will be saved, continue?'],'!!WARNING!!','Yes','No','No');
    if strcmp(question2,'No')
        return
    end
end
if isempty(dir('Z:\Yehuda\Backups'))
    question2 = questdlg(['Drive backup folder "Z:\Yehuda\Backups" not found and no drive backups'...
                          ' will be saved, continue?'],'!!WARNING!!','Yes','No','No');
    if strcmp(question2,'No')
        return
    end
end

% Setting the screen resolution and refresh rate according to GUI. If the
% values remain empty the screen stays as it is. If the values are not
% supported by the screen a warning appears and the screen stays as it is.
% The current values of the screen are saved and restored at the end of the
% experiment:
Parameters(Session).W = [];
Parameters(Session).H = [];
Parameters(Session).Hz = [];
if ~isempty(choice.ScreenWidth)
    Parameters(Session).W = str2double(num2str(choice.ScreenWidth)); % screen width
end
if ~isempty(choice.ScreenHeight)
    Parameters(Session).H = str2double(num2str(choice.ScreenHeight)); % screen height
end
if ~isempty(choice.RefreshRate)
    Parameters(Session).Hz = str2double(num2str(choice.RefreshRate)); % screen refresh rate
end
try
    oldResolution = Screen('Resolution', whichScreen, Parameters(Session).W, Parameters(Session).H, Parameters(Session).Hz);
catch
    question3 = questdlg('Screen Resolution and/or Refresh Rate requested is not supported by this screen, continue with current screen settings?','!!WARNING!!','Yes','No','No');
    if strcmp(question3,'No')
        return
    end
    oldResolution = Screen('Resolution', whichScreen);
end
Resolution = Screen('Resolution', whichScreen);
[window1, ~] = Screen('Openwindow',whichScreen,Parameters(Session).BackgroundColor,[],[],2); % Opening the onscreen window.
Parameters(Session).W = Resolution.width; % screen width
Parameters(Session).H = Resolution.height; % screen height
Parameters(Session).Hz = Resolution.hz;

% Parameters for the stimuli images creation:
Parameters(Session).m = round(choice.RelativeSize*Parameters(Session).H/choice.VerticalLines);
Parameters(Session).n = Parameters(Session).m; % Size of a single line image in pixels.
% Slack time (half the flip interval of the screen):
Times(Session).slack = Screen('GetFlipInterval', window1)/2;

% Display blank screen:
Screen(window1,'FillRect',Parameters(Session).BackgroundColor);
Screen('Flip', window1);
% Parameters for the stimuli images creation:

% Set up keyboard for receiving data:
ListenChar(0);
KbQueueCreate;
KbQueueStart;

% Prepare the textures for the cross and circle fixation screens:
Circle_Image = TDT_Circle(Parameters(Session));
CircleDisplay = Screen('MakeTexture', window1, Circle_Image);
Cross_Image = TDT_Cross(Parameters(Session));
CrossDisplay = Screen('MakeTexture', window1, Cross_Image);

% A parameter indicating whether the subject finished the training or the
% training was stopped by the experimenter:
Output(Session).Finished = 'No';

% Screen priority
Priority(MaxPriority(window1));
Priority(2);

HideCursor(whichScreen); % Hide the mouse cursor.
itime = GetSecs; % Time of the beginning of the training.

%% Run experiment.  DO NOT change this section!

% Welcome screen:
if choice.DeviceNumber==1
    text = 'Welcome to the experiment. Press the mouse to begin';
else
    text = 'Welcome to the experiment. Press the space bar to begin';
end
DrawFormattedText(window1,text, 'center', 'center', Parameters(Session).TextColor);
Screen('Flip',window1);

if choice.DeviceNumber==1
    % Wait for subject to press the mouse
    buttons = [0 0 0];
    while ~any(buttons)
        [~,~,buttons] = GetMouse;
        [~,~,keyCode] = KbCheck;
        if keyCode(27)
            % Exit the experiment when clicking the 'esc' key:
            close all;
            PsychPortAudio('Close' ,pahandle);
            clearvars pahandle;
            Screen(window1,'Close'); % Close the onscreen window.
            sca;
            Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz); % Restore screen original resolution and refresh rate.
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
            % Exit the experiment when clicking the 'esc' key:
            close all;
            PsychPortAudio('Close' ,pahandle);
            clearvars pahandle;
            Screen(window1,'Close'); % Close the onscreen window.
            sca;
            Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz); % Restore screen original resolution and refresh rate.
            KbQueueStop;
            return
        end
    end
end

b = 1; % The current block. This parameter changes throughout the session.
% A loop for each block:
while b < choice.nBlocks+1
   
    % Prepare the Output matrices with default values which will be
    % reordered randomally in each block:
    Output(Session).Displays(:,:,b) = 84*ones(2,length(Times(Session).SOAs));
    Output(Session).Displays(2,:,b) = 45;
    Output(Session).SOAs(b,:) = zeros(1,length(Times(Session).SOAs));
    % Prepare the Output matrices with default values which will change
    % according to the subject's responses:
    Output(Session).Responses(:,:,b) = char(84*ones(2,length(Times(Session).SOAs)));
    Output(Session).Responses(2,:,b) = '-';
    Output(Session).ResponseTimes(:,:,b) = zeros(2,length(Times(Session).SOAs));
    Output(Session).SOASuccess(:,:,b) = zeros(length(Times(Session).SOAs)/choice.nTrials,2);
        
    % Display the cross fixation:
    Screen('DrawTexture', window1, CrossDisplay);
    flipTime = Screen('Flip', window1);
 
    % randomizing the fixation, alignments and SOA's for the current block:
    order = zeros(length(Times(Session).SOAs),1);
    order(round(length(Times(Session).SOAs)/2)+1:end) = 1;
    order = order(randperm(length(Times(Session).SOAs)));
    Output(Session).Displays(1,~order,b) = 76;
    order = order(randperm(length(Times(Session).SOAs)));    
    Output(Session).Displays(2,~order,b) = 124;
    Output(Session).SOAs(b,:) = Times(Session).SOAs(randperm(length(Times(Session).SOAs)));
    % An array of textures to display:
    imageDisplay = zeros(length(Times(Session).SOAs),2);

    % Prepare the textures for the targets and masks for all the trials in
    % the current block:
    for t = 1:length(Times(Session).SOAs)

        % Load images into the texture array:
        img1 = TDT_Target(Parameters(Session),Output(Session).Displays(1,t,b),Output(Session).Displays(2,t,b));
        img2 = TDT_Mask(Parameters(Session));
        imageDisplay(t,1) = Screen('MakeTexture', window1, img1);
        imageDisplay(t,2) = Screen('MakeTexture', window1, img2);

    end
    
    % Display blank screen at the end of the cross-fixation screen:
    Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
    flipTime = Screen('Flip', window1, flipTime + Times(Session).FirstFixation - Times(Session).FixationBlockBlank - Times(Session).slack);

    % A loop for each trial:
    for t = 1:length(Times(Session).SOAs)

        % Display circle fixation:
        Screen('DrawTexture', window1, CircleDisplay);
        if (t ~= 1)
            Screen('Flip', window1);
        else
            Screen('Flip', window1, flipTime + Times(Session).FixationBlockBlank - Times(Session).slack);
        end

        if choice.DeviceNumber==1
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
        
        % Display the blank screen:
        Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
        flipTime = Screen('Flip', window1);

        % Display the target screen:
        Screen('DrawTexture', window1, imageDisplay(t,1));
        flipTime = Screen('Flip', window1, flipTime + Times(Session).Blank - Times(Session).slack);

        % Display the SOA blank screen:
        Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
        flipTime = Screen('Flip', window1, flipTime + Times(Session).Target - Times(Session).slack);

        % Display the mask screen:
        Screen('DrawTexture', window1, imageDisplay(t,2));
        flipTime = Screen('Flip', window1, flipTime + Output(Session).SOAs(b,t)/1000 - Times(Session).Target - Times(Session).slack);

        % Display the blank screen in which the subject responses:
        Screen(window1, 'FillRect', Parameters(Session).BackgroundColor);
        flipTime = Screen('Flip', window1, flipTime + Times(Session).Mask - Times(Session).slack);

        % Get the subject's responses:
        if choice.DeviceNumber==1
            % When response device is the mouse, receiving only 2 mouse
            % presses while ignoring wheel presses, and recording the
            % timings of the presses:
            buttons1 = [0 0 0];
            nonemouse = 0;
            while ~buttons1(1) && ~buttons1(3)
                [~,~,buttons1] = GetMouse;
            end
            if buttons1(3)
                Output(Session).Responses(1,t,b) ='L';
            end
            if Output(Session).Responses(1,t,b)~=Output(Session).Displays(1,t,b)
                % Playing the error sound for a wrong fixation response:
                PsychPortAudio('Stop', pahandle);
                PsychPortAudio('UseSchedule', pahandle, 3);
                PsychPortAudio('Start', pahandle);
            end
            Output(Session).ResponseTimes(1,t,b) = GetSecs - flipTime;
            buttons2 = buttons1;
            while (~nonemouse && buttons1(1)==buttons2(1) && buttons1(3)==buttons2(3)) || (nonemouse && ~buttons2(1) && ~buttons2(3))
                [~,~,buttons2] = GetMouse;
                if ~any(buttons2)
                    nonemouse = 1;
                end
            end
            Output(Session).ResponseTimes(2,t,b) = GetSecs - flipTime;
            if buttons2(3) && (~buttons1(3) ||  ~buttons2(1))
                Output(Session).Responses(2,t,b) ='|';
            end
            while any(buttons2)
                [~,~,buttons2] = GetMouse;
            end
        else
            % When response device is the keyboard, receiving only 2
            % presses while ignoring any presses not defined ahead as legal
            % keys for response, and recording the timings of the presses:
            i = 1;
            KbQueueFlush([],2);
            while i<3
                [event, ~] = PsychHID('KbQueueGetEvent');
                if ~isempty(event) && ~event.Pressed && ismember(event.Keycode,[Parameters(Session).L_Ver,Parameters(Session).T_Hor])
                    if ismember(event.Keycode,Parameters(Session).L_Ver)
                        if i==1
                            Output(Session).Responses(i,t,b) ='L';
                        else
                            Output(Session).Responses(i,t,b) ='|';
                        end
                    end
                    if i==1 && (Output(Session).Responses(1,t,b)~=Output(Session).Displays(1,t,b))
                        % Playing the error sound for a wrong fixation response:
                        PsychPortAudio('Stop', pahandle);
                        PsychPortAudio('UseSchedule', pahandle, 3);
                        PsychPortAudio('Start', pahandle);
                    end
                    Output(Session).ResponseTimes(i,t,b) = event.Time - flipTime;
                    i = i+1;
                end
            end
        end
        
        pause(1); % A pause of 1 second at the end of each trial after receiving the responses.
        
    end    

    % Display the cross fixation:
    Screen('DrawTexture', window1, CrossDisplay);
    flipTime = Screen('Flip', window1);
    
    % Calculating the output arrays regarding the success of the subject
    % according to the responses of the current block:
    % Chronologic successes:
    Output(Session).Successes(:,:,b) = char(Output(Session).Responses(:,:,b))==char(Output(Session).Displays(:,:,b));
    % Successes by SOA:
    Output(Session).SortedSuccesses(:,:,b) = Output(Session).Successes(:,:,b);
    [~,temp] = sort(Output(Session).SOAs(b,:),'descend');
    Output(Session).SortedSuccesses(1,:,b) = Output(Session).Successes(1,temp,b);
    Output(Session).SortedSuccesses(2,:,b) = Output(Session).Successes(2,temp,b);
    temp = Output(Session).SortedSuccesses(:,:,b)';
    % Average successes by SOA:
    for t = 1:length(Times(Session).SOAs)/choice.nTrials
        Output(Session).SOASuccess(t,:,b) = mean(temp(choice.nTrials*(t-1)+1:choice.nTrials*t,:),1);
    end
    
    % Checking whether the session finished, a new block is needed, or the
    % subject should re-enter training:
    Continue = 1;
    if choice.ReTraining && b<4 && sum(Output(Session).SortedSuccesses(2,1:6,b))<5
        % Subject should re-enter training:
        text = 'Block finished, please call the instructor';
        Continue = 0;
    else
        if b < choice.nBlocks
            % Subject can continue to the next block:
            if choice.DeviceNumber==1
                text = 'Press the mouse to continue to the next block';
            else
                text = 'Press the space bar to continue to the next block';
            end
        else
            % Experiment finished:
            text = 'Session finished, please call the instructor';
            Output(Session).Finished = 'Yes';
            Continue = 0;
        end
    end
    DrawFormattedText(window1,text, 'center', 'center', Parameters(Session).TextColor);
    Screen('Flip', window1, flipTime + Times(Session).FinalFixation - Times(Session).slack);
    KbQueueFlush([],2);
    
    % Arranging the final struct for saving:
    ThresholdTraining.Parameters = Parameters;
    ThresholdTraining.Times = Times;
    ThresholdTraining.Output = Output;
    % Saving the data under the subject name in a local backup folder, a
    % drive backup folder, and in the MATLAB's current folder.
    % When the backup folders do not exist, no backup is saved and a
    % warning message displays:
    if SaveInitialTraining
        try
            save(['C:\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining', 'InitialTraining');
        catch
            fprintf('''C:\\Backups'' folder does not exist, and no local backup saved!\n');
        end
        try
            save(['Z:\Yehuda\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining', 'InitialTraining');
        catch
            fprintf('''Z:\\Yehuda\\Backups'' folder does not exist, and no drive backup saved!\n');
        end
        save(filename, 'SubjectName', 'ThresholdTraining', 'InitialTraining');
    else
        try
            save(['C:\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining');
        catch
            fprintf('''C:\\Backups'' folder does not exist, and no local backup saved!\n');
        end
        try
            save(['Z:\Yehuda\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining');
        catch
            fprintf('''Z:\\Yehuda\\Backups'' folder does not exist, and no drive backup saved!\n');
        end
        save(filename, 'SubjectName', 'ThresholdTraining');
    end
    
    % Wating for press to continue or finish:
    if Continue
        if choice.DeviceNumber==1
            % Wait for subject to press mouse or esc:
            buttons = [0 0 0];
            while ~any(buttons)
                [~,~,buttons] = GetMouse;
                [~,~,keyCode] = KbCheck;
                if keyCode(27)
                    % Exit the experiment when clicking the 'esc' key:
                    b = choice.nBlocks+1;
                    break
                end
            end
            while any(buttons)
                [~,~,buttons] = GetMouse;
            end
        else
            % Wait for subject to press spacebar:
            while 1
                [~,~,keyCode] = KbCheck;
                if keyCode(32) && (b < choice.nBlocks)
                    break
                elseif keyCode(27)
                    % Exit the experiment when clicking the 'esc' key:
                    b = choice.nBlocks+1;
                    break
                end
            end
        end
    else
        % Wait for subject to press esc:
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(27)
                b = choice.nBlocks+1;
                break
            end
        end
    end
    
    b = b+1; % Increasing the current number of block.

end

%% End the Training. DO NOT change this section!

% Convert output matrices to 'char'. for the fixations the options are 'T'
% or 'L'. For the alignments the options are '-' for horizontal and '|' for vertical.
% Make sure you remember that Matan is the queen of everything.
% Both matrices are 3-dimensional: each 3-dimension page is for a try,
% each column in a page is for a trial, the first row is for fixations
% and the second row is for alignments:
Output(Session).Responses = char(Output(Session).Responses);
Output(Session).Displays = char(Output(Session).Displays);
% Total runtime of the training:
Output(Session).TotalTrainingTime = GetSecs - itime; 
Output(Session).TotalTrainingTime = [num2str(floor(Output(Session).TotalTrainingTime/60)),':',num2str(rem(Output(Session).TotalTrainingTime,60))]; % Total time of the training.
% The date and time of the experiment:
Output(Session).ExperimentDateTime = datestr(clock);

% Finish the session:
close all;
PsychPortAudio('Close' ,pahandle);
clearvars pahandle;
Screen(window1,'Close'); % Close the onscreen window.
sca;
Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz); % Restore screen original resolution and refresh rate.
KbQueueStop;

% Arranging the final struct for saving:
ThresholdTraining.Parameters = Parameters;
ThresholdTraining.Times = Times;
ThresholdTraining.Output = Output;

% Saving the data under the subject name in a local backup folder, a
% drive backup folder, and in the MATLAB's current folder. When the backup
% folders do not exist, no backup is saved and a warning message displays:
if SaveInitialTraining
    try
        save(['C:\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining', 'InitialTraining');
    catch
        fprintf('''C:\\Backups'' folder does not exist, and no local backup saved!\n');
    end
    try
        save(['Z:\Yehuda\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining', 'InitialTraining');
    catch
        fprintf('''Z:\\Yehuda\\Backups'' folder does not exist, and no drive backup saved!\n');
    end
    save(filename, 'SubjectName', 'ThresholdTraining', 'InitialTraining');
else
    try
        save(['C:\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining');
    catch
        fprintf('''C:\\Backups'' folder does not exist, and no local backup saved!\n');
    end
    try
        save(['Z:\Yehuda\Backups\',filename,'_PreWeibull',datestr(now,'dd.mm.yy-HHMMSS'),'.mat'], 'SubjectName', 'ThresholdTraining');
    catch
        fprintf('''Z:\\Yehuda\\Backups'' folder does not exist, and no drive backup saved!\n');
    end
    save(filename, 'SubjectName', 'ThresholdTraining');
end

% Question dialog asking whether to analyse Weibull or not:
choice = questdlg('Analyse?','Analyse','Yes','No','Yes');

% Weibull analysis when required:
if strcmp(choice,'Yes')
    % Parameters for the analysis:
    start = [200; 10; 1];
    options = optimset('TolX',0.1);
    % The SOA times vector:
    T = sort(unique(Times(Session).SOAs,'stable'),'descend')';
    figure;
    % The average success ratio per SOA:
    y = mean(Output(Session).SOASuccess(:,2,:),3);
    % Plotting the results:
    plot(T,y,'ro');
    hold on;
    h = plot(T,y,'b');
    hold on;
    % Calculating the Weibull fit:
    temp = lsqcurvefit('weibull_err1',start, T, y, [0 0 0], [inf inf 1], options, h );
    % Saving the Weibull fit results:
    WeibullAnalysis(Session).T_es = temp(1);
    WeibullAnalysis(Session).b_es = temp(2);
    WeibullAnalysis(Session).p_es = temp(3);
    WeibullAnalysis(Session).t80 = fzero( 'WeibMinus', 0, [], temp(1), temp(2), temp(3), .8 );
    % Plotting the Weibull fit curve:
    z = Weibull(T, temp(1), temp(2), temp(3));
    plot(T,z,'b');
    % Displaying the results on top of the graph:
    legend('data',['Weibull: T= ' num2str(temp(1)) ',   b= ' num2str(temp(2)) ',  t80= ' num2str(WeibullAnalysis(Session).t80) ', p= ' num2str(temp(3))]);
    disp(['Estimated t80: ' num2str(WeibullAnalysis(Session).t80)]);
    
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
    
    close all;
    % Arranging the final struct for saving:
    ThresholdTraining.WeibullAnalysis = WeibullAnalysis;
    
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
    

end


%% Subfunctions. DO NOT change this section!

function choice = choosedialog(choice)

% This subfunction defines the GUI used in the beginning of the function.
% Each paragraph defines an object in the GUI window. Positions may be
% changed when objects are added or deleted. Make sure each object refering
% to a value used in the function has its own subfunction at the end of
% this subfunction.

    FontSize = 12;
    % The GUI box:
    d = dialog('Units','normalized','Position',[0.1,0.1,0.8,0.8],'Name','Parameter Choosing');
    
    % Subject name or number:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.9 0.25 0.03],...
              'String','Subject Name/Number:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.85 0.25 0.05],...
              'String',choice.SubjectName,...
              'Callback',@getName);
       
    % Load button:
    uicontrol('Parent',d,...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.125 0.8 0.1 0.045],...
              'String','Load',...
              'Callback',@LoadSubject);
    
    % Session number:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.7 0.25 0.03],...
              'String','Session Number:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.65 0.25 0.05],...
              'String',choice.Session,...
              'Callback',@getSession);
    
    % Day number:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.6 0.25 0.03],...
              'String','Day Number:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.55 0.25 0.05],...
              'String',choice.Day,...
              'Callback',@getDay);
    
    % Group number:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.5 0.25 0.03],...
              'String','Group Number:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.45 0.25 0.05],...
              'String',choice.Group,...
              'Callback',@getGroup);
    
    % Sleep hours:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.4 0.25 0.03],...
              'String','Sleep Hours:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.35 0.25 0.05],...
              'String',choice.Sleep,...
              'Callback',@getSleep);
    
    % Subject's gender:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.3 0.25 0.03],...
              'String','Gender:');
          
    uicontrol('Parent',d,...
              'Style','popup',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.25 0.25 0.05],...
              'Value',choice.GenderNumber,...
              'String',{'Female';'Male'},...
              'Callback',@getGender);
    
    % Subject's age:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.2 0.25 0.03],...
              'String','Age:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.05 0.15 0.25 0.05],...
              'String',choice.Age,...
              'Callback',@getAge);
    
    % Number of trials:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.9 0.25 0.03],...
              'String','Number of Trials:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.85 0.25 0.05],...
              'String',choice.nTrials,...
              'Callback',@getTrials);
    
    % Number of blocks:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.8 0.25 0.03],...
              'String','Number of Blocks:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.75 0.25 0.05],...
              'String',choice.nBlocks,...
              'Callback',@getBlocks);
    
    % Target time:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.7 0.25 0.03],...
              'String','Target Time (ms):');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.65 0.25 0.05],...
              'String',choice.TargetTime,...
              'Callback',@getTargetTime);
          
    % Response Device:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.6 0.25 0.03],...
              'String','Response Device:');
          
    uicontrol('Parent',d,...
              'Style','popup',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.55 0.25 0.05],...
              'Value',choice.DeviceNumber,...
              'String',{'Mouse';'Keyboard'},...
              'Callback',@getDevice);
          
    % 'T' and row response keys:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.5 0.25 0.03],...
              'String','T/Row Response Keys:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.45 0.25 0.05],...
              'String',char(choice.TRKeys),...
              'Callback',@getTRKeys);
          
    % 'L' and column response keys:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.4 0.25 0.03],...
              'String','L/Column Response Keys:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.35 0.25 0.05],...
              'String',char(choice.LCKeys),...
              'Callback',@getLCKeys);
          
    % Screen choosing:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.3 0.25 0.03],...
              'String','Screen:');
          
    uicontrol('Parent',d,...
              'Style','popup',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.25 0.25 0.05],...
              'Value',choice.ScreenNumber,...
              'String',{'TMS Room';'TDT Room';'Old HP'},...
              'Callback',@getScreen);
          
    % Re-training condition check-box:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'HorizontalAlignment','left',...
              'fontsize',FontSize,...
              'Position',[0.37 0.17 0.2 0.04],...
              'String','Re-Training Condition');
          
    uicontrol('Parent',d,...
              'Style','checkbox',...
              'Units','normalized',...
              'Position',[0.35 0.17 0.02 0.05],...
              'Value',choice.ReTraining,...
              'Callback',@getReTraining);
          
    % Number of columns of lines:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.9 0.25 0.03],...
              'String','Number of columns of lines:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.85 0.25 0.05],...
              'String',choice.VerticalLines,...
              'Callback',@getVerticalLines);
          
    % Number of rows of lines:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.8 0.25 0.03],...
              'String','Number of rows of lines:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.75 0.25 0.05],...
              'String',choice.HorizontalLines,...
              'Callback',@getHorizontalLines);
          
    % Relative size of screen on which the stimuli is presented:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.7 0.25 0.03],...
              'String','Relative Size of Screen:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.65 0.25 0.05],...
              'String',choice.RelativeSize,...
              'Callback',@getRelativeSize);
          
    % Screen width in pixels:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.6 0.25 0.03],...
              'String','Screen Width (pixels):');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.55 0.25 0.05],...
              'String',choice.ScreenWidth,...
              'Callback',@getScreenWidth);
          
    % Screen hight in pixels:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.5 0.25 0.03],...
              'String','Screen Height (pixels):');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.45 0.25 0.05],...
              'String',choice.ScreenHeight,...
              'Callback',@getScreenHeight);
          
    % Screen refresh rate in Hz:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.4 0.25 0.03],...
              'String','Refresh Rate (Hz):');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.35 0.25 0.05],...
              'String',choice.RefreshRate,...
              'Callback',@getRefreshRate);
          
    % Orientation of the backround lines:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.3 0.25 0.03],...
              'String','Orientation:');
          
    uicontrol('Parent',d,...
              'Style','popup',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.25 0.25 0.05],...
              'Value',choice.OrientationNumber,...
              'String',{'-';'|'},...
              'Callback',@getOrientation);
          
    % Horizontal offset of the target lines in relation to the center:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.2 0.25 0.03],...
              'String','Target Horizontal Offset:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.15 0.25 0.05],...
              'String',choice.TargetHorizontalOffset,...
              'Callback',@getTargetHorizontalOffset);
          
    % Vertical offset of the target lines in relation to the center:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.1 0.25 0.03],...
              'String','Target Vertical Offset:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.65 0.05 0.25 0.05],...
              'String',choice.TargetVerticalOffset,...
              'Callback',@getTargetVerticalOffset);
          
    % 'OK' button:
    uicontrol('Parent',d,...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.35 0.05 0.1 0.05],...
              'String','OK',...
              'Callback',@GetAnswerOK);
          
    % 'Cancel' button:
    uicontrol('Parent',d,...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.5 0.05 0.1 0.05],...
              'String','Cancel',...
              'Callback',@GetAnswerCancel);
       
    
    % Wait for GUI to close before continuing:
    uiwait(d);
    
    % Subfunctions for each individual object returning a value:
    function getName(source,~)
        choice.SubjectName = char(source.String);
    end
    function getSession(source,~)
        choice.Session = str2double(source.String);
    end
    function getDay(source,~)
        choice.Day = str2double(source.String);
    end
    function getTrials(source,~)
        choice.nTrials = str2double(source.String);
    end
    function getBlocks(source,~)
        choice.nBlocks = str2double(source.String);
    end
    function getGroup(source,~)
        choice.Group = str2double(source.String);
    end
    function getAge(source,~)
        choice.Age = str2double(source.String);
    end
    function getSleep(source,~)
        choice.Sleep = str2double(source.String);
    end
    function getDevice(source,~)
        choice.Device = char(source.String(source.Value,:));
        choice.DeviceNumber = source.Value;
    end
    function getGender(source,~)
        choice.Gender = char(source.String(source.Value,:));
        choice.GenderNumber = source.Value;
    end
    function getTargetTime(source,~)
        choice.TargetTime = str2double(source.String);
    end
    function getTRKeys(source,~)
        choice.TRKeys = source.String;
    end
    function getLCKeys(source,~)
        choice.LCKeys = source.String;
    end
    function getScreen(source,~)
        choice.Screen = char(source.String(source.Value,:));
        choice.ScreenNumber = source.Value;
    end
    function getReTraining(source,~)
        choice.ReTraining = source.Value;
    end
    function getVerticalLines(source,~)
        choice.VerticalLines = str2double(source.String);
    end
    function getHorizontalLines(source,~)
        choice.HorizontalLines = str2double(source.String);
    end
    function getRelativeSize(source,~)
        choice.RelativeSize = str2double(source.String);
    end
    function getScreenWidth(source,~)
        choice.ScreenWidth = str2double(source.String);
    end
    function getScreenHeight(source,~)
        choice.ScreenHeight = str2double(source.String);
    end
    function getRefreshRate(source,~)
        choice.RefreshRate = str2double(source.String);
    end
    function getOrientation(source,~)
        choice.Orientation = char(source.String(source.Value,:));
        choice.OrientationNumber = source.Value;
    end
    function getTargetHorizontalOffset(source,~)
        choice.TargetHorizontalOffset = str2double(source.String);
    end
    function getTargetVerticalOffset(source,~)
        choice.TargetVerticalOffset = str2double(source.String);
    end
    function GetAnswerOK(~,~)
        delete(gcf);
        choice.Answer = 1;
    end
    function GetAnswerCancel(~,~)
        delete(gcf);
        choice.Answer = 0;
    end
    function LoadSubject(~,~)
        delete(gcf);
        choice.Load = 1;
    end
        
end
