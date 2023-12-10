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

    % 7 x 7 kernel (didn't seem to work so went with se instead)
    %g_sigma = [0.7498, 1.1247, 1.4996, 1.8745, 1.4996, 1.1247, 0.7498;
    %      1.1247, 1.4996, 1.8745, 2.2494, 1.1875, 1.4996, 1.1247;
    %       1.4996, 1.8745, 2.2494, 2.6243, 2.2494, 1.8745, 1.4996;
    %       1.8745, 2.2494, 2.6243, 2.9992, 2.6343, 2.2494, 1.8745;
    %       1.4996, 1.8745, 2.2494, 2.6243, 2.2494, 1.8745, 1.4996;
    %       1.1247, 1.4996, 1.8745, 2.2494, 1.8745, 1.4996, 1.1247;
    %       0.7498, 1.1247, 1.4996, 1.8745, 1.4996, 1.1247, 0.7498];

    % Normalize kernel
    %g_sigma = g_sigma / sum(g_sigma(:));
    
    radius = 10;  
    se = strel('disk', radius);
    % Apply the kernel, here se, to the luminance component
    dilationY = imdilate(Y, se);
    erosionY = imerode(Y, se);

    % Luminance map
    EyeMapL = dilationY ./ (erosionY + eps);

    EyeMap = EyeMapC .* EyeMapL;

    threshold = 0.5; % Tweak if needed, 0.5 worked fine
    EyeMapThresholded = (EyeMap > threshold) .* EyeMap;


end
