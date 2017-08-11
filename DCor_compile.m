function DCor_compile()

fprintf('Compiling L-BFGS-B');
cd L-BFGS-B-C-master/Matlab;
compile_mex;
cd ..; cd ..;

fprintf('Compiling MatConvNet');
cd matconvnet-1.0-beta20/matlab;
vl_compilenn;
cd ..; cd ..;

end