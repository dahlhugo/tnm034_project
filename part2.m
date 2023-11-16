location = 'S:\TNM034\tnm034_project\DB1\DB1\db\*.jpg';       %  folder in which your images exists
ds = imageDatastore(location)         %  Creates a datastore for all images in your folder



% CREATE EIGENFACES (PCA)

% First step - read images
% while hasdata(ds) 
%     img = read(ds) ;             % read image from datastore
%     figure, imshow(img);    % creates a new window for each image
% end

% Detect and normalise (part 1)

% Transform into vector
imVec = zeros(187500, 0);
while hasdata (ds)
    image = read(ds);
    image = reshape(image, [], 1);
    imVec(:, end + 1) = image;
end
imVec

% Find average face vector
M = 4;
meanFace = (1/M)* sum(imVec, 2);

% Subtract mean for each vector
diff = zeros(187500, 4);
for i = 1:4
    diff(:, i) = imVec(:, i)- meanFace;
end

% Find covariance matrix C - (A^T)*A 
C = diff'*diff;

% Find the best eigenvectors 
[V,D] = eig(C);

% Finding weight (for every eigenface)
eigenface_images = reshape(V(: , 1), 256, 256, []);

imshow(eigenface_images)

% Project image on our eigenspace
% To classify - smallest distance 
% Threshold  (based on distance)





