function [] = WriteResults(TgtImg,SrcImg,params)

Pad = size(TgtImg,1)-size(SrcImg,1);
if(Pad~=0)
    SrcImg = cat(1,zeros(floor(Pad/2),size(SrcImg,2),3) ,SrcImg,zeros(Pad-floor(Pad/2),size(SrcImg,2),3)  );
    SrcImg = cat(2,zeros(size(TgtImg,1) ,floor(Pad/2),3),SrcImg,zeros(size(TgtImg,1)  ,Pad-floor(Pad/2),3));
end

OutImg = cat(2,SrcImg,...
               zeros(size(TgtImg,1),20,3),...
               TgtImg);

imwrite(OutImg,[params.OutString,'.jpg']);

figure(100);
box off;
set(gca,'xcolor',get(gcf,'color'));
set(gca,'xtick',[]);
set(gca,'ycolor',get(gcf,'color'));
set(gca,'ytick',[]);
print(params.OutString, '-depsc');

save([params.OutString,'.mat'],'TgtImg');

writetable(struct2table(params),[params.OutString,'.txt']);
fprintf('Wrote output image\n');