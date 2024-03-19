function Cross = TDT_Cross(Parameters)

    % Create a cross-fixation image:
    % The matrix size is [H X W], which is the screen size, the cross'
    % length is 'r', and the cross' width is 'd'.
    % The background color and cross color are given by the parameters
    % 'BackgroundColor' & 'StimuliColor'.
    
    H = Parameters.H;
    W = Parameters.W;
    d = Parameters.CrossWidth;
    r = Parameters.CrossLength;
    Cross = Parameters.BackgroundColor*ones(H,W);
    point = round([H/2-r/2,W/2-d/2]);
    Cross(point(1):point(1)+r-1,point(2):point(2)+d-1) = Parameters.StimuliColor;
    point = round([H/2-d/2,W/2-r/2]);
    Cross(point(1):point(1)+d-1,point(2):point(2)+r-1) = Parameters.StimuliColor;
    
end