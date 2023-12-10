function modImage = drawLine(RGB, combinedMap)
    % Find the lighter pixels in the map
    binaryMap = combinedMap > 0.5;

    % Go thorugh the rows and cols.
    [row, col] = find(binaryMap);

    modImage = RGB;

    % Draw crosses on the RGB image
    for i = 1:length(row)
        modImage = insertShape(modImage, 'Line', [col(i)-5, row(i), col(i)+5, row(i)], 'Color', 'red', 'LineWidth', 2);
        modImage = insertShape(modImage, 'Line', [col(i), row(i)-5, col(i), row(i)+5], 'Color', 'red', 'LineWidth', 2);
    end
end
