function [styleErrorLoss, styleGrads] = CalcStyleErrorLoss(tgtStyleFeatures, srcGramMats, params)

numFeatLayers = length(params.styleMatchLayerInds);
styleGrads = cell(numFeatLayers,1);
styleErrorLoss = 0;
for k=1:numFeatLayers
    szFeatMat = size(tgtStyleFeatures{k});
    if(length(szFeatMat)==2) szFeatMat(3)=1; end
    [tgtGram,tgtFeatVec] = CalcGramMatrix(tgtStyleFeatures{k});
    srcGram = srcGramMats{k};

    M = prod(szFeatMat(1:2));
    N = szFeatMat(3);
    
    srcGram = srcGram/M;
    tgtGram = tgtGram/M;
    
    styleDiff = tgtGram-srcGram;

    styleDiffWeight = params.styleFeatureWeights(k);
    styleErrorLoss = styleErrorLoss+(styleDiffWeight/4)*(sum((styleDiff(:)).^2))/N^2;

    aux=(tgtFeatVec'*styleDiff)'/(M*N^2);
    styleGrads{k} = styleDiffWeight*reshape(single(aux'),szFeatMat);
end

end