function [DiversityErrorLoss, DiversityGrads] = CalcStructureErrorLoss(tgtDiversityFeatures, srcDiversityFeatures, params)

numFeatLayers = length(params.DiversityMatchLayerInds);
DiversityGrads = cell(numFeatLayers,1);
DiversityErrorLoss = 0;
for k=1:numFeatLayers
    
    FeatDiff = tgtDiversityFeatures{k}-srcDiversityFeatures{k};

    DiversityDiffWeight = params.DiversityFeatureWeights(k);
    DiversityErrorLoss = 0.5*sum(FeatDiff(:).^2);

    DiversityGrads{k} = DiversityDiffWeight*FeatDiff;
end

end