%% Part 1

% Conditions for color to be viewed as skin
RGB = imread('image.jpeg');
YCrCb = convertRGB2YCrCb(RGB);

[contour, area] = skinDetection(RGB, YCrCb);

eyeLocation = eyeDetection(YCrCb, contour, area);

mouthLocation = mouthDetection(YCrCb, contour, area);

if(length(eyeLocation) >= 2 && length(mouthLocation) >= 1)
    %if yes
    if(faceConfirmation(eyeLocation, mouthLocation) == 1)
        %if yes
        if(output = drawLine(RGB, eyeLocation, mouthLocation))
            %if yes
        end %finish
    end
end