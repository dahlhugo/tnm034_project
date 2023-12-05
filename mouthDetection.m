function mouthMap = mouthDetection(YCrCb)

    Cb = normalize(double(YCrCb(:,:,2)), 'norm', 1);
    Cr = normalize(double(YCrCb(:,:,3)), 'norm', 1);

    % Use the paper's formula for eta
    eta = 0.95 * (0.5 * sum(Cr.^2)) / (0.5 * sum(Cr./Cb));

    % Normalize the mouth map between 0 and 1
    mouthMapFormula = Cr.^2 .* (Cr.^2 - eta * Cr./Cb).^2;
    threshold = 0.5;
    mouthMap = mouthMapFormula > threshold;

end