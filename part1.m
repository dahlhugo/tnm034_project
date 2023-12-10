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

    eyeLocation = eyeDetection(YCrCb);

    mouthLocation = mouthDetection(YCrCb);

    % Store the eye map
    eyeMap = eyeDetection(YCrCb);
    eyeMaps{i} = eyeMap;

    % Store the mouth map
    mouthMap = mouthDetection(YCrCb);
    mouthMaps{i} = mouthMap;

    % Combine eye mask with mouth map (maps in binary) 
    combinedMap_eye_mouth = eyeMap + mouthMap;
    mouthEyeMaps{i} = combinedMap_eye_mouth;
    
    % Store the skin map
    skinImage = image; 
    skinImage(repmat(~skinMask, [1, 1, size(image, 3)])) = 0; % for removing stuff besides the skin in the og image
    skinMaps{i} = skinImage;
    
    % Combine all maps into one map of the face
    skinmask_in = imcomplement(skinMask); % complement of the skinMap
    combinedMap = combinedMap_eye_mouth - skinmask_in;
    combinedMaps{i} = combinedMap; 
    
    % Modified image
    modImage = RGB;
    modImage = drawLine(RGB, combinedMap);

    % Store modified image in cell array
    modifiedImages{i} = modImage;
end

% Display images
for i = 1:numel(files)
    % 4x3 subplot grid
    subplot(4, 3, 1);
    imshow(allImages{i});
    title('Original Image');

    % Display eye map
    subplot(4, 3, 2);
    imshow(eyeMaps{i});
    title('Eye Map');

    % Display mouth map
    subplot(4, 3, 3);
    imshow(mouthMaps{i});
    title('Mouth Map');

    % Display skin mask
    subplot(4, 3, 4);
    imshow(skinMaps{i});
    title('Skin Mask');

    % Display the combined map
    subplot(4, 3, 5);
    imshow(combinedMaps{i});
    title('Skin, Mouth and Eye Map');

    % Display modified image with the red crosses
    subplot(4, 3, 6);
    imshow(modifiedImages{i});
    title('Modified Image with Red Crosses');

    % Add a pause between each image
    pause(2);
end
