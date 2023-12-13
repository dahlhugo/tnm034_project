function normImage = colorNormalizationRGB(image) 
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    
    % Calculate the inverse mean of each color channel
    mean_R = 1/mean(r(:));
    mean_G = 1/mean(g(:));
    mean_B = 1/mean(b(:));
    
    % Finding the highest value of the RGB mean
    maxRGB = max(max(mean_R,mean_G),mean_B);
    
    % Normalize the r,g,b
    mean_R = mean_R/maxRGB;
    mean_G = mean_G/maxRGB;
    mean_B = mean_B/maxRGB;
    
    % Scale each color channel by its normalized mean
    r = r * mean_R;
    g = g * mean_G;
    b = b * mean_B;
    
    % Putting together the color channels again
    normImage = cat(3, r,g,b);
end