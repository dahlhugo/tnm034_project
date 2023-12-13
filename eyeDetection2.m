function EyeMap2 = eyeDetection2(YCrCb)

    % Chrominance component calculation
    Y = double(YCrCb(:,:,1));
    Cb = double(YCrCb(:,:,2));
    Cr = double(YCrCb(:,:,3));
  
    %Normalize (Cb^2), (Cr^2); and (Cb/Cr) 0-255
    Cb2_norm = normalize(Cb.^2, 'norm');
    Cb2_255_norm = normalize((Cb.^2)-1, 'norm');
    CbCr_norm = normalize((Cb./Cr), 'norm');
    % Chrominance map
    EyeMapC = (1/3) * (Cb2_norm + Cb2_255_norm + CbCr_norm);

    % Luminance component calculation
    radius = 9; 
    se = strel('disk', radius);
    
    % Apply the kernel, here se, to the luminance component
    dilationY = imdilate(Y, se);
    erosionY = imerode(Y, se);

    % Luminance map
    EyeMapL = dilationY ./ (erosionY + 1);

    EyeMap = EyeMapL .* EyeMapC;

    threshold = 0.38; % Tweak if needed, 0.5 worked fine
    EyeMap2 = (EyeMap > threshold);

    EyeMap2 = imdilate(EyeMap2, se);
    EyeMap2 = imdilate(EyeMap2, se);
    EyeMap2 = imerode(EyeMap2, se);
    EyeMap2 = imdilate(EyeMap2, se);
    EyeMap2 = imerode(EyeMap2, se);

    % Remove small and large regions from the binary mask
    minArea = 10; % Adjust as needed
    maxArea = 7000; % Adjust as needed

    EyeMap2 = bwareaopen(EyeMap2, minArea);
    EyeMap2 = bwareafilt(EyeMap2, [minArea, maxArea]);

    % Get image dimensions
    [height, width] = size(EyeMap2);

    % Label connected components in the binary mask
    labeledMask = bwlabel(EyeMap2);

    % Remove regions outside the specified range
    for i = 1:max(labeledMask(:))
        regionProperties = regionprops(labeledMask == i, 'Centroid');
        centroidX = regionProperties.Centroid(1);
        centroidY = regionProperties.Centroid(2);

        % Define ranges for the middle of the image (adjust as needed)
        middleRangeX = [width*0.1, width*0.9];
        middleRangeY = [height*0.1, height*0.5];

        % Check if the centroid is outside the middle range
        if centroidX < middleRangeX(1) || centroidX > middleRangeX(2) || ...
           centroidY < middleRangeY(1) || centroidY > middleRangeY(2)
            EyeMap2(labeledMask == i) = 0;
        end
    end
   
end
