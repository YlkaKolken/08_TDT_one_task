function Circle = TDT_Circle(Parameters)

    % Create a circle-fixation image:
    % The matrix size is [H X W], which is the screen size, the circle's
    % radius is 'r', and the circle's width is 'd'.
    % The background color and circle color are given by the parameters
    % 'BackgroundColor' & 'StimuliColor'.
    
    H = Parameters.H;
    W = Parameters.W;
    d = Parameters.CircleWidth;
    r = Parameters.CircleRadius;
    Circle = Parameters.BackgroundColor*ones(H,W);
    center = round([H/2,W/2]);
    for i = 1:H
        for j = 1:W
            if (r-d/2)^2<((i-center(1))^2+(j-center(2))^2) && ((i-center(1))^2+(j-center(2))^2)<(r+d/2)^2
                Circle(i,j) = Parameters.StimuliColor;
            end
        end
    end
    
end
