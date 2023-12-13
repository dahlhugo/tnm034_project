function EyeMapThresholded = eyeDetection(YCrCb)

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
    radius = 9; % 9 is the smallest it can be
    se = strel('disk', radius);
    % Apply the kernel, here se, to the luminance component
    dilationY = imdilate(Y, se);
    erosionY = imerode(Y, se);

    % Luminance map
    EyeMapL = dilationY ./ (erosionY + 1);

    EyeMap = EyeMapL .* EyeMapC;

    threshold = 0.3; % Tweak if needed, 0.5 worked fine
    EyeMapThresholded = (EyeMap > threshold);

    EyeMapThresholded = imdilate(EyeMapThresholded, se);
    EyeMapThresholded = imdilate(EyeMapThresholded, se);
    EyeMapThresholded = imerode(EyeMapThresholded, se);
    EyeMapThresholded = imdilate(EyeMapThresholded, se);
    EyeMapThresholded = imerode(EyeMapThresholded, se);

    % Remove small and large regions from the binary mask
    minArea = 100; % Adjust as needed
    maxArea = 3000; % Adjust as needed

    EyeMapThresholded = bwareaopen(EyeMapThresholded, minArea);
    EyeMapThresholded = bwareafilt(EyeMapThresholded, [minArea, maxArea]);

    % Get image dimensions
    [height, width] = size(EyeMapThresholded);

    % Label connected components in the binary mask
    labeledMask = bwlabel(EyeMapThresholded);

    % Remove regions outside the specified range
    for i = 1:max(labeledMask(:))
        regionProperties = regionprops(labeledMask == i, 'Centroid');
        centroidX = regionProperties.Centroid(1);
        centroidY = regionProperties.Centroid(2);

        % Define ranges for the middle of the image (adjust as needed)
        middleRangeX = [width*0.2, width*0.7];
        middleRangeY = [height*0.4, height*0.5];

        % Check if the centroid is outside the middle range
        if centroidX < middleRangeX(1) || centroidX > middleRangeX(2) || ...
           centroidY < middleRangeY(1) || centroidY > middleRangeY(2)
            EyeMapThresholded(labeledMask == i) = 0;
        end
    end
   
end
