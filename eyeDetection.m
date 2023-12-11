function EyeMapThresholded = eyeDetection(YCrCb)

    % Chrominance component calculation
    Y = double(YCrCb(:,:,1));
    Cb = double(YCrCb(:,:,2));
    Cr = double(YCrCb(:,:,3));

    % Normalize (Cb^2), (Cr^2), and (Cb/Cr) 0-255
    Cb2_norm = normalize(Cb.^2, 'norm');
    Cb2_255_norm = normalize((Cb.^2)-1, 'norm');
    CbCr_norm = normalize((Cb./Cr), 'norm');
    % Chrominance map
    EyeMapC = (1/3) * (Cb2_norm + Cb2_255_norm + CbCr_norm);

    % Luminance component calculation
    radius = 10;  
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
end
