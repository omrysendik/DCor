function [ACorrTensor] = CalcACorrTensor(featMat)
    NumOfFeatures  = size(featMat,3);
    SizeOfFeatures = [size(featMat,1) size(featMat,2)];
    ACorrTensor = zeros(size(featMat));
    
    WeightsOutX = [round(size(featMat,1)/2):size(featMat,1) size(featMat,1)-1:-1:round(size(featMat,1)/2)];
    
    [WeightsOutX,WeightsOutY] = meshgrid(WeightsOutX,WeightsOutX);
    
    for IndN = 1:NumOfFeatures
        DummyACorr = xcorr2(featMat(:,:,IndN));
        MidCoord = ceil(size(DummyACorr)./2);
        DummyACorr = DummyACorr(MidCoord(1)-floor(SizeOfFeatures(1)/2):MidCoord(1)-floor(SizeOfFeatures(1)/2)+SizeOfFeatures(1)-1,...
                                MidCoord(2)-floor(SizeOfFeatures(2)/2):MidCoord(2)-floor(SizeOfFeatures(2)/2)+SizeOfFeatures(2)-1);
        DummyACorr = DummyACorr./(WeightsOutX.*WeightsOutY);
                            
        ACorrTensor(:,:,IndN) = DummyACorr;
    end
end