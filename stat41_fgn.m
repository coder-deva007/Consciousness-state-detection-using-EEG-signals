% estimation of parameter H for nth order fgn function H=stat41_fgn(X) 

% feed signal in the row form 

function H=stat41_fgn(a1,n) 

% n=order of fGn 

n=n-1; 

a1=[a1 0 0 0]; 

len=length(a1); 

X=a1; 

flg=1; 

ct=0; 

while(flg==1) 

    n=n+1; 

    ct=ct+1; 

    N1=10;        %size of Corr. matrix 

    N2=floor((len)/N1);  %no. of blocks 

  

clear xx; 

xx=zeros(N2,1); 

for H=0.01:.0196:.99 

    ch=1/(2*(gamma(2*H+1))*abs(sin(pi*H))); 

    mf=2*H; 

    clear rf; 

    rf(1:N1)=0; 

    for i=1:1:N1 

      if n==1 

          rf(i)=ch*((abs(i))^mf+(abs(i-2))^mf - 2*(abs(i-1))^mf); 

      elseif n==2 

          rf(i)=ch*(4*(abs(i))^mf+4*(abs(i-2))^mf-6*(abs(i-1))^mf-(abs(i+1))^mf-(abs(i-3))^mf); 

      elseif n==3 

          rf(i)=ch*((abs(i+2))^mf+(abs(i-4))^mf-6*(abs(i+1))^mf-6*(abs(i-3))^mf+15*(abs(i))^mf+15*(abs(i-2))^mf-20*(abs(i-1))^mf); 

      end 

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

H=(j2-1)*.0196 + .01-n; 

if (H <= 0.06-n  && ct <= 3) 

        flg=1;   % iterate to find H 

    else  

       flg = 0;   

    end; 

end; 