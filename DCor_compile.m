function DCor_compile()

fprintf('Compiling L-BFGS-B');
cd L-BFGS-B-C-master/Matlab;
compile_mex;
cd ..; cd ..;

fprintf('Compiling MatConvNet');
cd matconvnet-1.0-beta20/matlab;
vl_compilenn;
cd ..; cd ..;

fprintf('Downloading Pretrained Net (VGG-19). This may take a few minutes...');
outfilename = websave('./matconvnet-1.0-beta20/PreTrainedNets/imagenet-vgg-verydeep-19.mat','https://www.dropbox.com/s/2q3w7vosvi1jpsu/imagenet-vgg-verydeep-19.mat?dl=0');

end