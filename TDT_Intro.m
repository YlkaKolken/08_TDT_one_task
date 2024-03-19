function TDT_Intro

%% TDT Introduction.

% This is a primary training session for the TDT experiment used only to
% familiarize the subject with the task.
% The screens are changing with the pressing of the space bar or mouse
% buttons and no timing is recorded. The circle fixation screen is passed 
% when clicking the mouse wheel when the mouse is selected as the response
% device. At the black screen following the mask the subject is required to
% respond using either the keyboard or mouse to the stimulus presented.
% Error sounds are active as well. The introduction keeps looping until the
% 'esc' key is pressed during the circle fixation screen. No variables are
% needed as input and none are saved.
% The required syntax is: "TDT_Intro;", or through "TDT;".

%% Get Parameters through GUI.

% Values for the Gamma correction and brightness of the screen.
% Values are according to measurements on the dates in the Dates vector.
% The CRT screens are in the following order:
% [TMS room, TDT room,  Old CRT screen]
Screens = [{'ViewSonic PF817 Serial Number: QY01400013'};{'ViewSonic PF817 Serial Number: QY01400084'};{'HP P1230 Serial Number: CNV4300070'}];
Gamma = [2.8252,3.4603,2.2437];
Brightness = [33,24,30];
Dates = ['18/09/2016';'07/07/2016';'03/04/2016'];

% Default values for the GUI screen:

% Keyboard keys for response:
choice.TRKeys = ''; % 'T' for fixation and row for alignment.
choice.LCKeys = ''; % 'L' for fixation and column for alignment.

choice.Device = 'Mouse'; % Responce device, could be either 'Mouse' or 'Keyboard'.
choice.DeviceNumber = 1;
choice.Screen = 'TMS Room'; % Screen used, could be either 'TMS Room', 'TDT Room' or 'Old HP'.
choice.ScreenNumber = 1;
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

% "Endless" loop for getting values from the GUI. The loop ends when all
% values are legal and no errors found:
while 1
    choice = choosedialog(choice); % Calling the subfunction defining the GUI.
    if ~choice.Answer
        return
    end
    
    % Checking legality of 'choice.TRKeys' & 'choice.LCKeys' when keyboard
    % is selected:
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
    
    % Checking legality of all the rest of the parameters:
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
    
    break % Exit the endless loop.
    
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

% Visual parameters:
% Parameters from GUI:
Parameters.GammaCorrection = Gamma(choice.ScreenNumber);
Parameters.VL = choice.VerticalLines;
Parameters.HL = choice.HorizontalLines;
Parameters.T_Hor = upper(choice.TRKeys);
Parameters.L_Ver = upper(choice.LCKeys);
Parameters.Orientation = choice.Orientation;
Parameters.TargetOffset = [choice.TargetHorizontalOffset,choice.TargetVerticalOffset];
% Parameters not from GUI:
Parameters.BackgroundColor = 1; % Color of background. Default is 1.
Parameters.StimuliColor = 255; % Color of lines and letters in stimuli. Default is 255.
Parameters.MaskColor = 200; % Color of mask. Default is 200.
Parameters.TextColor = 255; % Color of written text. Default is 255.
Parameters.CircleRadius = 9; % The fixation circle radius in pixels. Default is 9.
Parameters.CircleWidth = 1; % The fixation circle width in pixels. Default is 1.
Parameters.CrossWidth = 2; % The fixation cross width in pixels. Default is 2.
Parameters.CrossLength = 30; % The fixation cross length in pixels. Standard is 30.
Parameters.Hjitter = 2; % The horizontal jitter effect- maximum number of pixels each 
                        % line is allowed to shift from its original location. Default is 2.
Parameters.Vjitter = 2; % The vertical jitter effect. Default is 2.
Parameters.LineLength = 28; % The length of each background line in pixels. Default is 28.
Parameters.LineWidth = 2; % The width of each background line in pixels. Default is 2.
Parameters.LetterLength = 8; % The length of each center letter line in pixels. Default is 8.
Parameters.LetterWidth = 2; % The width of each center letter line in pixels. Default is 2.
Parameters.TargetLength = 28; % The length of each target line in pixels. Default is 28.
Parameters.TargetWidth = 2; % The width of each target line in pixels. Default is 2.

