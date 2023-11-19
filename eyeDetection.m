function EyeMap = eyeDetection(YCrCb, contour, area)

% Chrominance component calculation
Cb = double(YCrCb(:,:,2));
Cr = double(YCrCb(:,:,3));

% Normalize (Cb^2), (Cr^2), and (Cb/Cr) in the range [0; 255]
Cb2_norm = normalize(Cb.^2);
Cr2_norm = normalize(Cr.^2);
CbCr_norm = normalize(Cb./Cr);

% Chrominance map
EyeMapC = (1/3) * (Cb2_norm + Cr2_norm + CbCr_norm);

% Luminance component calculation

% 7 x 7 kernel, used instead of a structuring element here.
g_sigma = [0.7498, 1.1247, 1.4996, 1.8745, 1.4996, 1.1247, 0.7498;
           1.1247, 1.4996, 1.8745, 2.2494, 1.1875, 1.4996, 1.1247;
           1.4996, 1.8745, 2.2494, 2.6243, 2.2494, 1.8745, 1.4996;
           1.8745, 2.2494, 2.6243, 2.9992, 2.6343, 2.2494, 1.8745;
           1.4996, 1.8745, 2.2494, 2.6243, 2.2494, 1.8745, 1.4996;
           1.1247, 1.4996, 1.8745, 2.2494, 1.8745, 1.4996, 1.1247;
           0.7498, 1.1247, 1.4996, 1.8745, 1.4996, 1.1247, 0.7498];

% Normalize kernel
g_sigma = g_sigma / sum(g_sigma(:));

% Dilation
dilationY = imdilate(Y, g_sigma);
erosionY = imerode(Y, g_sigma);

EyeMapL = dilationY./(erosionY + 1);

EyeMap = EyeMapC * EyeMapL;

