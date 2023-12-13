function modifyDB1Images()

    folder = './DB1';
    files = dir(fullfile(folder, '*.jpg'));
    
    % Initialize cell arrays
    allImages = cell(1, numel(files));
    modifiedImages = cell(1, numel(files));
    eyeMaps = cell(1, numel(files));
    mouthMaps = cell(1, numel(files));
    combinedMaps = cell(1, numel(files));
    
    % New initialize cell arrays
    eyeMaps2 = cell(1, numel(files));
    mouthMaps2 = cell(1, numel(files));
    
    figure;
    
    for i = 1:numel(files)
        % Read and store image 
        filename = fullfile(folder, files(i).name);
        image = imread(filename);
        
        % Normalize the RGB in the image
        image_corr = colorNormalizationRGB(image);
        allImages{i} = image_corr; % save normalized image to array
    
        rgbImage = allImages{i};
        YCrCb = ConvertRGB2YCrCb(rgbImage); 
    
        % First map detection calls for the image
        eyeMap = eyeDetection(YCrCb);
        mouthMap = mouthDetection(YCrCb);
        
        % Store mapped eyes and mouth for first eye- mouuth detection
        eyeMaps{i} = eyeMap;
        mouthMaps{i} = mouthMap;
        
        % Insert markers into the image
        [leftEyePos, rightEyePos, mouthPos] = drawLine(eyeMap, mouthMap);
    
        % DON'T COMMENT OUT - WILL CRASH! (image 12 has no left eye) % 
        if isempty(leftEyePos) || isempty(rightEyePos) || isempty(mouthPos)
             % Handle the case where positions are empty or detection failed
             disp(['Processing failed for image ', num2str(i)]);
             continue; % Skip to the next iteration
        end
    
        % Rotates image and crops into [400, 300] size
        modifiedImage = modifyImage(rgbImage, leftEyePos, rightEyePos);
    
        % Calc the locations of the eye and mouth coordinates again
        fixedImage = ConvertRGB2YCrCb(modifiedImage);
    
        % Secound eye and mouth detection for gathering the new 
        % coordinates after rotation
        eyeMap2 = eyeDetection2(fixedImage);
        mouthMap2 = mouthDetection2(fixedImage);
        
        % Stores the secound and final eye- mouth maps
        eyeMaps2{i} = eyeMap2;
        mouthMaps2{i} = mouthMap2;
        
        % Get the positions for the eyes and mouth
        [updatedLeftEyePos, updatedRightEyePos, updatedMouthPos] = drawLine(eyeMap2, mouthMap2);
        markerPositions = [updatedLeftEyePos; updatedRightEyePos; updatedMouthPos];
    
        % Markings on the output image with the recivied positions
        endImage = insertMarker(modifiedImage, markerPositions, 'color', 'red', size = 20);
        
        %Store modified image in cell array
        modifiedImages{i} = endImage;
        
        % Displaying the images from part one with maps and resulting images! %
        %displayImagesPart1(eyeMaps, i, mouthMaps, modifiedImages, rgbImage);
    
        save("images.mat","modifiedImages")
    end

end