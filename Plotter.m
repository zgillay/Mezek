function Plotter( h,o, XP, YA, IDSA, Char )


     [x,y]=ginput
     
  
 
     I1=find(x(end)*0.95<YA & YA<x(end)*1.05);
     I2=find(y(end)*0.95<XP & XP<y(end)*1.05);
     ind=intersect(I1,I2);
    c=cell(size(IDSA(ind),1),1);
    for i=1:size(IDSA(ind),1)
        c(i,1)={' : '};
    end
    drawnow
    msgbox(cellfun(@horzcat,Char(ind+1,2), c  ,IDSA(ind), 'UniformOutput',false))

end

