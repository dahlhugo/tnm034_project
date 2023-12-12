function [rotatedImage, updatedLeftEyePos, updatedRightEyePos, updatedMouthPos] = rotateImage(image,leftEyePos, rightEyePos, mouthPos)
    % Check if eye positions are valid
    if isempty(leftEyePos) || isempty(rightEyePos) || isempty(mouthPos)
        disp('Invalid eye or mouth positions.');
        rotatedImage = image;
        updatedLeftEyePos = [];
        updatedRightEyePos = [];
        updatedMouthPos = [];
        return;
    end



    % Calculate the angle of rotation needed
    theta = atan2(rightEyePos(2) - leftEyePos(2), rightEyePos(1) - leftEyePos(1)) * 180 / pi;

    % Create a rotation matrix
    tform = affine2d([cosd(theta) -sind(theta) 0; ...
                    sind(theta) cosd(theta) 0; ...
                    0 0 1]);

    % Apply the rotation to the image
    rotatedImage = imwarp(image, tform);   

    % Update the coordinates for the eyes in the image
    % transformPointsForward applies the forward geometric transformation 
    updatedLeftEyePos = transformPointsForward(tform, leftEyePos);
    updatedRightEyePos = transformPointsForward(tform, rightEyePos);
    updatedMouthPos = transformPointsForward(tform, mouthPos);

    % Applying translation
    translation = (leftEyePos - updatedLeftEyePos);
    tformTranslation = affine2d([1 0 0; ...
                                 0 1 0; ...
                                 translation(1) translation(2) 1]);

    % Update image and coordinates
    rotatedImage = imwarp(rotatedImage, tformTranslation);
 

end