function [net] = GenNet(LastLayerNum)

nettemp = load(strrep('.\matconvnet-1.0-beta20\PreTrainedNets\imagenet-vgg-verydeep-19.mat','\',filesep));
for Ind = 1:1:LastLayerNum
   net.layers{Ind} = nettemp.layers{Ind}; 
   if(strcmp(net.layers{Ind}.type,'pool'))
       net.layers{Ind}.method = 'avg';
   end    
end
net.meta.normalization = nettemp.meta.normalization;
