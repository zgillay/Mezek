% Megmutatni a NaNokat
%{
    % Disp X NaN
    for i=1:size(X,2)
        disp(Char{1,colx(i)})
        ind=isnan(X(:,i));
        disp([size(find(ind)), size(find(~ind))]) 
    end

% Disp Chem NaN
    for i=1:size(Chem,2)
        disp(Char{1,colc(i)})
        ind=isnan(Chem(:,i));
        disp([size(find(ind)), size(find(~ind))])
    end
 %}   




%%
M=X;
Mc=Xc;
clear MN
n=1;
for i=1:size(M,1)
    if ID(i,4)==10 
        MN(n,:)=M(i,:);
        n=n+1;    
    end
end

M10=MN;

clear MN
n=1;
for i=1:size(Mc,1)
    if ID(i,4)==10 
        MN(n,:)=Mc(i,:);
        n=n+1;    
    end
end
Mc10=MN;


for i=3:9    
   subplot(2,7,i-2) 
   plot(ID(:,3),M10(:,i),'.')    
end

for i=3:9    
   subplot(2,7,i-2+7) 
   plot(ID(:,3), Mc10(:,i),'.')
    
end

%%
clear MN
n=1;
for i=1:size(M,1)
    if ID(i,4)==53
        MN(n,:)=M(i,:);
        n=n+1;    
    end
end

M53=MN;

clear MN
n=1;
for i=1:size(Mc,1)
    if ID(i,4)==53 
        MN(n,:)=Mc(i,:);
        n=n+1;    
    end
end
Mc53=MN;

figure
for i=3:9    
   subplot(2,7,i-2) 
   plot(ID(:,3),M53(:,i),'.')    
end

for i=3:9    
   subplot(2,7,i-2+7) 
   plot(Mc53(:,2), Mc53(:,i),'.')
    
end




% Kiválogatni a referencia mintákat
% n=1;
% for i=1:size(M,1)
%     if M(i,3)==10 || M(i,3)==53
%         MN(n,:)=M(i,:);
%         n=n+1;    
%     end
% end
% M=MN;



% n=1;
% for i=1:size(M,1)    
%     if M(i,2)==1
%         AAA(n,:)=M(i,:);
%         n=n+1;
%         if 
%     end
%  
%     end

    
