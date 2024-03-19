function Image = TDT_Mask(Parameters)

    % Create a mask image:
    % The number of lines in each row is 'HL' and the number of lines in
    % each column is 'VL'.
    % The matrix size for each line is [m X n], therefore the full matrix
    % size is [m*VL X n*HL], though the full image will be [H X W].
    % The size of the fixation letter is given by LetterLength & LetterWidth. 
    % The background color and lines color are given by the parameters
    % 'BackgroundColor' & 'MaskColor'.
    % [H X W] is the size of the screen in pixels.
    
    % Define short names for all parameters for better understanding of
    % the code (shorter fomulas):
    m = Parameters.m;
    n = Parameters.n;
    VL = Parameters.VL;
    HL = Parameters.HL;
    LeL = Parameters.LetterLength;
    LeW = Parameters.LetterWidth;
    MC = Parameters.MaskColor;
    BC = Parameters.BackgroundColor;
    H = Parameters.H;
    W = Parameters.W;
    
    % Create a single 60-degrees angle from two lines:
    L1 = zeros(m,n);
    L2 = zeros(m,n);
    L1(round((31/40)*m):round((32/40)*m),round((10/45)*n):round((37/45)*n)) = MC;
    L2(round((20/40)*m):round((21/40)*m),round((10/45)*n):round((38/45)*n)) = MC;
    L2 = imrotate(L2,60,'bilinear','crop');
    for i = 1:round((1-(6/45))*n)
        L2(:,i) = L2(:,i+round((6/45)*n));
    end
    LL = L1+L2;
    LL(LL>MC) = MC;
    
    % Create the center 'F' letter:
    Center_F = zeros(m,n);
    point = [round(0.5*(m-LeL));round(0.5*(n-LeW))];
    Center_F(point(1):point(1)+LeL,point(2):point(2)+LeW-1) = MC;
    Center_F(point(1):point(1)+LeW-1,point(1):point(1)+LeL) = MC;
    Center_F(point(1):point(1)+LeL,point(1):point(1)+LeW-1) = MC;
    
    Image = zeros(m*VL,n*HL); % Create the full image.
    
    % Duplicate the angles and rotate them randomally:
    for i = 0:VL-1
        for j = 0:HL-1
            Image(m*i+1:m*(i+1),n*j+1:n*(j+1)) = imrotate(LL,randi(360),'bilinear','crop');
        end
    end
    
    % Place the center 'F' letter in the center and rotate it randomally:
    i = floor(VL/2);  j = floor(HL/2);
    Image(m*i+1:m*i+m,n*j+1:n*j+n) = imrotate(Center_F,randi(360),'bilinear','crop');
    
    % Add pixel to image to match screen size and set background color:
    Image = padarray(Image,[round((H-size(Image,1))/2),round((W-size(Image,2))/2)]);
    Image(Image<BC) = BC;
    
end