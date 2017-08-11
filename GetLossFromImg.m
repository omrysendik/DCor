function [errorLoss] = GetLossFromImg(net,curTgtImg,SrcImg,srcMats,params)
        global SavedDataPrevErrors;
        global SavedDataPrevDeltas;
        global SavedDataPrevImg;

        if(params.lbfgs_opts.autoconverge==1 && numel(SavedDataPrevDeltas)>=params.lbfgs_opts.autoconvergelen+1)
            if(prod(SavedDataPrevDeltas(end-params.lbfgs_opts.autoconvergelen:end)<=params.lbfgs_opts.autoconvergethresh))
                errorLoss = 0;
                disp('Auto Converge');
                return;
            end
        end


        curTgtImg = reshape(curTgtImg,[round(params.USFac*size(SrcImg,1)),round(params.USFac*size(SrcImg,2)),size(SrcImg,3)]);
        [tgtFeatures.styleFeatures, tgtFeatures.ACorrFeatures, tgtFeatures.DiversityFeatures, tgtFeatures.SmoothnessFeatures] = CalcNetFeatures(net, curTgtImg, params);

        [errorLoss] = CalcErrorLoss(srcMats,tgtFeatures,params, 1);
         disp(['Total Loss=',num2str(errorLoss)]);
         
        if(~isempty(SavedDataPrevImg))
            CurrMaxPixDiff = max(abs(SavedDataPrevImg(:)-curTgtImg(:)));
        else
            CurrMaxPixDiff = 0;
        end
        SavedDataPrevErrors = [SavedDataPrevErrors errorLoss];
        SavedDataPrevDeltas = [SavedDataPrevDeltas CurrMaxPixDiff];
        SavedDataPrevImg    = curTgtImg;
        
        figure(100);
        subplot(2,2,1); imshow(uint8(ImDenorm(curTgtImg,net.meta.normalization.averageImage))); title('Result');
        subplot(2,2,2); imshow(uint8(ImDenorm(SrcImg,net.meta.normalization.averageImage))); title('Input');
        subplot(2,2,3); plot(1:numel(SavedDataPrevErrors),log10(SavedDataPrevErrors+1)); title('Error');
        subplot(2,2,4); plot(1:numel(SavedDataPrevDeltas),SavedDataPrevDeltas); title('Max Pixel Diffs'); ylim([0 30]);

        drawnow
        save([params.OutString,'__CurTgtImg.mat'],'curTgtImg');
         
