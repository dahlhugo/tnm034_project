% Straightforward confirmation function if it interprets a face, meaning it
% has 2 eyes and 1 mouth, simplified.

function confirmedFace = faceConfirmation(eyeLocation,mouthLocation)
    confirmedFace = (length(eyeLocation) >=2) && (length(mouthLocation) >= 1);
end