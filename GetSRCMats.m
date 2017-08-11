function [SrcMats] = GetSRCMats(SrcImg,initNoise,net,params)

    [srcFeatures.styleFeatures, srcFeatures.ACorrFeatures, srcFeatures.DiversityFeatures] = CalcNetFeatures(net, SrcImg, params);
    [~,                         trgFeatures.ACorrFeatures                               ] = CalcNetFeatures(net, initNoise, params);
    
    for Ind = 1:length(params.styleMatchLayerInds)
        SrcMats.GramMats{Ind} = CalcGramMatrix(srcFeatures.styleFeatures{Ind});
    end
    for Ind = 1:length(params.ACorrMatchLayerInds)
        SrcMats.ACorrMats{Ind} = CalcACorrTensorFull(srcFeatures.ACorrFeatures{Ind},trgFeatures.ACorrFeatures{Ind});
    end
    
    for Ind = 1:length(params.DiversityMatchLayerInds)
        SrcMats.DiversityMats{Ind} = srcFeatures.DiversityFeatures{Ind};
    end