location = 'S:\TNM034\tnm034_project\DB1\DB1\*.jpg';       %  folder in which your images exists
ds = imageDatastore(location)         %  Creates a datastore for all images in your folder

normalisedImage = imread('.\DB1\DB1\res.jpg');

imshow(normalisedImage);

% CREATE EIGENFACES (PCA)
% First step - read images
% Detect and normalise (part 1)
% Transform into vector
% Find average face vector
% Subtract mean for each vector
% Find covariance matrix C - (A^T)*A 
% Find the best eigenvectors 
% Finding weight (for every eigenface)
% Project image on our eigenspace
% To classify - smallest distance 
% Threshold  (based on distance)





