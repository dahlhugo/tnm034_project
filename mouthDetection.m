function mouthMap = mouthDetection(YCrCb)
   
    Cb = double(YCrCb(:,:,2));
    Cr = double(YCrCb(:,:,3));

    % Use the paper's formula for eta
    eta = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));
    mouthMapFormula = Cr.^2 .* (Cr.^2 - eta * Cr./Cb).^2;

    % Make it binary.
    mouthMapFormula = (mouthMapFormula - min(mouthMapFormula(:))) / (max(mouthMapFormula(:)) - min(mouthMapFormula(:)));
    threshold = 0.4; % Can be tweaked
    
    mouthMap = mouthMapFormula > threshold;
    SE = strel('disk', 10);
    mouthMap = imclose(mouthMap, SE);
    mouthMap = imclearborder(mouthMap);

end