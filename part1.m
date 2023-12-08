folder = './DB1';
files = dir(fullfile(folder, '*.jpg'));

% Initialize cell arrays to hold images, eye maps, and mouth maps
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
    
    % Store the original image in the cell array
    allImages{i} = image;
    
    RGB = allImages{i};

    % Now, allImages is a cell array containing all the original images
    % Access individual original images using allImages{1}, allImages{2} ...

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
    
    % Store the skin mapping
    skinImage = image; 
    skinImage(repmat(~skinMask, [1, 1, size(image, 3)])) = 0; % for removing stuff besides the skin in the og image
    skinMaps{i} = skinImage;
    
    
    % Combine all maps into one map of the face
    skinmask_in = imcomplement(skinMask); % complement of the skinMap
    combinedMap = combinedMap_eye_mouth - skinmask_in;
    combinedMaps{i} = combinedMap; 

    % Initialize modImage to the original image
    modImage = RGB;

    if (faceConfirmation(eyeLocation, mouthLocation) == 1)
        % If yes, perform modifications and store the modified image
        modImage = drawLine(RGB, eyeLocation, mouthLocation);
    end 

    % Store the modified image in the cell array
    modifiedImages{i} = modImage;
end

% Display original, modified images, eye maps, and mouth maps side by side
for i = 1:numel(files)
    % Create a 3x3 subplot grid
    subplot(3, 3, 1);
    imshow(allImages{i});
    title('Original Image');

    subplot(3, 3, 2);
    imshow(modifiedImages{i});
    title('Modified Image');

    % Display the eye map
    subplot(3, 3, 3);
    imshow(eyeMaps{i});
    title('Eye Map');

    % Display the mouth map
    subplot(3, 3, 4);
    imshow(mouthMaps{i});
    title('Mouth Map');

    % Display the skin mask
    subplot(3, 3, 5);
    imshow(skinMaps{i});
    title('Skin Mask');

    % Display the combined skin, mouth and eye map
    subplot(3, 3, 6);
    imshow(combinedMaps{i});
    title('Skin, mouth and Eye Map');

    % Add a pause to display the images
    pause(2);
end
