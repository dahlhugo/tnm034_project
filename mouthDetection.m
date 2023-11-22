function mouthMap = mouthDetection(YCrCb)

Cb = double(YCrCb(:,:,2));
Cr = double(YCrCb(:,:,3));

Cr2_norm = normalize(Cr^2);
CrCb_norm = normalize(Cr/Cb);

double eta = 0.95 * 