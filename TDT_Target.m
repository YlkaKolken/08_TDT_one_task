function Image = TDT_Target(Parameters,Fix,Ali)

    % Create a target image:
    % The number of lines in each row is 'HL' and the number of lines in
    % each column is 'VL'.
    % The matrix size for each line is [m X n], therefore the full matrix
    % size is [m*VL X n*HL], though the full image will be [H X W].
    % The fixation letter in the center is either 'T' for 'Fix'=84 or 'L'
    % for 'Fix'=76.
    % The target orientation is either horizontal for 'Ali'=45 or vertical
    % for 'Ali'=124.
    % The size of each background line is given by LineLength & LineWidth.
    % The size of each target line is given by TargetLength & Target Width.
    % The size of the fixation letter is given by LetterLength & LetterWidth. 
    % The jitter parameters define how many pixel each line is allowed to
    % shift from its original location for the jitterring effect. There are
    % parameters for the horizontal and for the vertical jitters.
    % The background color and lines color are given by the parameters
    % 'BackgroundColor' & 'StimuliColor'.
    % [H X W] is the size of the screen in pixels.
    % TargetOffset is the position of the target within the lines matrix.
    % The center is defined as the zero position, while right and down is
    % positive and left and up are negative. The first entry is horizontal
    % offset and the second entry is the vertical offset.
    
    % Define short names for all parameters for better understanding of
    % the code (shorter fomulas):
    m = Parameters.m;
    n = Parameters.n;
    LeL = Parameters.LetterLength;
    LeW = Parameters.LetterWidth;
    LiL = Parameters.LineLength;
    LiW = Parameters.LineWidth;
    TL = Parameters.TargetLength;
    TW = Parameters.TargetWidth;
    VL = Parameters.VL;
    HL = Parameters.HL;
    Vj = Parameters.Vjitter;
    Hj = Parameters.Hjitter;
    SC = Parameters.StimuliColor;
    BC = Parameters.BackgroundColor;
    W = Parameters.W;
    H = Parameters.H;
    TO = Parameters.TargetOffset;
    
    % Create the fixation letter:
    Center = zeros(m,n);
    point = [round(0.5*(m-LeL));round(0.5*(n-LeW))];
    if Fix == 84
        Center(point(1):point(1)+LeL,point(2):point(2)+LeW-1) = SC;
        Center(point(1):point(1)+LeW-1,point(1):point(1)+LeL) = SC;
    else
        Center(point(1):point(1)+LeL,point(1):point(1)+LeW-1) = SC;
        Center(point(1):point(1)+LeW-1,point(1):point(1)+LeL) = SC;
    end
    
    % Create a single line:
    Target = zeros(m,n);
    Target(round((19/40)*m):round((19/40)*m)+TW-1,round((7/45)*n):round((7/45)*n)+TL-1) = SC;
    Image = zeros(m*VL,n*HL); % Create the full image.
    
    % Duplicate the lines and jitter them randomally:
    for i = 0:VL-1
        for j = 0:HL-1
            r1 = randi(Vj*2+1)-Vj-1;
            r2 = randi(Hj*2+1)-Hj-1;
            if Parameters.Orientation=='-'
                Image(m*i+round((19/40)*m)+r1:m*i+round((19/40)*m)+r1+LiW-1,n*j+round((7/45)*n)+r2:n*j+round((7/45)*n)+r2+LiL-1) = SC;
            else
                Image(n*j+round((7/45)*n)+r2:n*j+round((7/45)*n)+r2+LiL-1,m*i+round((19/40)*m)+r1:m*i+round((19/40)*m)+r1+LiW-1) = SC;
            end
        end
    end
    
    i = floor(VL/2);  j = floor(HL/2);
    % Place the fixation letter in the center of the image and rotate it in
    % a random way:
    Image(m*i+1:m*i+m,n*j+1:n*j+n) = imrotate(Center,randi(360),'bilinear','crop');
    
    % Place the target in the position defined by TargetOffset:
    if Ali==45
        i = floor(VL/2)+TO(2);
        for j = floor(HL/2)+TO(1)-1:floor(HL/2)+TO(1)+1
            Image(m*i+1:m*i+m,n*j+1:n*j+n) = imrotate(Target,135,'bilinear','crop');
        end
    else
        j = floor(HL/2)+TO(1);
        for i = floor(VL/2)+TO(2)-1:floor(VL/2)+TO(2)+1
            Image(m*i+1:m*i+m,n*j+1:n*j+n) = imrotate(Target,135,'bilinear','crop');
        end
    end
    
    % Add pixel to image to match screen size and set background color:
    Image = padarray(Image,[round((H-size(Image,1))/2),round((W-size(Image,2))/2)]);
    Image(Image<BC) = BC;

end