EigenMatrix = reshape(EigenFaces, [250, 250, 4]);

EigenMatrix = rescale(EigenMatrix, 0, 255);

imshow(rescale(reshape(image, [250, 250]))

%for i = 1:4
%     figure; 
%     imshow(EigenMatrix(:,:,i), [0, 255]);
% 
% end