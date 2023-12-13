function [EigenFaces, Weights] = CalculateEigenFaces(eigenVecs,  diff)
    EigenFaces = mtimes(diff, eigenVecs);
    
    for  i = 1:size(EigenFaces, 2) 
        EigenFaces(:, i) = EigenFaces(:, i)/norm(EigenFaces(:,i));
    end

    weights = mtimes(EigenFaces', diff);
    
    %normalize weights
    weights_sum = sum(weights, 1);
    normalized_weights = bsxfun(@rdivide, weights, weights_sum);

    Weights = normalized_weights;

end