% drawLine.m
function modImage = drawLine(image, eyeLocation, mouthLocation)
    % Draw lines around eyes and mouth on the image

    % Extract eye coordinates
    eye1 = eyeLocation(1, :);
    eye2 = eyeLocation(2, :);

    % Extract mouth coordinates
    mouth = mouthLocation(1, :);

    % Draw lines
    modImage = image;

    % Draw lines on the modified image
    modImage = insertShape(modImage, 'Line', [eye1(1), eye1(2), eye2(1), eye2(2)], 'Color', 'red', 'LineWidth', 2);
    modImage = insertShape(modImage, 'Line', [eye1(1), eye1(2), mouth(1), mouth(2)], 'Color', 'red', 'LineWidth', 2);
    modImage = insertShape(modImage, 'Line', [eye2(1), eye2(2), mouth(1), mouth(2)], 'Color', 'red', 'LineWidth', 2);
end
