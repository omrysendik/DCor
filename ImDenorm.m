function [ImOut] = ImDenorm(ImIn,avgRGB)

    szImg = size(ImIn);
    szAvg = size(avgRGB);

    if(isequal(szImg,szAvg))
        avgImg = avgRGB;
    else
        avgRGB = avgRGB(:);
        avgImg = repmat(permute(avgRGB,[2 3 1]),[szImg(1:2),1]);
    end

    ImOut = uint8(ImIn+avgImg);
end