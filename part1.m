%% Part 1

folder = '/Users/sebastianlindgren/Documents/Fork_Projects/tnm034_project/DB1'; % Replace this with the path to your folder
files = dir(fullfile(folder, '*.jpg'));

% Initialize a cell array to hold the images
allImages = cell(1, numel(files));

for i = 1:numel(files)
    filename = fullfile(folder, files(i).name);
    image = imread(filename);
    
    % Store the image in the cell array
    allImages{i} = image;

% Now, allImages is a cell array containing all the images
% Access individual images using allImages{1}, allImages{2} ...

YCrCb = convertRGB2YCrCb(image);

[contour, area] = skinDetection(RGB, YCrCb);

eyeLocation = eyeDetection(YCrCb);

mouthLocation = mouthDetection(YCrCb, i);

    if(faceConfirmation(eyeLocation, mouthLocation) == 1)
        %if yes
        if(drawLine(RGB, eyeLocation, mouthLocation))
            %if yes
        end %finish
    end
end