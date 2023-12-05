function mouthMap = mouthDetection(YCrCb)

    Cb = double(YCrCb(:,:,2));
    Cr = double(YCrCb(:,:,3));

    % Use the paper's formula for eta
    eta = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));
    % Normalize the mouth map between 0 and 1
    mouthMapFormula = Cr.^2 .* (Cr.^2 - eta * Cr./Cb).^2;

    mouthMapFormula = (mouthMapFormula - min(mouthMapFormula(:))) / (max(mouthMapFormula(:)) - min(mouthMapFormula(:)));
    threshold = 0.5;
    mouthMap = mouthMapFormula > threshold;

end