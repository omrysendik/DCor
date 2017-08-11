function [ACorrTensor] = CalcACorrTensorFull(SrcfeatMat,TrgfeatMat)
    NumOfFeatures  = size(SrcfeatMat,3);
    SizeOfFeatures = [size(SrcfeatMat,1) size(SrcfeatMat,2)];
    ACorrTensor = zeros(size(TrgfeatMat,1),size(TrgfeatMat,2),size(TrgfeatMat,3));

    WeightsInX = [1:SizeOfFeatures(1) SizeOfFeatures(1)-1:-1:1];
    [WeightsInX,WeightsInY] = meshgrid(WeightsInX,WeightsInX);
    
    for IndN = 1:NumOfFeatures
        DummyACorr = xcorr2(SrcfeatMat(:,:,IndN));
        DummyACorr = DummyACorr./(WeightsInX.*WeightsInY);
        
        MidCoord = ceil(size(DummyACorr)./2);
        Enlargement = floor((size(TrgfeatMat,1)-size(SrcfeatMat,1))/2);
        DummyACorr = DummyACorr(MidCoord(1)-floor(SizeOfFeatures(1)/2)-Enlargement:MidCoord(1)-floor(SizeOfFeatures(1)/2)+SizeOfFeatures(1)-1+Enlargement,...
                                MidCoord(2)-floor(SizeOfFeatures(2)/2)-Enlargement:MidCoord(2)-floor(SizeOfFeatures(2)/2)+SizeOfFeatures(2)-1+Enlargement);
        assert(size(DummyACorr,1)==size(TrgfeatMat,1));
        ACorrTensor(:,:,IndN) = DummyACorr;
    end
end