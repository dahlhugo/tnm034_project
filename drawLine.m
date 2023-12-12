function [leftEyePos, rightEyePos, mouthPos] = drawLine(eyeMap, mouthMap)

    % Detect eyes
    CC = bwconncomp(eyeMap);
    statsEye = regionprops(CC, 'PixelList');
    
    if numel(statsEye) < 2
        % Insufficient eye regions detected
        leftEyePos = [];
        rightEyePos = [];
        mouthPos = [];
        return;
    end
    
    % Sort eyes based on x-coordinates
    [~, sortedIdxEyes] = sort(cellfun(@(x) mean(x(:, 1)), {statsEye.PixelList}));
    statsEye = statsEye(sortedIdxEyes);
    
    % Assuming there are two eyes
    leftEyePos = mean(statsEye(1).PixelList);
    rightEyePos = mean(statsEye(2).PixelList);
    
    % Detect mouth
    CC = bwconncomp(mouthMap);
    statsMouth = regionprops(CC, 'PixelList');
    
    if numel(statsMouth) < 1
        % No mouth detected
        leftEyePos = [];
        rightEyePos = [];
        mouthPos = [];
        return;
    end
    
    % Assuming there is one mouth
    mouthPos = mean(statsMouth(1).PixelList);
    

    % %eyeMap = logical(eyeMap);
    % 
    % % Get eye candidates
    % statsEye = regionprops('table', eyeMap, 'centroid', 'MaxFeretProperties');
    % eyeCentroids = cat(1, statsEye.Centroid);
    % [m, ~] = size(eyeCentroids);
    % 
    % if m < 2
    %     % Insufficient eyes found
    %     return;
    % end
    % 
    % % Get mouth candidates
    % statsMouth = regionprops('table', mouthMap, 'centroid', 'MaxFeretProperties');
    % mouCentroids = cat(1, statsMouth.Centroid);
    % [m, ~] = size(mouCentroids);
    % 
    % if m == 0
    %      % No mouth found
    %     return;
    % end
    % 
    % % Set the y-distance threshold max and min
    % yDistanceThresholdMax = 200;
    % yDistanceThresholdMin = 100;
    % 
    % % Set additional constraints
    % maxAngleLeft = -50; % Maximum allowed angle to the left of the mouth
    % maxAngleRight = 50; % Maximum allowed angle to the right of the mouth
    % 
    % % Detect the eyes
    % 
    % % Find left eye
    % [~, leftEyeIdx] = min(eyeCentroids(:, 1));
    % leftEyePos = eyeCentroids(leftEyeIdx, :);
    % 
    % % Find right eye
    % eyeCentroids(leftEyeIdx, :) = [];  % Remove left eye
    % [~, rightEyeIdx] = max(eyeCentroids(:, 1));
    % rightEyePos = eyeCentroids(rightEyeIdx, :);
    % 
    % % Check if the eyes are at the desired y-distance from the mouth
    % if (abs(leftEyePos(2) - mouCentroids(2)) < yDistanceThresholdMax && ...
    %    abs(leftEyePos(2) - mouCentroids(2)) > yDistanceThresholdMin && ...
    %    abs(rightEyePos(2) - mouCentroids(2)) < yDistanceThresholdMax && ...
    %    abs(rightEyePos(2) - mouCentroids(2)) > yDistanceThresholdMin && ...
    %    leftEyePos(1) < mouCentroids(1) + maxAngleRight && ...
    %    leftEyePos(1) > mouCentroids(1) - maxAngleLeft && ...
    %    rightEyePos(1) < mouCentroids(1) + maxAngleRight && ...
    %    rightEyePos(1) > mouCentroids(1) - maxAngleLeft)
    % 
    %     detectionSuccess = true;
    % end
    % 
    % % Return the mouth position
    % mouthPos = mouCentroids;
end
