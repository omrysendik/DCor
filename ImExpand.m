function [ImOut] = ImExpand(ImIn,params)

ImOut = cat(2,ImIn,ImIn,ImIn);
ImOut = cat(1,ImOut,ImOut,ImOut);

Width = params.USFac*size(ImIn,1);
Start = round(size(ImOut,1)/2)-round(Width/2);

ImOut = ImOut(Start:Start+Width-1,Start:Start+Width-1,:);