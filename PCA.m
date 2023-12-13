function foundIndex = PCA(testImagePath, modifiedImages)

modifiedImages(:, 12) = [];
nrOfImages = size(modifiedImages, 2);

[w, h, rgb] = size(modifiedImages{1});

columnLength = w*h;

% Transform into vector
imageVectors = zeros(columnLength, nrOfImages);
for i = 1:nrOfImages
    image = im2gray(modifiedImages{i});
    image = double(reshape(image, [], 1));
    imageVectors(:, i) = image;
end



% Find eigenvectors and diff
[eigenVecs, diff, meanFace] = CalculateEigenVectors(imageVectors, columnLength, nrOfImages);

% Finding weight (for every eigenface)
[EigenFaces, W] =  CalculateEigenFaces(eigenVecs,  diff);


% To classify - smallest distance 

testImage = ImageProcessing(testImagePath);

testWeight = FindWeight(testImage, meanFace, EigenFaces);


[foundIndex, distanceDifference] = FaceRecognition(testWeight, W, nrOfImages);


        
% if(foundIndex == 0)
%     disp('No match found')
% else
%     disp('Match found at index '); disp(int2str(foundIndex));
% end
end
















