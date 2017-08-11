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
FolderToDl = [cd,'/matconvnet-1.0-beta20/PreTrainedNets/imagenet-vgg-verydeep-19.mat'];
unix(['wget -O ',FolderToDl,' https://www.dropbox.com/s/ndyqhp4umkpww8t/imagenet-vgg-verydeep-19.mat?dl=0 --no-check-certificate']);

end