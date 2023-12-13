function rotatedImage = rotateImage(image, leftEyePos, rightEyePos)

    % Calculate the angle of rotation needed
    theta = atan2(rightEyePos(2) - leftEyePos(2), rightEyePos(1) - leftEyePos(1)) * 180 / pi;
    % Rotate image based on the left eye position (imported function made by )
    rotatedImage = imrotate(image, theta, 'bicubic', 'loose');
    rotatedImage = rotateAround(image, leftEyePos(2), leftEyePos(1), theta, 'bicubic');

    %Crop image
    hyp = norm(leftEyePos-rightEyePos);
    center = leftEyePos + [hyp/2, 0];
    LtopConor = center + [hyp*-0.80, -hyp*0.5];
    Rbottom = center + [hyp*0.90, hyp*1.5];
    rotatedImage = imresize(imcrop(rotatedImage, [LtopConor Rbottom-LtopConor]), [400, 300]);
end