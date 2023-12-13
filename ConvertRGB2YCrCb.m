function YCrCb = ConvertRGB2YCrCb(rgb)
    % Function for normalizing the rgb color 
    % and converting it to YCrCb color space

    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);

    % Calculate the inverse means of each color channel
    meanR = 1/mean(r(:));
    meanG = 1/mean(g(:));
    meanB = 1/mean(b(:));

    maxRGB = max(max(meanR,meanG),meanB);

    % Normalize each inverse mean
    meanR = meanR/maxRGB;
    meanG = meanG/maxRGB;
    meanB = meanB/maxRGB;

    % Scale each color channel by its normalized mean    
    r = r * meanR;
    g = g * meanG;
    b = b * meanB;

    rgb = cat(3, r,g,b);

    YCrCb = rgb2ycbcr(rgb);
    
end
