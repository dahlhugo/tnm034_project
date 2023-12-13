function imgWeight = FindWeight(image, meanFace, eigenFaces)
    image = im2gray(image);
    image = im2double(image);
    imgVec = reshape(image, [], 1);
    
    faceDiff = imgVec - meanFace;

    imgWeight = mtimes(eigenFaces', faceDiff);
    
    sum_weight = sum(imgWeight, 1);

    imgWeight = bsxfun(@rdivide, imgWeight, sum_weight);
end