% Sound parameters:
Parameters.BeepFrequency = 400; % Frequency of error sound in [Hz]. Default is 400.
Parameters.BeepDuration = 0.08; % Duration of error sound in seconds. Default is 0.08.
Parameters.BeepVolume = 0.4; % Volume of error sound. Default is 0.4.
Parameters.SampleRate = 44100; % Sound sample rate. Default is 44100;


%% Set up the experiment. DO NOT change this section!

% Applying the gamma correction to the colors and saving the new values:
Parameters.BackgroundColor = ((Parameters.BackgroundColor/255)^(1/Parameters.GammaCorrection))*255;
Parameters.StimuliColor = ((Parameters.StimuliColor/255)^(1/Parameters.GammaCorrection))*255;
Parameters.TextColor = ((Parameters.TextColor/255)^(1/Parameters.GammaCorrection))*255;
Parameters.MaskColor = ((Parameters.MaskColor/255)^(1/Parameters.GammaCorrection))*255;

% Creating the error sound as a vector in time:
Parameters.BeepVec = Parameters.BeepVolume*sin(2*pi*Parameters.BeepFrequency*(1:Parameters.SampleRate*Parameters.BeepDuration)/Parameters.SampleRate);
Parameters.BeepVec = [Parameters.BeepVec(:);zeros(length(Parameters.BeepVec),1);Parameters.BeepVec(:)];

% Screen setup
close all;
clear screen;
whichScreen = max(Screen('Screens'));
% Setting the screen resolution and refresh rate according to GUI. If the
% values remain empty the screen stays as it is. If the values are not
% supported by the screen a warning appears and the screen stays as it is.
% The current values of the screen are saved and restored at the end of the
% experiment:
Parameters.W = [];
Parameters.H = [];
Parameters.Hz = [];
if ~isempty(choice.ScreenWidth)
    Parameters.W = str2double(num2str(choice.ScreenWidth)); % screen width
end
if ~isempty(choice.ScreenHeight)
    Parameters.H = str2double(num2str(choice.ScreenHeight)); % screen height
end
if ~isempty(choice.RefreshRate)
    Parameters.Hz = str2double(num2str(choice.RefreshRate)); % screen refresh rate
end
try
    oldResolution = Screen('Resolution', whichScreen, Parameters.W, Parameters.H, Parameters.Hz);
catch
    question2 = questdlg('Screen Resolution and/or Refresh Rate requested is not supported by this screen, continue with current screen settings?','!!WARNING!!','Yes','No','No');
    if strcmp(question2,'No')
        return
    end
    oldResolution = Screen('Resolution', whichScreen);
end
Resolution = Screen('Resolution', whichScreen);
[window1, ~] = Screen('Openwindow',whichScreen,Parameters.BackgroundColor,[],[],2); % Opening the onscreen window.
Parameters.W = Resolution.width;
Parameters.H = Resolution.height;
Parameters.Hz = Resolution.hz;

% Parameters for the stimuli images creation:
Parameters.m = round(choice.RelativeSize*Parameters.H/choice.VerticalLines);
Parameters.n = Parameters.m; % Size of a single line image in pixels.

% Display blank screen:
Screen(window1,'FillRect',Parameters.BackgroundColor);
Screen('Flip', window1);

%% Run experiment.  DO NOT change this section!

% Screen priority
Priority(MaxPriority(window1));
Priority(2);
HideCursor(whichScreen); % Hide the mouse cursor.
InsideIntro(Parameters,choice.DeviceNumber,window1); % Run the loop of the introduction.

%% End the experiment. DO NOT change this section!

