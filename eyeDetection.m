function eyeMap = eyeDetection(YCrCb)

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
    radius = 9; % Can be changed but not recommended
    se = strel('disk', radius);

    % Apply the kernel, here se, to the luminance component
    dilationY = imdilate(Y, se);
    erosionY = imerode(Y, se);

    % Luminance map
    eyeMapL = dilationY ./ (erosionY + 1);

    % Combine the maps to one EyeMap
    eyeMap = eyeMapL .* EyeMapC;

    threshold = 0.332; % Can be changed but not recommended
    eyeMap = (eyeMap > threshold);

    eyeMap = imdilate(eyeMap, se);
    eyeMap = imdilate(eyeMap, se);
    eyeMap = imerode(eyeMap, se);
    eyeMap = imdilate(eyeMap, se);
    eyeMap = imerode(eyeMap, se);

    % Remove small and large regions from the binary mask
    minArea = 100;  % Adjust as needed, but ok as it is!
    maxArea = 5000; % Adjust as needed, but ok as it is!

    eyeMap = bwareaopen(eyeMap, minArea);
    eyeMap = bwareafilt(eyeMap, [minArea, maxArea]);

    % Get image dimensions
    [height, width] = size(eyeMap);

    % Label connected components in the binary mask
    labeledMask = bwlabel(eyeMap);

    % Remove regions outside the set range
    for i = 1:max(labeledMask(:))
        regionProperties = regionprops(labeledMask == i, 'Centroid');
        centroidX = regionProperties.Centroid(1);
        centroidY = regionProperties.Centroid(2);

        % Define ranges for the middle of the image
        middleRangeX = [width*0.1555, width*0.8];
        middleRangeY = [height*0.4, height*0.5];

        % Check if the centroid is outside the middle range, if so set 
        % pixel value to 0
        if centroidX < middleRangeX(1) || centroidX > middleRangeX(2) || ...
           centroidY < middleRangeY(1) || centroidY > middleRangeY(2)
            eyeMap(labeledMask == i) = 0;
        end
    end
end
