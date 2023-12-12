function imgWeight = FindWeight(imgVec, meanFace, eigenFaces)
    faceDiff = imgVec - meanFace;

    imgWeight = mtimes(eigenFaces', faceDiff);
    

end