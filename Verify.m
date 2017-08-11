function Verify(params)

assert(mod(params.netImgSz(1),2)==1 && mod(params.netImgSz(2),2)==1,sprintf('The code currently supports only odd sized images: params.netImgSz=[%d,%d]',params.netImgSz(1),params.netImgSz(2)));
assert(params.USFac==1 || params.DiversityLossWeight==0,sprintf('If the output image size is larger than the input (params.USFac=%f), the Diversity loss shouldnt be used (params.DiversityLossWeight=%f)',params.USFac,params.DiversityLossWeight));

end