function YCrCb = ConvertRGB2YCrCb(RGB)
    red = RGB(:,:,1);
    green = RGB(:,:,2);
    blue = RGB(:,:,3);

    r_mean = 1/mean(red(:));
    g_mean = 1/mean(green(:));
    b_mean = 1/mean(blue(:));

    maxRGB = max(max(r_mean,g_mean),b_mean);

    %normalize

    r_mean = r_mean/maxRGB;
    g_mean = g_mean/maxRGB;
    b_mean = b_mean/maxRGB;

    red = red * r_mean;
    green = green * g_mean;
    blue = blue * b_mean;

    RGB = cat(3, red,green,blue);

    YCrCb = rgb2ycbcr(RGB);
end
