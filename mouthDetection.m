function mouthMap = mouthDetection(YCrCb, i)

Cb = double(YCrCb(:,:,2));
Cr = double(YCrCb(:,:,3));

Cr2_norm = normalize(Cr^2);
CrCb_norm = normalize(Cr/Cb);
CbCr_norm = normalize(Cb/Cr);

eta = 0.95 * ((1/i) * (Cr2_norm))/((1/i) * (CbCr_norm));

mouthMap = Cr2_norm * (Cr2_norm - eta*CrCb_norm);

end