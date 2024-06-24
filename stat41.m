% estimation of parameter H for self similar signal 

% feed signal in the row form 

function H=stat41(a1) 

  

a1=[a1 0 0 0]; 

len=length(a1); 

flg=1; 

ct=0; 

n=0; 

while(flg==1) 

    ct=ct+1; 

    n=n+1;  %input('Enter the value of n: '); 

    N1=7;  %size of Corr. matrix 

    N2=floor((len)/N1);  %no. of blocks 

    if N2 > 30 

         N2=30; 

    end; 

  

    % Compute 1-fGn sample function 

    clear X; 

    if n ~= 0 

        X(1:len-n)=0; 

        pp=0; 

        for m=1:1:len-n 

            for j=0:1:n 

                X(m)=X(m)+ ((-1)^(n-j))*(factorial(n)/(factorial(j)*factorial(n-j)))*a1(m+j); 

            end; 

        end; 

    else 

        pp=-1; 

        n=1; 

        X=a1; 

    end; 

  

    clear xx; 

    % compute the autocorrelation of 1-fGn 

    xx=zeros(N2,1); 

    for H=(n-1)+0.01:.0196:(n-1)+.99 

        ch=1/(2*(gamma(2*H+1))*abs(sin(pi*H))); 

        mf=2*H; 

        clear rf; 

        rf(1:N1)=0; 

      for i=1:1:N1 

       for j=-n:1:n 

        rf(i)=rf(i)+((-1)^n)*ch*((-1)^j)*(factorial(2*n)/(factorial(n+j)*factorial(n-j)))*((abs(i+j-1)))^mf; 

       end; 

    end; 

        clear R; 

        R=rf; 

        for i=2:1:N1 

            R=[R;rf(i) R(i-1,1:N1-1)]; 

        end; 

        R1=inv(R); 

        det_R=det(R); 

        clear xx1; 

        for j=1:1:N2 

            ind1=(j-1)*N1+1; 

            ind2=ind1+N1-1; 

            XX=X(ind1:ind2); 

            tem=0; 

            tem=-N1*log10((XX*R1*XX')/N1)-log10(det_R); 

            xx1(j)=tem; 

        end; 

        xx=[xx xx1']; 

    end; 

    [r c]=size(xx); 

    xx=(xx(:,2:c)); 

  

    if N2 > 1 

        xx2=sum(xx)/N2; 

    else 

        xx2=xx; 

    end; 

  

    [j1 j2]=max(real(xx2)); 

    H=(j2-1)*.0196 + (n-1)+.01+pp; 

%     plot(real(xx2)); 

    if (H >= (0.98+(n-1))  && ct <= 3) 

        flg=1;   % iterate to find H 

    elseif (H <= 0.06) 

        H=stat41_fgn(a1,1); flg=0; 

    else 

       flg = 0;   

    end; 

end; 

 