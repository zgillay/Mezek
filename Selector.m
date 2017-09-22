%  [x,y]=ginput
%  
%  I1=find(x*0.95<YA & YA<x*1.05);
%  I2=find(y*0.95<XP & XP<y*1.05);
%  ind=intersect(I1,I2);

for i=1:size(IDSA(ind),1)
    c(i,1)={' : '};
end
msgbox(cellfun(@horzcat,Char(ind+1,2), c  ,IDSA(ind), 'UniformOutput',false))
     %mgsbox()
