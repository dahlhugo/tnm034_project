function displayImagesPart1(eyeMaps, index, mouthMaps, resultPart1, originalImage)
     % Display the combined skin eyemap
    subplot(2, 2, 1);
    imshow(eyeMaps{index});
    title('Eye Map');

    % Display the combined skin mouthmap
    subplot(2, 2, 2);
    imshow(mouthMaps{index});
    title('Mouth Map');

    % Display the original image from the database
    subplot(2, 2, 3);
    imshow(originalImage);
    title('Original Image');

    % Display modified image with the red crosses (eye- mouth positions)
    subplot(2, 2, 4);
    imshow(resultPart1{index});
    title('Resulting Image after part 1');

    % Add a pause between each image
    pause(3);
end