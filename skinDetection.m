function skinMask = skinDetection(RGB, YCrCb)

    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);
    
    Y = YCrCb(:,:,1);
    Cb = YCrCb(:,:,2);
    Cr = YCrCb(:,:,3);
    
    %fprintf('Cr: min=%d, max=%d\n', min(Cr(:)), max(Cr(:)));
    
    diffForR = (max(R(:)) - min(R(:)));
    diffForG = (max(G(:)) - min(G(:)));
    diffForB = (max(B(:)) - min(B(:)));
    
% 90<Y<180, 90<Cr<130, 80<Cb<150 from "An Efficient Face Detection in Color Images Using
%Eye Mouth Triangular Approach"
skinMask = (R > 95) & (G > 40) & (B > 20) & (R > G) & (R > B) & ((80 < Cb) < 150) & ((90 < Y) < 180)& (abs(R - G) > 15) & (diffForR > 135) & (diffForG > 135) & (diffForB > 135) & ((80 < Cr) < 130) & (Cb > 85) & (Cr <= ((1.5862 * Cb) + 20)) & (Cr >= ((0.3448 * Cb) + 76.2069)) & (Cr <= ((-1.15 * Cb) + 301.75));
    
    % Check if there are any ones in the skinMask
    if any(skinMask(:))
        disp('At least one pixel classified as skin (white) in the skin mask.');
    else
        disp('No pixels classified as skin in the skin mask.');
    end
    
    
    % ... is used to break line without breaking without breaking code.
    % Creating a binary mask with the conditions for skin used in the paper.

%    skinMask = (R > 95) & (G > 40) & (B > 20) & (R > G) & (R > B) & ...
%        (abs(R - G) > 15) & ((max(R, max(G, B)) - min(R, min(G, B))) > 135);% & ...
%         (YCrCb(:,:,2) > 135) & (YCrCb(:,:,3) > 85) & (YCrCb(:,:,1) > 80) & ...
%         (YCrCb(:,:,2) <= 1.5862 * YCrCb(:,:,3) + 20) & ...
%         (YCrCb(:,:,2) >= 0.3448 * YCrCb(:,:,3) + 76.2069) & ...
%         (YCrCb(:,:,2) >= -4.5652 * YCrCb(:,:,3) + 234.5652) & ...
%         (YCrCb(:,:,2) <= -1.15 * YCrCb(:,:,3) + 301.75) & ...
%         (YCrCb(:,:,2) >= -2.2857 * YCrCb(:,:,3) + 432.85);

    % Creates a structuring element. https://www.mathworks.com/help/images/structuring-elements.html
    % disk = the shape, 5 = radius of 5 pixels
    se = strel('disk', 2);
    %skinMask = imopen(skinMask, se);    % Erosion followed by dilation
    %skinMask = imclose(skinMask, se);   % Dilation followed by erosion 
    
    
    skinMask = imdilate(skinMask, se);
    
    % Creating a contour with the exterior boundaries of the object. https://se.mathworks.com/help/images/ref/bwboundaries.html
    %contour = bwboundaries(skinMask);
    
    % regionprops can return "Area", "Centroid", and "BoundingBox". Here we
    % are interested in the area of each connected region
    %regionProperties = regionprops(skinMask, 'Area'); % Area of each connected region
    %area = [regionProperties.Area]; %
end