function EyeMapThresholded = eyeDetection(YCrCb)

    % Chrominance component calculation
    Y = double(YCrCb(:,:,1));
    Cb = double(YCrCb(:,:,2));
    Cr = double(YCrCb(:,:,3));

    %E&V----------------------------------------------------


    % %   Detailed explanation goes here
    % gray = rgb2gray(YCrCb);
    % %Illumination based approach
    % 
    % g = 1/3;
    % 
    % ccb = Cb.^2;
    % ccb = rescale(ccb, 0, 255);
    % 
    % ccr = (255 - Cr).^2;
    % ccr = rescale(ccr, 0, 255);
    % 
    % cbcr = Cb./Cr;
    % cbcr = rescale(cbcr, 0, 255);
    % 
    % eyeMapC = g*(ccb + ccr + cbcr);
    % eyeMapC = histeq(eyeMapC);
    % 
    % SE = strel('disk', 7);
    % o = imdilate(Y,SE);
    % p = imerode(Y,SE);
    % eyeMapL = o./p;
    % 
    % eyeMap = eyeMapC.*eyeMapL;
    % 
    % %Edge density based approach
    % edgeDensitySE = strel('disk', 4);
    % edgeDensity = edge(gray, "sobel");
    % edgeDensity = imdilate(edgeDensity, edgeDensitySE);
    % edgeDensity = imdilate(edgeDensity, edgeDensitySE);
    % edgeDensity = imerode(edgeDensity, edgeDensitySE);
    % edgeDensity = imerode(edgeDensity, edgeDensitySE);
    % edgeDensity = imerode(edgeDensity, edgeDensitySE);
    % 
    % edgeDensity = bwpropfilt(edgeDensity, 'Solidity', [0.5 inf]);
    % edgeDensity = imclearborder(edgeDensity, 26);
    % 
    % %colour based method
    % imHist = histeq(rgb2gray(YCrCb));
    % imHist = imHist > 40;
    % imHist = imdilate(imHist, strel('disk', 6));
    % 
    % imHist = bwpropfilt(imHist, 'Solidity', [0.5 inf]);
    % imHist = imclearborder(imHist);
    % imHist = bwpropfilt(imHist, 'Orientation', [-45 45]);
    % stats = regionprops(imHist, 'MinorAxisLength', 'MajorAxisLength', 'BoundingBox');
    % stats = struct2table(stats);
    % stats.AspectRatio = stats.MajorAxisLength / stats.MinorAxisLength;
    % toDelete = stats.AspectRatio < 0.8 & stats.AspectRatio > 4.5;
    % stats(toDelete, :) = [];
    % for i=1:height(stats)
    %     bbox = stats(i,:).BoundingBox;
    %     x1 = ceil(bbox(1));
    %     x2 = round(x1+bbox(3));
    %     y1 = ceil(bbox(2));
    %     y2 = round(y1+bbox(4));
    %     imHist(y1:y2, x1:x2) = 0;
    % end
    % 
    % %combine all three
    % eyeMap = eyeMap.*edgeDensity;
    % 
    % maskedIm = imdilate(eyeMap,SE);
    % maskedIm = maskedIm.*mask;
    % maskedIm = rescale(maskedIm,0,255);
    % EyeMapThresholded = uint8(maskedIm);
    
    % F----------------------------------------------------
    %  % EyeMapC
    % g = 1./3;
    % ccb = Cb.^2;
    % ccr = (1 - Cr).^2;
    % cbcr = Cb./Cr;
    % 
    % eyeMapC = g*(ccb + ccr + cbcr);
    % 
    % % EyeMapL
    % SE = strel('disk', 5);
    % o = imdilate(Y, SE);
    % p = imerode(Y, SE);
    % 
    % eyeMapL = o./p;
    % 
    % eyeMap = eyeMapC.*eyeMapL;
    % eyeMap = normalize(eyeMap);
    % 
    % % Thresholding to create a binary mask
    % threshold = 0.5; % Adjust as needed
    % binaryMask = eyeMap > threshold;
    % 
    % % Morphological operations to refine the mask
    % binaryMask = imdilate(binaryMask, SE);
    % %Remove small regions (noise) from the binary mask
    % binaryMask = bwareaopen(binaryMask, 100);
    % 
    % % Multiply the binary mask with the original image to keep only the eyes
    % EyeMapThresholded = double(255 * mat2gray(binaryMask)) .* Y;

    %D----------------------------------------------------
    % % Chromincance eyemap
    % eyeMapC = ((Cb.^2)+((1-Cr).^2)+(Cb./Cr))./3; 
    % 
    % %Histogram normalization
    % normImg = histeq(eyeMapC);
    % EyeMap = normImg; 
    % 
    % %EyeMapL -----------
    % 
    % %Structure element size based on height
    % SE_height = round(length(EyeMap(:,1))/24);
    % SE = strel('disk',SE_height,8);
    % 
    % eyemapL=double(imdilate(Y,SE))./double(imerode(Y,SE) + 1);
    % 
    % % Normalizing EyeMapL between 0 and 255 
    % EyeMapThresholded = double(255 * mat2gray(eyemapL));
    % 
    % eyemap = EyeMap.*EyeMapThresholded;
    % 
    % %Make binary mask
    % eyemap = eyemap >= 0.80; 
    % 
    % % Morphological operations to remove unnecessary blobs from EyeMap
    % SE = strel('disk',7);
    % eyemap = imdilate(eyemap, SE);
    % eyemap = imdilate(eyemap, SE);
    % eyemap = imerode(eyemap, SE);
    % eyemap = imclearborder(eyemap);
    % 
    % % Remove impossible eye candidates
    % [height, width] = size(eyemap);
    % 
    % statsEye = regionprops(eyemap, 'centroid',  'PixelIdxList', 'MajorAxisLength', 'MinorAxisLength');
    % centAxisEyes = cat(1, statsEye.MajorAxisLength);
    % 
    % centroidseye = cat(1, statsEye.Centroid);
    % [numOfEyes, ~] = size(centroidseye);
    % 
    %  for i=1:numOfEyes  
    %    if centroidseye(i,2) > height*0.66 || centroidseye(i,2) < height*0.3
    %      eyemap(statsEye(i).PixelIdxList) = 0;
    %    end
    %    if centAxisEyes(i,1) > 100
    %        eyemap(statsEye(i).PixelIdxList) = 0;
    %    end
    %  end
     %----------------------------------------------------

    %EGEN----------------------------------------------------
    %Normalize (Cb^2), (Cr^2); and (Cb/Cr) 0-255
    Cb2_norm = normalize(Cb.^2, 'norm');
    Cb2_255_norm = normalize((Cb.^2)-1, 'norm');
    CbCr_norm = normalize((Cb./Cr), 'norm');
    % Chrominance map
    EyeMapC = (1/3) * (Cb2_norm + Cb2_255_norm + CbCr_norm);

    % Luminance component calculation
    radius = 9; % 9 is the smallest it can be
    se = strel('disk', radius);
    % Apply the kernel, here se, to the luminance component
    dilationY = imdilate(Y, se);
    erosionY = imerode(Y, se);

    % Luminance map
    EyeMapL = dilationY ./ (erosionY + 1);

    EyeMap = EyeMapL .* EyeMapC;

    threshold = 0.3; % Tweak if needed, 0.5 worked fine
    EyeMapThresholded = (EyeMap > threshold);

    EyeMapThresholded = imdilate(EyeMapThresholded, se);
    EyeMapThresholded = imdilate(EyeMapThresholded, se);
    EyeMapThresholded = imerode(EyeMapThresholded, se);
    EyeMapThresholded = imdilate(EyeMapThresholded, se);
    EyeMapThresholded = imerode(EyeMapThresholded, se);

    % Remove small and large regions from the binary mask
    minArea = 100; % Adjust as needed
    maxArea = 3000; % Adjust as needed

    EyeMapThresholded = bwareaopen(EyeMapThresholded, minArea);
    EyeMapThresholded = bwareafilt(EyeMapThresholded, [minArea, maxArea]);

    % Get image dimensions
    [height, width] = size(EyeMapThresholded);

    % Label connected components in the binary mask
    labeledMask = bwlabel(EyeMapThresholded);

    % Remove regions outside the specified range
    for i = 1:max(labeledMask(:))
        regionProperties = regionprops(labeledMask == i, 'Centroid');
        centroidX = regionProperties.Centroid(1);
        centroidY = regionProperties.Centroid(2);

        % Define ranges for the middle of the image (adjust as needed)
        middleRangeX = [width*0.2, width*0.7];
        middleRangeY = [height*0.4, height*0.5];

        % Check if the centroid is outside the middle range
        if centroidX < middleRangeX(1) || centroidX > middleRangeX(2) || ...
           centroidY < middleRangeY(1) || centroidY > middleRangeY(2)
            EyeMapThresholded(labeledMask == i) = 0;
        end
    end
   
end
