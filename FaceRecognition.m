function [foundIndex, distanceDifference] = FaceRecognition(inFace, Weights, numOfImgs)
index = 1;
E = 9000;
for i = 1:numOfImgs
    
    temp = norm(inFace - Weights(:, i));
    
    if temp < E
        E = temp
        index = i;
    end
    
end


threshold = 155;
% Might need to be changed depending on other images of the same person
if E >= threshold
        index = 0;
end

foundIndex = index;
distanceDifference = E

end