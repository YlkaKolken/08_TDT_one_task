function TDT

%% TDT selection file.

% Run this function simply by calling "TDT;"
% The function lets you choose to run any of the 4 TDT related functions.


%% Get parameters through GUI.


str = {'Introduction','Initial Training','Threshold Training',...
       'Threshold Training Analysis'};

[Selection,~] = listdlg('PromptString','Select a file:',...
                        'SelectionMode','single',...
                        'ListString',str);

if isempty(Selection)
    return
end

switch Selection

    case 1
        TDT_Intro;
    case 2
        TDT_Initial_Training;
    case 3
        TDT_Threshold_Training;
    case 4
        TDT_Threshold_Training_Analysis;
end

end