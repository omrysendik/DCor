function [ ErrorLoss,Grads ] = calcErrorLoss( srcMats, tgtFeatures, params , verbose)
    [StyleErrorLoss,StyleGrads] = CalcStyleErrorLoss(tgtFeatures.styleFeatures, srcMats.GramMats,params);
    if(verbose) disp(['Alpha*StyleErrorLoss=',num2str(params.styleLossWeight*StyleErrorLoss)]); end

    if(params.ACorrLossWeight~=0)
        [ACorrerrorLoss,ACorrGrads] = CalcACorrErrorLoss(tgtFeatures.ACorrFeatures, srcMats.ACorrMats,params);
        if(verbose) disp(['Beta*ACorrerrorLoss=',num2str(params.ACorrLossWeight*ACorrerrorLoss)]); end
    else
        ACorrerrorLoss=0;ACorrGrads=[];
    end
    
    if(params.DiversityLossWeight~=0)
        [DiversityErrorLoss,DiversityGrads] = CalcStructureErrorLoss(tgtFeatures.DiversityFeatures, srcMats.DiversityMats,params);
        if(verbose) disp(['Delta*DiversityErrorLoss=',num2str(params.DiversityLossWeight*DiversityErrorLoss)]); end
    else
        DiversityErrorLoss=0;DiversityGrads=[];
    end
    
    if(params.SmoothnessLossWeight~=0)    
        [SmoothnessErrorLoss,SmoothnessGrads] = CalcSoftMinSmoothnessErrorLoss(tgtFeatures.SmoothnessFeatures, params);
        if(verbose) disp(['Gamma*SmoothnessErrorLoss=',num2str(params.SmoothnessLossWeight*SmoothnessErrorLoss)]); end
    else
        SmoothnessErrorLoss=0;SmoothnessGrads=[];
    end
        
    ErrorLoss = params.styleLossWeight*StyleErrorLoss+...
                params.ACorrLossWeight*ACorrerrorLoss+...
                params.DiversityLossWeight*DiversityErrorLoss+...
                params.SmoothnessLossWeight*SmoothnessErrorLoss;
    Grads = CombineGrads(StyleGrads,ACorrGrads,DiversityGrads,SmoothnessGrads,params);
end


