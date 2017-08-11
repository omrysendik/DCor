function [Grad] = GetGrad(net,curTgtImg,SrcImg,srcMats,params)
        global SavedDataPrevDeltas;
        if(params.lbfgs_opts.autoconverge==1 && numel(SavedDataPrevDeltas)>=params.lbfgs_opts.autoconvergelen+1)
            if(prod(SavedDataPrevDeltas(end-params.lbfgs_opts.autoconvergelen:end)<=params.lbfgs_opts.autoconvergethresh))
                Grad = zeros(size(curTgtImg(:)));
                return;
            end
        end
        
        curTgtImg = reshape(curTgtImg,[round(params.USFac*size(SrcImg,1)),round(params.USFac*size(SrcImg,2)),size(SrcImg,3)]);
        [tgtFeatures.styleFeatures, tgtFeatures.ACorrFeatures, tgtFeatures.DiversityFeatures, tgtFeatures.SmoothnessFeatures] = CalcNetFeatures(net, curTgtImg, params);
    
        [~,CombinedGrads] = CalcErrorLoss(srcMats,tgtFeatures,params, 0);
        
        [Grad]              = DoBackProp(net, CombinedGrads, curTgtImg, params);
        Grad = double(Grad(:));
		
		
end
