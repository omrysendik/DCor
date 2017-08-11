function [gramMat featVec] = CalcGramMatrix(featMat)
    szFeatMat = size(featMat);
    if(length(szFeatMat)==2) szFeatMat(3)=1; end
    featVec = reshape(permute(featMat,[3,1,2]),szFeatMat(3),prod(szFeatMat(1:2)));
    gramMat = featVec*featVec';
end