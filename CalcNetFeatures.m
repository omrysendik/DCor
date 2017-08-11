function [styleFeatures, ACorrFeatures,DiversityFeatures,SmoothnessFeatures] = CalcNetFeatures(net, img, params)

truncatedNet = net;
truncatedNet.layers = net.layers(1:params.lastLayerNum);

dzdy = [];
res = [];

newRes = vl_simplenn(truncatedNet,single(img),dzdy,res,...
                      'accumulate', false, ...
                      'mode', 'test', ...
                      'conserveMemory', 0, ...
                      'backPropDepth', 1, ...
                      'sync', 0, ...
                      'cudnn', 0) ;
styleFeatures = {};
for k=1:length(params.styleMatchLayerInds)
   curLayerInd = params.styleMatchLayerInds(k);
   styleFeatures{k} = newRes(curLayerInd+1).x;
end

ACorrFeatures = {};
for k=1:length(params.ACorrMatchLayerInds)
   curLayerInd = params.ACorrMatchLayerInds(k);
   ACorrFeatures{k} = newRes(curLayerInd+1).x;
end

DiversityFeatures = {};
for k=1:length(params.DiversityMatchLayerInds)
   curLayerInd = params.DiversityMatchLayerInds(k);
   DiversityFeatures{k} = newRes(curLayerInd+1).x;
end

SmoothnessFeatures = {};
for k=1:length(params.SmoothnessMatchLayerInds)
   curLayerInd = params.SmoothnessMatchLayerInds(k);
   SmoothnessFeatures{k} = newRes(curLayerInd+1).x;
end