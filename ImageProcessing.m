function img = ImageProcessing(imagePath)
     % Read and store image 
    
    image = imread(imagePath);
    
    % Normalize the RGB in the image
    image_corr = colorNormalizationRGB(image);
    allImages{1} = image_corr; % save normalized image to array

    rgbImage = allImages{1};
    YCrCb = ConvertRGB2YCrCb(rgbImage); 

    % First map detection calls for the image
    eyeMap = eyeDetection(YCrCb);
    mouthMap = mouthDetection(YCrCb);
    
    % Insert markers into the image
    [leftEyePos, rightEyePos, mouthPos] = drawLine(eyeMap, mouthMap);

    % DON'T COMMENT OUT - WILL CRASH! (image 12 has no left eye) % 
    % if isempty(leftEyePos) || isempty(rightEyePos) || isempty(mouthPos)
    %      % Handle the case where positions are empty or detection failed
    %      disp(['Processing failed for image ', num2str(i)]);
    %      continue; % Skip to the next iteration
    % end

    % Rotates image and crops into [400, 300] size
    modifiedImage = modifyImage(rgbImage, leftEyePos, rightEyePos);

    % Calc the locations of the eye and mouth coordinates again
    fixedImage = ConvertRGB2YCrCb(modifiedImage);

    % Secound eye and mouth detection for gathering the new 
    % coordinates after rotation
    eyeMap2 = eyeDetection2(fixedImage);
    mouthMap2 = mouthDetection2(fixedImage);
    
    % Get the positions for the eyes and mouth
    [updatedLeftEyePos, updatedRightEyePos, updatedMouthPos] = drawLine(eyeMap2, mouthMap2);
    markerPositions = [updatedLeftEyePos; updatedRightEyePos; updatedMouthPos];

    % Markings on the output image with the recivied positions
    endImage = insertMarker(modifiedImage, markerPositions, 'color', 'red', size = 20);
    
    %Store modified image in cell array
   img = endImage;

end