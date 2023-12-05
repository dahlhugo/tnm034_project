clear
clc

location = './DB1/DB1/db/*.jpg';       %  folder in which your images exists
ds = imageDatastore(location)         %  Creates a datastore for all images in your folder



% CREATE EIGENFACES (PCA)

% First step - read images
% while hasdata(ds) 
%     img = read(ds) ;             % read image from datastore
%     figure, imshow(img);    % creates a new window for each image
% end

% Detect and normalise (part 1)
data = ds.read();
reset(ds);

dsLength = numel(ds.Files);

[i, j, p] = size(data);

K = i*j;

% Transform into vector
imVec = zeros(K, 0);
while hasdata (ds)
    image = im2gray(read(ds));
    image = double(reshape(image, [], 1));
    imVec(:, end + 1) = image;
end

% Find eigenvectors and diff
[eigenVecs, diff] = CalculateEigenVectors(imVec,K, dsLength);

% meanFace = (1/K)* sum(imVec, 2);
% 
% % Subtract mean for each vector
% diff = zeros(K, dsLength);
% for i = 1:dsLength
%     diff(:, i) = imVec(:, i)- meanFace;
% end
% 
% % Find covariance matrix C - (A^T)*A 
% % C = cov(diff);
% C = mtimes(diff', diff);
% % Find the best eigenvectors 
% [V,D] = eig(C);

%% Finding weight (for every eigenface)
W =  CalculateWeights(eigenVecs,  diff, K, dsLength);

% W = zeros(K, dsLength);
% for j = 1:dsLength   
%     W(:,j) = eigenVecs(:,j)' * diff(j,:)';
% end
%%
% colormap gray
% imagesc(reshape(meanFace, [250, 250]))
% 
% for i = 1:4
%    subplot(4, 4, i + 1)
%    imagesc(reshape(V(:, i), 250, []))
% end
%% Reconstruction
% I = zeros(n, 4);
% for i = 1:4
%     I(:, i) = meanFace + sum(W(:,i)*V(:,i));
% end
% 
% while hasdata(I)
%     imshow(I);
%     figure;
% end

% Project image on our eigenspace

%% To classify - smallest distance 

% test = imread('.\DB2\test2.jpg');
test = imread('./DB0/DB0/test.jpg');
testImage = im2gray(test);
testImage = im2double(testImage);
testImage = reshape(testImage, [], 1);

 inW = testImage(:, 1);


 [foundIndex, distanceDifference] = FaceRecognition(inW, W, dsLength);

% index = 1;
% E = 9000;
% for i = 1:dsLength
% 
%     temp = norm(inW - W(:, i));
% 
%     if temp < E
%         E = temp
%         index = i;
%     end
% 
% end
% 
% 
% threshold = 155;
% % Might need to be changed depending on other images of the same person
% if E >= threshold
%         disp('no match found')
% 
% else
%     disp('match found at ');
%     disp(index)
% 
% 
% end
        
if(foundIndex == 0)
    disp('No match found')
else
    disp('Match found at index ' + foundIndex)
end

% imshow(test);

% Threshold  (based on distance)






