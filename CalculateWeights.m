function Weights = CalculateWeights(eigenVecs,  diff, K, numOfImages)
    W = zeros(K, numOfImages);
    for j = 1:numOfImages   
        W(:,j) = eigenVecs(:,j)' * diff(j,:)';
    end
    Weights = W;
end