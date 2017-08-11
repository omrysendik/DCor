function [ params ] = GetSynthParams()

params.styleMatchLayerInds = [5 10 19 28];
params.styleFeatureWeights = [1 1 1 1];

params.ACorrMatchLayerInds = [10];
params.ACorrFeatureWeights = [1];

params.SmoothnessMatchLayerInds = [1];
params.SmoothnessFeatureWeights = [1];

params.DiversityMatchLayerInds = [10];
params.DiversityFeatureWeights = [1];

params.styleFeatureWeights      = params.styleFeatureWeights./sum(params.styleFeatureWeights);
params.ACorrFeatureWeights      = params.ACorrFeatureWeights./sum(params.ACorrFeatureWeights);
params.DiversityFeatureWeights  = params.DiversityFeatureWeights./sum(params.DiversityFeatureWeights);
params.SmoothnessFeatureWeights = params.SmoothnessFeatureWeights./sum(params.SmoothnessFeatureWeights);
params.SmoothnessSigma          = 0.0001;
%%
params.lastLayerNum = max([params.styleMatchLayerInds params.ACorrMatchLayerInds params.SmoothnessMatchLayerInds params.DiversityFeatureWeights]);
params.unitedLayerInds = unique(sort([params.styleMatchLayerInds params.ACorrMatchLayerInds params.SmoothnessMatchLayerInds params.DiversityMatchLayerInds]));

% params.NormGrads = 0;
% params.NormLosses = 0;
params.Verbose = 1;
params.NNVerbose = 1;

%% Hyper Params
params.styleLossWeight = 0.5;
params.ACorrLossWeight =  0.5*1E-4;
params.SmoothnessLossWeight = -0.0000075;
params.DiversityLossWeight =  -1*1E-6;

%% LBFGSB opts
params.lbfgs_opts.factr = 1e7;
params.lbfgs_opts.pgtol = 1e-5;
params.lbfgs_opts.printEvery = 5;
params.lbfgs_opts.maxIts = 300;
params.lbfgs_opts.m  = 5;
params.lbfgs_opts.autoconverge = 1;
params.lbfgs_opts.autoconvergelen = 50;
params.lbfgs_opts.autoconvergethresh = 0.5;


end

