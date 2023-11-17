function [contour, area] = skinDetection(RGB, YCrCb)

    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);
    
    % ... is used to break line without breaking without breaking code.
    % Creating a binary mask with the conditions for skin used in the paper.

    skinMask = (R > 95) & (G > 40) & (B > 20) & (R > G) & (R > B) & ...
        (abs(R - G) > 15) & ((max(R, max(G, B)) - min(R, min(G, B))) > 135) & ...
        (YCrCb(:,:,2) > 135) & (YCrCb(:,:,3) > 85) & (YCrCb(:,:,1) > 80) & ...
        (YCrCb(:,:,2) <= 1.5862 * YCrCb(:,:,3) + 20) & ...
        (YCrCb(:,:,2) >= 0.3448 * YCrCb(:,:,3) + 76.2069) & ...
        (YCrCb(:,:,2) >= -4.5652 * YCrCb(:,:,3) + 234.5652) & ...
        (YCrCb(:,:,2) <= -1.15 * YCrCb(:,:,3) + 301.75) & ...
        (YCrCb(:,:,2) >= -2.2857 * YCrCb(:,:,3) + 432.85);
    % Creates a structuring element. https://www.mathworks.com/help/images/structuring-elements.html
    % disk = the shape, 5 = radius of 5 pixels
    se = strel('disk', 5);
    skinMask = imopen(skinMask, se);    % Erosion followed by dilation
    skinMask = imclose(skinMask, se);   % Dilation followed by erosion 
    
    % Creating a contour with the exterior boundaries of the object. https://se.mathworks.com/help/images/ref/bwboundaries.html
    contour = bwboundaries(skinMask);
    
    % regionprops can return "Area", "Centroid", and "BoundingBox". Here we
    % are interested in the area of each connected region
    regionProperties = regionprops(skinMask, 'Area'); % Area of each connected region
    area = [regionProperties.Area]; %
end