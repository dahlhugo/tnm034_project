function mouthMap2 = mouthDetection2(YCrCb)

    Cb = double(YCrCb(:,:,2));
    Cr = double(YCrCb(:,:,3));

    % Use the paper's formula for eta
    eta = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));
    mouthMapFormula = Cr.^2 .* (Cr.^2 - eta * Cr./Cb).^2;

    % Make it binary.
    mouthMapFormula = (mouthMapFormula - min(mouthMapFormula(:))) / (max(mouthMapFormula(:)) - min(mouthMapFormula(:)));
    threshold = 0.5; % Can be tweaked
    
    mouthMap2 = mouthMapFormula > threshold;
    SE = strel('disk', 11);
    mouthMap2 = imclose(mouthMap2, SE);
    mouthMap2 = imclose(mouthMap2, SE);
    %mouthMap2 = imclearborder(mouthMap2);

    % Remove small and large regions from the binary mask
    minArea = 100; % Adjust as needed
    maxArea = 7000; % Adjust as needed

    mouthMap2 = bwareaopen(mouthMap2, minArea);
    mouthMap2 = bwareafilt(mouthMap2, [minArea, maxArea]);

    % Get image dimensions
    [height, width] = size(mouthMap2);

    % Label connected components in the binary mask
    labeledMask = bwlabel(mouthMap2);

    % Remove regions outside the specified range
    for i = 1:max(labeledMask(:))
        regionProperties = regionprops(labeledMask == i, 'Centroid');
        centroidX = regionProperties.Centroid(1);
        centroidY = regionProperties.Centroid(2);

        % Define ranges for the middle-bottom of the image (adjust as needed)
        middleRangeX = [0, width];
        middleRangeY = [height*0.7, height];

        % Check if the centroid is outside the middle-bottom range
        if centroidX < middleRangeX(1) || centroidX > middleRangeX(2) || ...
           centroidY < middleRangeY(1) || centroidY > middleRangeY(2)
            mouthMap2(labeledMask == i) = 0;
        end
    end
   
end