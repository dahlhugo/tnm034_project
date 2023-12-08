% drawLine.m
function modImage = drawLine(image, eyeLocation, mouthLocation)
    % Draw lines around eyes and mouth on the image

    % Extract eye coordinates
    % Initialize variables to store eye coordinates
    eye1 = [];
    eye2 = [];

    % First pass to find the coordinates of the first eye
    for i = 1:size(eyeLocation, 1)
        % Check if the pixel value is more than 0.40
        if eyeLocation(i, 3) > 0.40 % Assuming the pixel value is in the third column
            disp(['Pixel value at Eye ', num2str(i), ': ', num2str(eyeLocation(i, 3))]);
            eye1 = [eyeLocation(i, 1), eyeLocation(i, 2)];
            break; % Exit the loop once the first eye is found
        end
    end

    % Second pass to find the coordinates of the second eye
    for i = 1:size(eyeLocation, 1)
        % Check if the pixel value is more than 0.40 and different from the first eye
        if eyeLocation(i, 3) > 0.40 && ~isequal([eyeLocation(i, 1), eyeLocation(i, 2)], eye1)
            disp(['Pixel value at Eye ', num2str(i), ': ', num2str(eyeLocation(i, 3))]);
            eye2 = [eyeLocation(i, 1), eyeLocation(i, 2)];
            break; % Exit the loop once the second eye is found
        end
    end

    % Display the found eye coordinates
    disp('Eye 1 coordinates:');
    disp(eye1)

    disp('Eye 2 coordinates:');
    disp(eye2)

    % Extract mouth coordinates
    % First pass to find the coordinates of the mouth
    for i = 1:size(mouthLocation, 1)
        % Check if the pixel value is more than 0.50
        if mouthLocation(i, 3) > 0.50 % Assuming the pixel value is in the third column
            disp(['Pixel value at Mouth ', num2str(i), ': ', num2str(mouthLocation(i, 3))]);
            mouth = [mouthLocation(i, 1), mouthLocation(i, 2)];
            break;
        end
    end

    % Display the found mouth coordinates
    disp('Mouth coordinates:');
    disp(mouth)

    % Draw lines
    modImage = image;

    % Draw lines on the modified image
    %modImage = insertShape(modImage, 'Line', [eye1, eye2], 'Color', 'red', 'LineWidth', 2);
    %modImage = insertShape(modImage, 'Line', [eye1(1), eye1(2), mouth(1), mouth(2)], 'Color', 'red', 'LineWidth', 2);
    %modImage = insertShape(modImage, 'Line', [eye2(1), eye2(2), mouth(1), mouth(2)], 'Color', 'red', 'LineWidth', 2);
end