function imgWeight = FindWeight(imgVec, meanFace, eigenFaces)
    faceDiff = imgVec - meanFace;

    imgWeight = mtimes(eigenFaces', faceDiff);
    
    sum_weight = sum(imgWeight, 1);

    imgWeight = bsxfun(@rdivide, imgWeight, sum_weight);
end