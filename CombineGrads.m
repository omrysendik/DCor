function [grads] = CombineGrads(styleGrads, ACorrGrads, DiversityGrads, SmoothnessGrads, params)

grads = cell(length(params.unitedLayerInds),1);
for k=1:length(params.unitedLayerInds)
    grads{k}=0;

    auxInd = find(params.unitedLayerInds(k)==params.styleMatchLayerInds,1);
    if(~isempty(auxInd))
        grads{k} = grads{k}+params.styleLossWeight*styleGrads{auxInd};
    end
    
    auxInd = find(params.unitedLayerInds(k)==params.ACorrMatchLayerInds,1);
    if(~isempty(auxInd))
        grads{k} = grads{k}+params.ACorrLossWeight*single(ACorrGrads{auxInd});
    end
    
    auxInd = find(params.unitedLayerInds(k)==params.DiversityMatchLayerInds,1);
    if(~isempty(auxInd))
        grads{k} = grads{k}+params.DiversityLossWeight*single(DiversityGrads{auxInd});
    end

    auxInd = find(params.unitedLayerInds(k)==params.SmoothnessMatchLayerInds,1);
    if(~isempty(auxInd))
        grads{k} = grads{k}+params.SmoothnessLossWeight*single(SmoothnessGrads{auxInd});
    end
    
end
