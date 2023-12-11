function Weights = CalculateWeights(eigenVecs,  diff)
    Weights = eigenVecs * diff';

    Weights = Weights';
end