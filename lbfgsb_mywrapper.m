function [tgtImg] = lbfgsb_mywrapper(curTgtImg,SrcImg,fun,net,params)

[l,u] = GetOptBounds(SrcImg);

params.Decomp.Method = 'Normal';
params.lbfgs_opts.x0 = double(curTgtImg(:));

clear global;
global SavedDataPrevErrors;
global SavedDataPrevDeltas;
global SavedDataPrevImg;

[xk, ~, inform] = lbfgsb(fun, l, u, params.lbfgs_opts );

tgtImg = reshape(xk,size(SrcImg));
tgtImg = uint8(ImDenorm(tgtImg,net.meta.normalization.averageImage));
disp('Done LBFGSB');

end