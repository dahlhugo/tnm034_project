function mouthMap = mouthDetection(YCrCb)
   
    Cb = double(YCrCb(:,:,2));
    Cr = double(YCrCb(:,:,3));

    % Use the paper's formula for eta
    eta = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));
    mouthMapFormula = Cr.^2 .* (Cr.^2 - eta * Cr./Cb).^2;

    % Make it binary.
    mouthMapFormula = (mouthMapFormula - min(mouthMapFormula(:))) / (max(mouthMapFormula(:)) - min(mouthMapFormula(:)));
    threshold = 0.4; % Can be tweaked
    
    mouthMap = mouthMapFormula > threshold;
    SE = strel('disk', 10);
    mouthMap = imclose(mouthMap, SE);
    mouthMap = imclearborder(mouthMap);

    % Remove small and large regions from the binary mask
    minArea = 50; % Adjust as needed
    maxArea = 2000; % Adjust as needed

    mouthMap = bwareaopen(mouthMap, minArea);
    mouthMap = bwareafilt(mouthMap, [minArea, maxArea]);

        % Get image dimensions
    [height, width] = size(mouthMap);

    % Label connected components in the binary mask
    labeledMask = bwlabel(mouthMap);

    % Remove regions outside the specified range
    for i = 1:max(labeledMask(:))
        regionProperties = regionprops(labeledMask == i, 'Centroid');
        centroidX = regionProperties.Centroid(1);
        centroidY = regionProperties.Centroid(2);

        % Define ranges for the middle-bottom of the image (adjust as needed)
        middleRangeX = [width*0.3, width*0.7];
        middleRangeY = [height*0.6, height*0.8];

        % Check if the centroid is outside the middle-bottom range
        if centroidX < middleRangeX(1) || centroidX > middleRangeX(2) || ...
           centroidY < middleRangeY(1) || centroidY > middleRangeY(2)
            mouthMap(labeledMask == i) = 0;
        end
    end
end