Screen(window1,'Close'); % Close the onscreen window.
close all;
sca;
Screen('Resolution', whichScreen, oldResolution.width, oldResolution.height, oldResolution.hz); % Restore screen original resolution and refresh rate.

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
    d = dialog('Units','normalized','Position',[0.25,0.2,0.5,0.6],'Name','Parameter Choosing');
    
    % Response device:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.95 0.35 0.05],...
              'String','Response Device:');
          
    uicontrol('Parent',d,...
              'Style','popup',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.9 0.35 0.05],...
              'Value',choice.DeviceNumber,...
              'String',{'Mouse';'Keyboard'},...
              'Callback',@getDevice);
   
    % 'T' and row response keys:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.8 0.35 0.05],...
              'String','T/Row Response Keys:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.75 0.35 0.05],...
              'String',char(choice.TRKeys),...
              'Callback',@getTRKeys);
    
    % 'L' and column response keys:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.65 0.35 0.05],...
              'String','L/Column Response Keys:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.6 0.35 0.05],...
              'String',char(choice.LCKeys),...
              'Callback',@getLCKeys);
    
    % Screen choosing:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.5 0.35 0.05],...
              'String','Screen:');
          
    uicontrol('Parent',d,...
              'Style','popup',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.45 0.35 0.05],...
              'Value',choice.ScreenNumber,...
              'String',{'TMS Room';'TDT Room';'Old HP'},...
              'Callback',@getScreen);
   
    % Number of columns of lines:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.35 0.35 0.05],...
              'String','Number of columns of lines:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.3 0.35 0.05],...
              'String',choice.VerticalLines,...
              'Callback',@getVerticalLines);
    
    % Number of rows of lines:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.2 0.35 0.05],...
              'String','Number of rows of lines:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.15 0.35 0.05],...
              'String',choice.HorizontalLines,...
              'Callback',@getHorizontalLines);
    
    % Relative size of screen on which the stimuli is presented:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.95 0.35 0.05],...
              'String','Relative Size of Screen:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.9 0.35 0.05],...
              'String',choice.RelativeSize,...
              'Callback',@getRelativeSize);
    
    % Screen width in pixels:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.8 0.35 0.05],...
              'String','Screen Width (pixels):');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.75 0.35 0.05],...
              'String',choice.ScreenWidth,...
              'Callback',@getScreenWidth);
    
    % Screen hight in pixels:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.65 0.35 0.05],...
              'String','Screen Height (pixels):');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.6 0.35 0.05],...
              'String',choice.ScreenHeight,...
              'Callback',@getScreenHeight);
    
    % Screen refresh rate in Hz:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.5 0.35 0.05],...
              'String','Refresh Rate (Hz):');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.45 0.35 0.05],...
              'String',choice.RefreshRate,...
              'Callback',@getRefreshRate);
    
    % Orientation of the backround lines:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.35 0.35 0.05],...
              'String','Orientation:');
          
    uicontrol('Parent',d,...
              'Style','popup',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.3 0.35 0.05],...
              'Value',choice.OrientationNumber,...
              'String',{'-';'|'},...
              'Callback',@getOrientation);
    
    % Horizontal offset of the target lines in relation to the center:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.2 0.35 0.05],...
              'String','Target Horizontal Offset:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.15 0.35 0.05],...
              'String',choice.TargetHorizontalOffset,...
              'Callback',@getTargetHorizontalOffset);
    
    % Vertical offset of the target lines in relation to the center:
    uicontrol('Parent',d,...
              'Style','text',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.1 0.35 0.05],...
              'String','Target Vertical Offset:');
          
    uicontrol('Parent',d,...
              'Style','edit',...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.55 0.05 0.35 0.05],...
              'String',choice.TargetVerticalOffset,...
              'Callback',@getTargetVerticalOffset);
       
    % 'OK' button:
    uicontrol('Parent',d,...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.1 0.05 0.15 0.05],...
              'String','OK',...
              'Callback',@GetAnswerOK);
       
    % 'Cancel' button:
    uicontrol('Parent',d,...
              'Units','normalized',...
              'fontsize',FontSize,...
              'Position',[0.3 0.05 0.15 0.05],...
              'String','Cancel',...
              'Callback',@GetAnswerCancel);
       
    
    % Wait for GUI to close before continuing:
    uiwait(d);

    % Subfunctions for each individual object returning a value:
    function getDevice(source,~)
        choice.Device = char(source.String(source.Value,:));
        choice.DeviceNumber = source.Value;
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

end
