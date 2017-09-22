clc

any(isnan(Num(:,5)));

any(isnan(M(:,4)));

MN=M;

size(MN)

ind=isnan(MN(:,4));

[size(find(ind)), size(find(~ind))]

MN(ind,:)=[];

size(MN)
