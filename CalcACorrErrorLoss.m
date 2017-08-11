function [ACorrErrorLoss, ACorrGrads] = CalcACorrErrorLoss(TargetFeatures, SourceACorrs, params)

numFeatLayers = length(params.ACorrMatchLayerInds);
ACorrGrads = cell(numFeatLayers,1);
ACorrErrorLoss = 0;
for k=1:numFeatLayers
    TargetACorr = CalcACorrTensor(TargetFeatures{k});
    SourceACorr = SourceACorrs{k};
    
    ACorrDiff = TargetACorr-SourceACorr;

    ACorrDiffWeight = params.ACorrFeatureWeights(k);
    ACorrErrorLoss = ACorrErrorLoss+ACorrDiffWeight*(sum((ACorrDiff(:)).^2));
    
    ACorrGrads{k} = ACorrDiffWeight*CalcACorrGrad(TargetFeatures{k},ACorrDiff);
end

end

function [ACorrGrad] = CalcACorrGrad(featMat,ACorrDiff)
    NumOfFeatures  = size(featMat,3);
    SizeOfFeatures = [size(featMat,1) size(featMat,2)];
    ACorrGrad = zeros(size(featMat));
    
    WeightsOutX = [round(size(featMat,1)/2):size(featMat,1) size(featMat,1)-1:-1:round(size(featMat,1)/2)];
    [WeightsOutX,WeightsOutY] = meshgrid(WeightsOutX,WeightsOutX);
    
    for IndN = 1:NumOfFeatures
        ACorrGrad(:,:,IndN) = 4*conv2(double(flipud(fliplr(ACorrDiff(:,:,IndN))))./(WeightsOutX.*WeightsOutY),double(featMat(:,:,IndN)),'same');
    end
end