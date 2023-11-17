location = './DB1/DB1/db/*.jpg';       %  folder in which your images exists
ds = imageDatastore(location)         %  Creates a datastore for all images in your folder



% CREATE EIGENFACES (PCA)

% First step - read images
% while hasdata(ds) 
%     img = read(ds) ;             % read image from datastore
%     figure, imshow(img);    % creates a new window for each image
% end

% Detect and normalise (part 1)

n = 62500;

% Transform into vector
imVec = zeros(n, 0);
while hasdata (ds)
    image = im2gray(read(ds));
    image = reshape(image, [], 1);
    imVec(:, end + 1) = image;
end

% Find average face vector
M = 4;
meanFace = (1/M)* sum(imVec, 2);

% Subtract mean for each vector
diff = zeros(n, 4);
for i = 1:4
    diff(:, i) = imVec(:, i)- meanFace;
end

% Find covariance matrix C - (A^T)*A 
C = cov(diff);

% Find the best eigenvectors 
[V,D] = eig(C);

%% Finding weight (for every eigenface)
W = zeros(n, 4);
for j = 1:4    
    W(:,j) = V(:,j)' * diff(j,:)';
end
%%
colormap gray
imagesc(reshape(meanFace, [250, 250]))

for i = 1:4
   subplot(4, 4, i + 1)
   imagesc(reshape(V(:, i), 250, []))
end
%% Reconstruction
I = zeros(n, 4);
for i = 1:4
    I(:, i) = meanFace + sum(W(:,i)*V(:,i));
end

while hasdata(I)
    imshow(I);
    figure;
end

% Project image on our eigenspace
% To classify - smallest distance 
% Threshold  (based on distance)






