function modImage = drawLine(RGB, combinedMap)
    % Convert combinedMap to a binary image
    binaryMap = combinedMap > 0.5;

    % Find coordinates of white pixels
    [row, col] = find(binaryMap);

    % Initialize modImage to the original image
    modImage = RGB;

    % Draw crosses on the RGB image
    for i = 1:length(row)
        modImage = insertShape(modImage, 'Line', [col(i)-5, row(i), col(i)+5, row(i)], 'Color', 'red', 'LineWidth', 2);
        modImage = insertShape(modImage, 'Line', [col(i), row(i)-5, col(i), row(i)+5], 'Color', 'red', 'LineWidth', 2);
    end
end
