function Trials = InsideIntro(Parameters,Selection,window)

% This is an introduction session for the TDT experiment.
% The function is not designed to be used solely, but only inside the
% functions "TDT_Intro" and "TDT_Initial_Training".
% The screens are changing with the pressing of the space bar or mouse
% buttons and no timing is recorded. The circle fixation screen is passed 
% when clicking the mouse wheel when the mouse is selected as the response
% device. At the black screen following the mask the subject is required to
% respond using either the keyboard or mouse to the stimulus presented.
% Error sounds are active as well. The introduction keeps looping until the
% 'esc' key is pressed during the circle fixation screen. The inputs are
% the parameters struct which should contain all the relevant visual
% parameters, the selection variable which correspond for the response
% device (1=mouse, 2=keyboard), and the onscreen window.
% needed as input and the number of loops completed (trials) is the only
% output variable.
% The required syntax is: "TDT_Intro;", or through "TDT;".

    Trials = 0; % Number of trials done in the introduction.
    TextOffset = 20; % Visual parameter for the "Introduction" text.
    
    % Set up keyboard for receiving data:
    ListenChar(0);
    KbQueueCreate;
    KbQueueStart;
    KbReleaseWait;
    KbQueueFlush([],2);
    
    % Fixation and alignments values for the textures:
    Fixations = [84 76];
    Alignments = [45 124];
    
    % Prepare the textures for the cross and circle fixation screens:
    CircleDisplay = Screen('MakeTexture', window, TDT_Circle(Parameters));
    CrossDisplay = Screen('MakeTexture', window, TDT_Cross(Parameters));
    
    % Sound card regarding commands:
    clearvars pahandle;
    InitializePsychSound;
    pahandle = PsychPortAudio('Open');
    % Getting the sound vector ready to play:
    bufferhandle = PsychPortAudio('CreateBuffer' ,pahandle, [Parameters.BeepVec';Parameters.BeepVec']);
    PsychPortAudio('UseSchedule', pahandle, 1);
    PsychPortAudio('AddToSchedule', pahandle, bufferhandle);
    status = PsychPortAudio('GetStatus', pahandle);
    while status.State
        status = PsychPortAudio('GetStatus', pahandle);
    end
    PsychPortAudio('UseSchedule', pahandle, 2);
    PsychPortAudio('AddToSchedule', pahandle, bufferhandle);
    
    % Display the Ready screen:
    DrawFormattedText(window,'Remember to focus on the center', 'center', 'center', Parameters.TextColor);
    % Writting '{Introduction}' in the corners of the screen:
    DrawFormattedText(window,'{Introduction}', 1, TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 'right', TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 1, Parameters.H-TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 'right', Parameters.H-TextOffset, Parameters.TextColor);
    Screen('Flip',window);
    
    if Selection==1
        % Wait for subject to press and release mouse button:
        buttons = 0;
        while 1
            [~,~,keyCode] = KbCheck;
            [~,~,buttons] = GetMouse;
            if any(buttons)
                break
            end
            if keyCode(KbName('esc'))
                % Exit the introduction when pressing 'esc':
                return
            end
        end
        while any(buttons)
            [~,~,buttons] = GetMouse;
        end
    else
        % Wait for subject to press and release the space bar:
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))
                break
            end
            if keyCode(KbName('esc'))
                % Exit the introduction when pressing 'esc':
                return
            end
        end
        KbReleaseWait;
    end

    % Display the cross fixation screen:
    Screen('DrawTexture', window, CrossDisplay);
    % Writting '{Introduction}' in the corners of the screen:
    DrawFormattedText(window,'{Introduction}', 1, TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 'right', TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 1, Parameters.H-TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 'right', Parameters.H-TextOffset, Parameters.TextColor);
    Screen('Flip', window);

    if Selection==1
        % Wait for subject to press and release mouse button:
        buttons = 0;
        while 1
            [~,~,buttons] = GetMouse;
            if any(buttons)
                break
            end
        end
        while any(buttons)
            [~,~,buttons] = GetMouse;
        end
    else
        % Wait for subject to press and release the space bar:
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))
                break
            end
        end
        KbReleaseWait;
    end

    % A loop for each trial:
    stop = 0;
    while ~stop
        % Show the circle fixation screen:
        Screen('DrawTexture', window, CircleDisplay);
        % Writting '{Introduction}' in the corners of the screen:
        DrawFormattedText(window,'{Introduction}', 1, TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 1, Parameters.H-TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', Parameters.H-TextOffset, Parameters.TextColor);
        Screen('Flip', window);

        if Selection==1
            % Wait for subject to press and release the mouse wheel:
            buttons = [0 0 0];
            while ~buttons(2)
                [~,~,keyCode] = KbCheck;
                [~,~,buttons] = GetMouse;
                if keyCode(KbName('esc'))
                    % Exit the introduction when pressing 'esc':
                    stop = 1;
                    break
                end
            end
            while any(buttons)
                [~,~,buttons] = GetMouse;
            end
        else
            % Wait for subject to press and release the space bar:
            while 1
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))
                    break
                end
                if keyCode(KbName('esc'))
                    % Exit the introduction when pressing 'esc':
                    stop = 1;
                    break
                end
            end
            KbReleaseWait;
        end
        if stop
            break
        end

        % Display the target screen with a random fixation letter and target orientation:
        Fixation = Fixations(randi(2));
        Alignment = Alignments(randi(2));
        TargetDisplay = Screen('MakeTexture', window, TDT_Target(Parameters,Fixation,Alignment));
        Screen('DrawTexture', window, TargetDisplay);
        % Writting '{Introduction}' in the corners of the screen:
        DrawFormattedText(window,'{Introduction}', 1, TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 1, Parameters.H-TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', Parameters.H-TextOffset, Parameters.TextColor);
        Screen('Flip', window);

        if Selection==1
            % Wait for subject to press and release mouse button:
            buttons = 0;
            while 1
                [~,~,buttons] = GetMouse;
                if any(buttons)
                    break
                end
            end
            while any(buttons)
                [~,~,buttons] = GetMouse;
            end
        else
            % Wait for subject to press and release the space bar:
            while 1
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))
                    break
                end
            end
            KbReleaseWait;
        end

        % Display the mask screen:
        MaskDisplay = Screen('MakeTexture', window, TDT_Mask(Parameters));
        Screen('DrawTexture', window, MaskDisplay);
        % Writting '{Introduction}' in the corners of the screen:
        DrawFormattedText(window,'{Introduction}', 1, TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 1, Parameters.H-TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', Parameters.H-TextOffset, Parameters.TextColor);
        Screen('Flip', window);

        if Selection==1
            % Wait for subject to press and release mouse button:
            buttons = 0;
            while 1
                [~,~,buttons] = GetMouse;
                if any(buttons)
                    break
                end
            end
            while any(buttons)
                [~,~,buttons] = GetMouse;
            end
        else
            % Wait for subject to press and release the space bar:
            while 1
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))
                    break
                end
            end
            KbReleaseWait;
        end

        % Display the blank screen:
        Screen(window, 'FillRect', Parameters.BackgroundColor);
        % Writting '{Introduction}' in the corners of the screen:
        DrawFormattedText(window,'{Introduction}', 1, TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 1, Parameters.H-TextOffset, Parameters.TextColor);
        DrawFormattedText(window,'{Introduction}', 'right', Parameters.H-TextOffset, Parameters.TextColor);
        Screen('Flip', window);

        % Get the subject's responses:
        if Selection==1
            % When response device is the mouse, receiving only 2 mouse
            % presses while ignoring wheel presses:
            buttons1 = [0 0 0];
            nonemouse = 0;
            while ~buttons1(1) && ~buttons1(3)
                [~,~,buttons1] = GetMouse;
            end
            if (buttons1(1) && Fixation==76) || (buttons1(3) && Fixation==84)
                % Playing the error sound for a wrong fixation response:
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
            % When response device is the keyboard, receiving only 2
            % presses while ignoring any presses not defined ahead as legal
            % keys for response:
            i = 1;
            KbQueueFlush([],2);
            while i<3
                [event, ~] = PsychHID('KbQueueGetEvent');
                if ~isempty(event) && ~event.Pressed && ismember(event.Keycode,[Parameters.L_Ver,Parameters.T_Hor])
                    if i==1 && ((ismember(event.Keycode,Parameters.T_Hor) && Fixation==76) || (ismember(event.Keycode,Parameters.L_Ver) && Fixation==84))
                        % Playing the error sound for a wrong fixation response:
                        PsychPortAudio('Stop', pahandle);
                        PsychPortAudio('UseSchedule', pahandle, 3);
                        PsychPortAudio('Start', pahandle);
                    end
                    i = i+1;
                end
            end
            KbReleaseWait;
        end
        
        Trials = Trials+1; % Updating the number of trials done.
        pause(1); % A pause of 1 second at the end of each trial after receiving the responses.
        
    end
        
    % Display the ending screen:
    DrawFormattedText(window,'Press esc to finish introduction', 'center', 'center', Parameters.TextColor);
    % Writting '{Introduction}' in the corners of the screen:
    DrawFormattedText(window,'{Introduction}', 1, TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 'right', TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 1, Parameters.H-TextOffset, Parameters.TextColor);
    DrawFormattedText(window,'{Introduction}', 'right', Parameters.H-TextOffset, Parameters.TextColor);
    Screen('Flip',window);

    KbReleaseWait;
    % Wait for subject to press 'esc' to exit the introduction:
    while 1
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('esc'))
            break
        end
    end
    % Finish the introduction:
    PsychPortAudio('Close' ,pahandle);
    clearvars pahandle;
    KbReleaseWait;
    KbQueueStop;
    
end

