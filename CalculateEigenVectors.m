function [eigenVecs, diff, meanFace] =  CalculateEigenVectors(imVec, K, numOfImgs)
    meanFace = (1/K)* sum(imVec, 2);
    
    % Subtract mean for each vector
    diff = zeros(K, numOfImgs);
    for i = 1:numOfImgs
        diff(:, i) = imVec(:, i) - meanFace;
    end
    
    % Find covariance matrix C - (A^T)*A 
    % C = cov(diff);
    C = mtimes(diff', diff);
    % Find the best eigenvectors 
    [eigenVecs,~] = eig(C);

end