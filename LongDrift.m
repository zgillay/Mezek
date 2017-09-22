function Xc=LongDrift(X, ID)
    col=[ 3 4 5 6 7 8 9];
    for m=1:24    
        n1=1;
        n2=1;
        for i=1:size(X,1)
            if ID(i,2)==m
                if ID(i,4)==10
                    S10t(n1,:)=X(i,col);
                    n1=n1+1;
                end
                if ID(i,4)==53
                    S53t(n2,:)=X(i,col);
                    n2=n2+1;
                end
            end 
        end
        S10(m,:)=mean(S10t);
        S53(m,:)=mean(S53t);
        clear S10t S53t    
    end
    
    
    
%     for i=1:7
%         figure
%         plot(S10(1:24,i))
%         figure
%         plot(S53(1:24,i))
%     end


  

    for m=2:24
        for i=1:7
            XS=[ 1 S53(m,i); 1 S10(m,i)];
            YS=[   S53(1,i);   S10(1,i) ];
            %ba{m,i}=regress(YS, XS);
            ba{m,i}=(XS'*XS)^-1*XS'*YS;
        end
    end


    % Korrekcio
    Xc=X;
    for i=1:size(Xc,1)
        m=ID(i,2);
        if m~=1
            for j=0:6                
                Xc(i,3+j)=Xc(i,3+j)*ba{m,j+1}(2)+ba{m,j+1}(1);                
            end
        end

    end
end