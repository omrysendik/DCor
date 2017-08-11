function [smoothnessErrorLoss, smoothnessGrads] = CalcSoftMinSmoothnessErrorLoss(tgtSmoothnessFeatures, params)

    numFeatLayers = length(params.SmoothnessMatchLayerInds);
    smoothnessGrads = cell(numFeatLayers,1);
    smoothnessErrorLoss = 0;
    Sig = params.SmoothnessSigma;
    for k=1:numFeatLayers
        smoothnessDiffUp    = tgtSmoothnessFeatures{k}-circshift(tgtSmoothnessFeatures{k},[-1 0]);
        smoothnessDiffDown  = tgtSmoothnessFeatures{k}-circshift(tgtSmoothnessFeatures{k},[ 1 0]);
        smoothnessDiffLeft  = tgtSmoothnessFeatures{k}-circshift(tgtSmoothnessFeatures{k},[0 -1]);
        smoothnessDiffRight = tgtSmoothnessFeatures{k}-circshift(tgtSmoothnessFeatures{k},[0  1]);

        smoothnessDiffWeight = params.SmoothnessFeatureWeights(k);

        smoothnessErrorLoss = smoothnessErrorLoss+smoothnessDiffWeight*(1/Sig)*0.5*(...
                                                                                sum(log(0.25*exp(-Sig*smoothnessDiffUp(:).^2)+...
                                                                                        0.25*exp(-Sig*smoothnessDiffDown(:).^2)+...
                                                                                        0.25*exp(-Sig*smoothnessDiffLeft(:).^2)+...
                                                                                        0.25*exp(-Sig*smoothnessDiffRight(:).^2))));
                                                                                    
        if(isinf(smoothnessErrorLoss))
            smoothnessErrorLoss=0;
            smoothnessGrads{k} = zeros(size(tgtSmoothnessFeatures{k}));
        else


            Nom1 = (smoothnessDiffUp   .*exp(-Sig*smoothnessDiffUp.^2   )+...
                    smoothnessDiffDown .*exp(-Sig*smoothnessDiffDown.^2 )+...
                    smoothnessDiffLeft .*exp(-Sig*smoothnessDiffLeft.^2 )+...
                    smoothnessDiffRight.*exp(-Sig*smoothnessDiffRight.^2));

            Den1 = (exp(-Sig*smoothnessDiffUp.^2   )+...
                    exp(-Sig*smoothnessDiffDown.^2 )+...
                    exp(-Sig*smoothnessDiffLeft.^2 )+...
                    exp(-Sig*smoothnessDiffRight.^2));

            DummyNomUp         = (circshift(tgtSmoothnessFeatures{k},[-1 0])-          tgtSmoothnessFeatures{k});
            DummyDenUpUp       = (circshift(tgtSmoothnessFeatures{k},[-1 0])-circshift(tgtSmoothnessFeatures{k},[-1-1  0]));
            DummyDenUpDown     = (circshift(tgtSmoothnessFeatures{k},[-1 0])-circshift(tgtSmoothnessFeatures{k},[-1+1  0]));
            DummyDenUpLeft     = (circshift(tgtSmoothnessFeatures{k},[-1 0])-circshift(tgtSmoothnessFeatures{k},[-1   -1]));
            DummyDenUpRight    = (circshift(tgtSmoothnessFeatures{k},[-1 0])-circshift(tgtSmoothnessFeatures{k},[-1    1]));
            NomUp = DummyNomUp.*exp(-Sig*DummyNomUp.^2);
            DenUp = exp(-Sig*DummyDenUpUp.^2)+exp(-Sig*DummyDenUpDown.^2)+exp(-Sig*DummyDenUpLeft.^2)+exp(-Sig*DummyDenUpRight.^2);

            DummyNomDown       = (circshift(tgtSmoothnessFeatures{k},[1 0])-          tgtSmoothnessFeatures{k});
            DummyDenDownUp     = (circshift(tgtSmoothnessFeatures{k},[1 0])-circshift(tgtSmoothnessFeatures{k},[1-1  0]));
            DummyDenDownDown   = (circshift(tgtSmoothnessFeatures{k},[1 0])-circshift(tgtSmoothnessFeatures{k},[1+1  0]));
            DummyDenDownLeft   = (circshift(tgtSmoothnessFeatures{k},[1 0])-circshift(tgtSmoothnessFeatures{k},[1   -1]));
            DummyDenDownRight  = (circshift(tgtSmoothnessFeatures{k},[1 0])-circshift(tgtSmoothnessFeatures{k},[1    1]));
            NomDown = DummyNomDown.*exp(-Sig*DummyNomDown.^2);
            DenDown = exp(-Sig*DummyDenDownUp.^2)+exp(-Sig*DummyDenDownDown.^2)+exp(-Sig*DummyDenDownLeft.^2)+exp(-Sig*DummyDenDownRight.^2);

            DummyNomLeft       = (circshift(tgtSmoothnessFeatures{k},[0 -1])-          tgtSmoothnessFeatures{k});
            DummyDenLeftUp     = (circshift(tgtSmoothnessFeatures{k},[0 -1])-circshift(tgtSmoothnessFeatures{k},[-1 -1  ]));
            DummyDenLeftDown   = (circshift(tgtSmoothnessFeatures{k},[0 -1])-circshift(tgtSmoothnessFeatures{k},[+1 -1  ]));
            DummyDenLeftLeft   = (circshift(tgtSmoothnessFeatures{k},[0 -1])-circshift(tgtSmoothnessFeatures{k},[0  -1-1]));
            DummyDenLeftRight  = (circshift(tgtSmoothnessFeatures{k},[0 -1])-circshift(tgtSmoothnessFeatures{k},[0  -1+1]));
            NomLeft = DummyNomLeft.*exp(-Sig*DummyNomLeft.^2);
            DenLeft = exp(-Sig*DummyDenLeftUp.^2)+exp(-Sig*DummyDenLeftDown.^2)+exp(-Sig*DummyDenLeftLeft.^2)+exp(-Sig*DummyDenLeftRight.^2);

            DummyNomRight      = (circshift(tgtSmoothnessFeatures{k},[0 1])-          tgtSmoothnessFeatures{k});
            DummyDenRightUp    = (circshift(tgtSmoothnessFeatures{k},[0 1])-circshift(tgtSmoothnessFeatures{k},[-1  1]));
            DummyDenRightDown  = (circshift(tgtSmoothnessFeatures{k},[0 1])-circshift(tgtSmoothnessFeatures{k},[+1  1]));
            DummyDenRightLeft  = (circshift(tgtSmoothnessFeatures{k},[0 1])-circshift(tgtSmoothnessFeatures{k},[0   1-1]));
            DummyDenRightRight = (circshift(tgtSmoothnessFeatures{k},[0 1])-circshift(tgtSmoothnessFeatures{k},[0   1+1]));
            NomRight = DummyNomRight.*exp(-Sig*DummyNomRight.^2);
            DenRight = exp(-Sig*DummyDenRightUp.^2)+exp(-Sig*DummyDenRightDown.^2)+exp(-Sig*DummyDenRightLeft.^2)+exp(-Sig*DummyDenRightRight.^2);

            smoothnessGrads{k}  = smoothnessDiffWeight*(-Nom1./Den1+NomUp./DenUp+NomDown./DenDown+NomLeft./DenLeft+NomRight./DenRight);
        end

    end
