function [l,u] = GetOptBounds(SrcImg)

% maxR = max(max(SrcImg(:,:,1))); minR = min(min(SrcImg(:,:,1)));
% maxG = max(max(SrcImg(:,:,2))); minG = min(min(SrcImg(:,:,2)));
% maxB = max(max(SrcImg(:,:,3))); minB = min(min(SrcImg(:,:,3)));

maxR = 255; minR = -255;
maxG = 255; minG = -255;
maxB = 255; minB = -255;

l = cat(3,minR*ones(size(SrcImg,1),size(SrcImg,2)),minG*ones(size(SrcImg,1),size(SrcImg,2)),minB*ones(size(SrcImg,1),size(SrcImg,2)));
u = cat(3,maxR*ones(size(SrcImg,1),size(SrcImg,2)),maxG*ones(size(SrcImg,1),size(SrcImg,2)),maxB*ones(size(SrcImg,1),size(SrcImg,2)));
l = double(l(:));
u = double(u(:));

end