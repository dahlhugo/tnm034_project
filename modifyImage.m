function modifiedImage = modifyImage(inputImage, leftEyePos, rightEyePos)
    % Function made for rotating and cropping every image for 
    % better feature extraction. 

    % Calculate the angle of rotation needed
    theta = atan2(rightEyePos(2) - leftEyePos(2), rightEyePos(1) - leftEyePos(1)) * 180 / pi;
    %modifiedImage = imrotate(inputImage, theta, 'bicubic', 'loose');

    % NOTE!! rotateAround() is made by Jan Motl (jan@motl.us), see
    % 'externfucntions' --> 'license.txt' for more information on usage
    % rights.
    modifiedImage = rotateAround(inputImage, leftEyePos(2), leftEyePos(1), theta, 'bicubic');

    % --- Crop image --- % 
    % Calculate the distance between the left and right eyes to determine the width
    hyp = norm(leftEyePos - rightEyePos);
    
    % Calculate the center point between the eyes
    middle = leftEyePos + [hyp/2, 0];
    
    % Calculate the top-left corner of the cropped region
    LtopConor = middle + [hyp * -0.80, -hyp * 0.5];
    
    % Calculate the bottom-right corner of the cropped region
    RDownConor = middle + [hyp * 0.90, hyp * 1.5];
    
    % Crop the image using the calculated region and resize it to a fixed size (400x300)
    modifiedImage = imresize(imcrop(modifiedImage, [LtopConor RDownConor - LtopConor]), [400, 300]);

end