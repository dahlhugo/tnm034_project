function [EigenFaces, Weights] = CalculateEigenFaces(eigenVecs,  diff)
    EigenFaces = mtimes(diff, eigenVecs);
    
    for  i = 1:size(EigenFaces, 2) 
        EigenFaces(:, i) = EigenFaces(:, i)/norm(EigenFaces(:,i));
    end

    Weights = mtimes (EigenFaces', diff);
end