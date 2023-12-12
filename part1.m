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
    
    image_corr = colorCorrectionRGB(image);
    allImages{i} = image_corr; % save corrected image to array

    RGB = allImages{i};
    YCrCb = ConvertRGB2YCrCb(RGB); 

    % detectioncalls
    skinMask = skinDetection(image_corr); 
    eyeMap = eyeDetection(YCrCb);
    mouthMap = mouthDetection(YCrCb);

    % Combine all maps into one map of the face
    skinmask_in = imcomplement(skinMask); % complement of the skinMap
    eyeSkinMap =  skinmask_in + eyeMap;
    mouthSkinMap =  skinMask - mouthMap;

    eyeMaps{i} = eyeMap;
    mouthMaps{i} = mouthMap;
    skinEyeMaps{i} = eyeSkinMap;
    skinMaps{i} = skinMask;
   
    % Insert markers into the image
    [leftEyePos, rightEyePos, mouthPos] = drawLine(eyeMap, mouthMap);

    % Concatenate eye and mouth positions into a 2D array
    if isempty(leftEyePos) || isempty(rightEyePos) || isempty(mouthPos)
         % Handle the case where positions are empty or detection failed
         disp(['Processing failed for image ', num2str(i)]);
         continue; % Skip to the next iteration
    end

    markerPositions = [leftEyePos; rightEyePos; mouthPos];

    RGB = insertMarker(RGB, markerPositions, 'color', 'red', size = 20);
    

    %Store modified image in cell array
    modifiedImages{i} = RGB;
end

% Display images
for i = 1:numel(files)
    % % Display the combined skin eyemap
    % subplot(2, 3, 1);
    % imshow(eyeMaps{i});
    % title('Eye Map');
    % 
    % % Display the combined skin mouthmap
    % subplot(2, 3, 2);
    % imshow(mouthMaps{i});
    % title('Mouth Map');

    % Display modified image with the red crosses
    %subplot(2, 3, 3);
    imshow(modifiedImages{i});
    title('Modified Image with Red Crosses');

    % Add a pause between each image
    pause(1);
end
