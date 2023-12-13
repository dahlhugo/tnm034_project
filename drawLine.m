function [leftEyePos, rightEyePos, mouthPos] = drawLine(eyeMap, mouthMap)

    % Find and count connected components in eyeMap
    CC = bwconncomp(eyeMap);
    % Measures properties for each connected component 
    % in CC, which is a structure returned by bwconncomp
    statsEye = regionprops(CC, 'PixelList');
    
    % Makes sure image do not contain less stan 2 eyes
    if numel(statsEye) < 2
        % Insufficient eye regions detected, return empty array
        leftEyePos = [];
        rightEyePos = [];
        mouthPos = [];
        return;
    end
    
    % Sort eyes based on x-coordinates
    % cellfun applys function to every cell in the array
    % It calculates the mean of x-coordinates for each 
    % connected component's PixelList and sorts the result 

    % The '~' is used to discard the sorted values, as only the indices are needed
    [~, sortedIdxEyes] = sort(cellfun(@(x) mean(x(:, 1)), {statsEye.PixelList}));
    
    % Returns the number of elements in the statsEye array
    statsEye = statsEye(sortedIdxEyes);
    
    % Assuming there are two eyes, 
    % Calculate the mean position of pixels for 
    % the first and second connected components
    leftEyePos = mean(statsEye(1).PixelList);
    rightEyePos = mean(statsEye(2).PixelList);
    
    % Find and count connected components in mouthMap
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
end
