folder = './DB1';
files = dir(fullfile(folder, '*.jpg'));

% Initialize cell arrays
allImages = cell(1, numel(files));
modifiedImages = cell(1, numel(files));
eyeMaps = cell(1, numel(files));
mouthMaps = cell(1, numel(files));
skinMaps = cell(1, numel(files));
combinedMaps = cell(1, numel(files));
skinEyeMaps = cell(1, numel(files));  % Added for storing combined skin and eye maps

figure;

for i = 1:numel(files)
    filename = fullfile(folder, files(i).name);
    image = imread(filename);
    
    allImages{i} = image;
    
    RGB = allImages{i};
    YCrCb = ConvertRGB2YCrCb(RGB); 

    skinMask = skinDetection(RGB, YCrCb); 

    eyeMap = eyeDetection(YCrCb);
    mouthMap = mouthDetection(YCrCb);

    % Combine all maps into one map of the face
    skinmask_in = imcomplement(skinMask); % complement of the skinMap
    eyeSkinMap = eyeMap - skinmask_in;
    mouthSkinMap = mouthMap - skinmask_in;
    eyeMaps{i} = eyeMap;
    mouthMaps{i} = mouthMap;
    skinEyeMaps{i} = eyeSkinMap;
   
    % Insert markers into the image
    [leftEyePos, rightEyePos, mouthPos, detectionSuccess] = drawLine(eyeSkinMap, mouthSkinMap);
    
    % Concatenate eye and mouth positions into a 2D array
    markerPositions = [leftEyePos; rightEyePos; mouthPos];
    
    RGB = insertMarker(RGB, markerPositions, 'color', 'yellow', 'size', 15);

    % Store modified image in cell array
    modifiedImages{i} = RGB;
end

% Display images
for i = 1:numel(files)
    % Display the combined skin eyemap
    subplot(1, 3, 1);
    imshow(eyeMaps{i});
    title('Eye Map');

    % Display the combined skin mouthmap
    subplot(1, 3, 2);
    imshow(mouthMaps{i});
    title('Mouth Map');

    % Display modified image with the red crosses
    subplot(1, 3, 3);
    imshow(modifiedImages{i});
    title('Modified Image with Red Crosses');

    % Add a pause between each image
    pause(2);
end
