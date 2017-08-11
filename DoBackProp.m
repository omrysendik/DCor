function [ dx ] = DoBackProp( net, grads, tgtImg, params )

truncatedNet = net;
truncatedNet.layers = net.layers(1:params.lastLayerNum);

[forwardRes] = DoForwardPass(truncatedNet,tgtImg, params.unitedLayerInds, grads, params);

fprintf('Backward Pass: ');
dx = 0;
for k=params.lastLayerNum:-1:1
    truncatedNet.layers = net.layers(1:k);
    auxInd = find(params.unitedLayerInds == k);
    if(isempty(auxInd))
        continue;
    end
    curRes = forwardRes(1:k+1);
    curRes(k+1).dzdx = grads{auxInd};
    fprintf('Layer %d, ',k);
    curBackwardRes = DoBackwardPass(truncatedNet, curRes, params);
    dx = dx+curBackwardRes(1).dzdx;
end

fprintf('\n');

