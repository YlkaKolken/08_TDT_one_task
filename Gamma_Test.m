function Gamma_Test


% Screen setup
close all;
clear screen;
whichScreen = max(Screen('Screens'));
[window1, ~] = Screen('Openwindow',whichScreen,255,[],[],2);
% Display blank screen:
Screen(window1,'FillRect',0);
Screen('Flip', window1);


Colors = [0;40;80;120;127;160;200;240;255];
Gamma = 2.8252;% Gamma correction value for the colors.
               % Value according to measurements on
               % CRT screen at the TMS room in 18/09/2016.
% 3.2547;% Gamma correction value for the colors.
               % Value according to measurements on
               % CRT screen at the lab in 27/03/2016.
Colors = ((Colors/255).^(1/Gamma))*255;
%% Run experiment.  DO NOT change this section!

% Screen priority
Priority(MaxPriority(window1));
Priority(2);

for i = 1:length(Colors)
        
    Screen(window1,'FillRect',Colors(i));
    Screen('Flip', window1);
    % Wait for subject to press and release mouse button
    buttons = 0;
    while 1
        [~,~,keyCode] = KbCheck;
        [~,~,buttons] = GetMouse;
        if keyCode(KbName('space')) || any(buttons)
            break
        end
        if keyCode(KbName('esc'))
            Screen(window1,'Close');
            close all;
            sca;
            return
        end
    end
    KbReleaseWait;
    while any(buttons)
        [~,~,buttons] = GetMouse;
    end

end

Screen(window1,'Close');
close all;
sca;

end
