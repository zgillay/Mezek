clc
clear variables
%close all
tic


% Day hova tegyem
% Mi lehet rossz
    % Szamolok-e azzal, hogy 24 van
    % Long korrekcio

% Lecsapni az elso harom merest
% Napi korrekció

disp('Started')
[Num,Char]=xlsread('fulldata(3201).xls');
%size(Num)
%size(Char)
%size(Data)

%<<<<<<<<<<<<Sort Columns Togethet>>>>>>>>>>>>>>
% X Matrix
    %    PH  vezk ZZ JE BB CA GA HA JB
    colx=[ 22 24 25 26 27 28 29 30 31];
    X=Num(:,colx);
    %size(X)

% Chemical Matrix
        % TPC CUPRAC ABTS FRAP Hamu
    colc=[13 14 15 16 21];
    Chem=Num(:,colc);
    %size(Chem)

   

% ID Matrix
    % Num  day smplRep smplNr repeats
    coli=[1 6 7 8 5];
    ID=Num(1:end,coli);
    
% String type IDs
    %Smpname noveredet
    cols=[3 9];
    IDS=Char(2:end,cols);
 
% <<<<<<<<<<<Sulyos outlierek kivagasa>>>>>>>>>>>>>>>   
% Van 27 minta aminek minden kemiai parametere NaN  (2592)  2511
    ind=isnan(X(:,1));
    Chem(ind,:)=[];
    X(ind,:)=[];
    ID(ind,:)=[];
    IDS(ind,:)=[];
    
%<<<<<<<<<<<<<<<<<<Control Panel>>>>>>>>>>>>>>>>   
% Control panel meghivasa
    Mezek = unique(IDS(:,2));
    Szenzorok=Char(1,25:end);
    a=ControllPanel(Mezek,Szenzorok); 
    disp(a)

    
    
% Elso harom nap kihagyasa a Control alapjan   
    if a.Kihagy3
        for i=1:3
            ind=(ID(:,5)==i);
            Chem(ind,:)=[];
             X(ind,:)=[];
            ID(ind,:)=[];
            IDS(ind,:)=[];
        end
    end
    
    
% Drift correcio a Control alapjan
    if a.Drift
        X0=X;
        X=LongDrift(X, ID);
    end
    
    
% Mezek kivalasztasa a Control panel alapjan
      for i=1:size(a.mez,2)
          if ~a.mez(i)
            ind=strcmp(IDS(:,2),Mezek(i));
            Chem(ind,:)=[];
            X(ind,:)=[];
            ID(ind,:)=[];
            IDS(ind,:)=[];            
          end
      end
      
      
  % Napok kivalasztasa a Control alapjan
      for i=1:size(a.nap,2)
          if ~a.nap(i)
            ind=(ID(:,2)==i);
            Chem(ind,:)=[];
            X(ind,:)=[];
            ID(ind,:)=[];
            IDS(ind,:)=[];            
          end
      end
  
      

% Atlagol a Control alapjan
    if a.Atlagol
        Samples=unique(IDS(:,1));
        for i=1:size(Samples,1)
            try
              ind=find(strcmp(Samples{i},IDS(:,1)));
              XC(i,:)=mean(X(ind,:));
              ChemC(i,:)=Chem(ind(1),:);
              IDC(i,:)=ID(ind(1),:);
              IDSC(i,:)=IDS(ind(1),:);
            catch ME
                i
                MEError(ME)
                keyboard
            end
    %         if 6<size(ind,1)
    %             disp([ Samples{i} '   ' num2str(size(ind,1))])
    %         end

        end
        X=XC;
        ID=IDC;
        IDS=IDSC;
        Chem=ChemC;
    end
 
    
    % Delete sensor based on Control panel
        for i=size(a.szenzorok,2):-1:1
            if ~a.szenzorok(i)
                disp([Szenzorok{i} ' delelted'])
                X(:,i+2)=[];   
            end
        end

        
    % Delete Vez based on Control panel
    if ~a.Vez
        X(:,2)=[];
    end

    % Delete Ph based on Control panel
    if ~a.Ph
        X(:,1)=[];
    end
    
%<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>    
% MLR
for n=0:0
    h=figure('units','normalized','outerposition',[0 0 1 1]);
    if n~=0  
        set(h,'Name',Char{1,colx(n)})
    else
        set(h,'Name','full')
    end
    

    
    for i=1:5
        YA=Chem(:,i);
        XA=X;
        
        %NaN talanitas
        ind=isnan(YA);
        YA(ind,:)=[];
        XA(ind,:)=[];
        IDA=ID;
        IDA(ind,:)=[];
        IDSA=IDS;
        IDSA(ind,:)=[];
        
        % Hamu kiugrok
        if i==5
            ind=find(YA<0 | YA>0.8);
            YA(ind,:)=[];
            XA(ind,:)=[];
            IDA(ind,:)=[];
            IDSA(ind,:)=[];
        end
        
        
        % ABTS 29-43 minták rosszak
        if i==3
            ind=find( 28<IDA(:,4) &  IDA(:,4)<44);
            YA(ind,:)=[];
            XA(ind,:)=[];
            IDA(ind,:)=[]; 
            IDSA(ind,:)=[];
        end
        
        
        % Szenzor kiahagyas a for ciklus szerint
        if n~=0            
            XA(:,n)=[];
        end

        
         % Regression es becsles
         XA=[XA  ones(size(XA,1),1)];
         b=(XA'*XA)^-1*XA'*YA;
         XP=XA*b;

         % Abrazolas
         subplot(2,3,i)
            leg={};
            Mezek = unique(IDSA(:,2));
            for mez=1:size(Mezek,1)
                ind=strcmp(IDSA(:,2),Mezek(mez));
                plot(YA(ind),XP(ind),'.','ButtonDownFcn',{@Plotter, XP, YA, IDSA(:,2), Char}) 
                
                hold all
                leg=[leg Mezek(mez) ];
            end
            legend(leg,'Location','EastOutside')

            plot([min(YA)  max(YA)],[min(YA)  max(YA)],'k')
            st(n+1,1)=std(YA-XA*b);
            st(n+1,2)=n;
  
            title([Char{1,colc(i)} ' ' Round2Str(std(YA-XA*b),2) ])
            set(gca,'ButtonDownFcn',{@Plotter, XP, YA, IDSA(:,2), Char})
    end

end

subplot(2,3,6)
set(gca,'xtick',[],'ytick',[],'box','on')
 xlim([1 100])
 ylim([1 100])
Names=fieldnames(a);
text(2,90,'Set Values on Control Panel','FontWeight','bold')
n=0;
for i=[1 2 8 3 4 5 7 6]
    text(2,80-n*10,[ Names{i} ': ' num2str(a.(Names{i}))],'Fontsize',8)  
    n=n+1;
end
disp('Done')
toc





%{
1 Num
2 fname
3 smplName
4 smplPos
5 repeats
6 day
7 smplRep
8 smplNr
9 novenyi_eredet
10 Megye
11 eu_nemeu
12 kereskedelmi_termeloi
13 TPC
14 cuprac
15 ABTS
16 FRAP
17 L
18 A
19 B
20 Hamu
21 Hamu_.
22 PH
23 refrakcio
24 el._vez._kepesseg
25 ZZ
26 JE
27 BB
28 CA
29 GA
30 HA
31 JB

for i=1:size(Char,2)    
    disp([num2str(i) ' ' Char{1,i} ': ' Char{2,i}])    
end

disp([Char(1,col)])
%}
