function align = alignment(combinedMap, referenceCoordinates, targetCoordinates, referenceSize)
        
    % FIX so the image is zoomed in at the eyes and mouth aswell! 
    
    % Calculate translation, rotation, and scaling parameters
    translation = mean(referenceCoordinates) - mean(targetCoordinates);
    rotation = atan2(size(combinedMap, 1) / 2, size(combinedMap, 2) / 2) * 180 / pi;
    scaling = sqrt(sum((referenceCoordinates(2, :) - referenceCoordinates(1, :)).^2)) / ...
              sqrt(sum((targetCoordinates(2, :) - targetCoordinates(1, :)).^2));

    % Use the specified reference size for the output
    outputSize = referenceSize;

    % Create the 2D linear transformation to the binary map with specified output size 
    tform = affine2d([scaling*cosd(rotation) -scaling*sind(rotation) 0; ...
                     scaling*sind(rotation) scaling*cosd(rotation) 0; ...
                     translation 1]);
    
    % Preformes the alignment 
    align = imwarp(combinedMap, tform, 'OutputView', imref2d(outputSize));
    
end