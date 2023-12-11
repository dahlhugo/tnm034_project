function [leftEyePos, rightEyePos, mouthPos, detectionSuccess] = drawLine(eyeSkinMap, mouthSkinMap)

    % Initialize detection success flag
    detectionSuccess = false;

    eyeSkinMap = logical(eyeSkinMap);

    % Get eye candidates
    statsEye = regionprops('table', eyeSkinMap, 'centroid', 'MaxFeretProperties');
    eyeCentroids = cat(1, statsEye.Centroid);
    [m, ~] = size(eyeCentroids);
    
    if m < 2
        % Insufficient eyes found
        return;
    end

    % Get mouth candidates
    statsMouth = regionprops('table', mouthSkinMap, 'centroid', 'MaxFeretProperties');
    mouCentroids = cat(1, statsMouth.Centroid);
    [m, ~] = size(mouCentroids);
    
    if m == 0
        % No mouth found
        return;
    end

    % Set the y-distance threshold max and min
    yDistanceThresholdMax = 200;
    yDistanceThresholdMin = 100;

    % Set additional constraints
    maxAngleLeft = -30; % Maximum allowed angle to the left of the mouth
    maxAngleRight = 30; % Maximum allowed angle to the right of the mouth

    % Detect the eyes

    % Find left eye
    [~, leftEyeIdx] = min(eyeCentroids(:, 1));
    leftEyePos = eyeCentroids(leftEyeIdx, :);

    % Find right eye
    eyeCentroids(leftEyeIdx, :) = [];  % Remove left eye
    [~, rightEyeIdx] = max(eyeCentroids(:, 1));
    rightEyePos = eyeCentroids(rightEyeIdx, :);

    % Check if the eyes are at the desired y-distance from the mouth
    if abs(leftEyePos(2) - mouCentroids(2)) < yDistanceThresholdMax && ...
       abs(leftEyePos(2) - mouCentroids(2)) > yDistanceThresholdMin && ...
       abs(rightEyePos(2) - mouCentroids(2)) < yDistanceThresholdMax && ...
       abs(rightEyePos(2) - mouCentroids(2)) > yDistanceThresholdMin && ...
       leftEyePos(1) < mouCentroids(1) + maxAngleRight && ...
       leftEyePos(1) > mouCentroids(1) - maxAngleLeft && ...
       rightEyePos(1) < mouCentroids(1) + maxAngleRight && ...
       rightEyePos(1) > mouCentroids(1) - maxAngleLeft

        detectionSuccess = true;
    end
    
    % Return the mouth position
    mouthPos = mouCentroids;
end
