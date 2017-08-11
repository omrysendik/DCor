% Copyright (C) 2017 Omry Sendik
% All rights reserved.
%
% This file is part of the Deep Correlations for Texture Synthesis code and is made available under
% the terms of the BSD license (see the COPYING file).

clc;
clear all;
close all;

%%
if(0) %% Change this flag to 1 if this is the first time you run the code and need to compile it
    DCor_compile();
end
DCor_addpaths();

%% Load the images and the net
origSrcImg = imread(strrep('.\Data\Texture13.png','\',filesep));

params = GetSynthParams();
net = GenNet(params.lastLayerNum);
params.netImgSz = [225 225 3];

params.OutString = strrep('.\Data\Output\Texture13_Result','\',filesep);
params.USFac = 1; %% Upscaling factor

SrcImg = ImNorm(imresize(origSrcImg,params.netImgSz(1:2)),net.meta.normalization.averageImage);

%% Toroidal Expansion
% SrcImg = ImExpand(SrcImg,params);
% params.USFac = 1; %% For the toroidal expansion only

%% Synthesis
Verify(params);

initNoise = 0.1*randn(round(params.USFac*size(SrcImg,1)),round(params.USFac*size(SrcImg,2)),size(SrcImg,3));
curTgtImg = initNoise;
clear errorLoss;
errorLoss = [inf];

SrcMats = GetSRCMats(SrcImg,initNoise,net,params);

funloss = @(x) (GetLossFromImg(net,x,SrcImg,SrcMats,params));
fungrad = @(x) (GetGrad(net,x,SrcImg,SrcMats,params));
fun     = @(x)fminunc_wrapper( x, funloss, fungrad);
    
tgtImg = lbfgsb_mywrapper(curTgtImg,initNoise,fun,net,params);

%% Save outputs
WriteResults(tgtImg,ImDenorm(SrcImg,net.meta.normalization.averageImage),params);
