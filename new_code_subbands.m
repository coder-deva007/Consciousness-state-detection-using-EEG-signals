clc  

  

clear all  

  

close all  

  
inpt='George';
DataLocation = 'data_ecog\Session3_George';  

  

FileType = fullfile(DataLocation, '*.mat');  

  

dirFicheiroMat = dir(FileType);  

  

number_subjects = length(dirFicheiroMat);ETC_awake=[];LZC_awake=[];Bins=4;  

  

%Obtaining index for awake eyes open second set() in the .mat files   

  

condn=load('data_ecog\Condition_Session3_George.mat');  

  

v=fieldnames(condn);  

  

t1=getfield(condn,v{1});%get starting indices for various states;  

x=[]; 

tt=1:5000;

for j=1:2 

for i=1:100 

%baseFileName = fullfile( dirFicheiroMat(j).name); 
baseFileName = strcat("ECoG_ch", string(j),".mat");
   in_str=strcat(DataLocation,'\',baseFileName); 

    in_str=load(in_str); 

var1=fieldnames(in_str); 

  

x1=getfield(in_str,var1{1}); 

  

x=[x;x1(tt)]; 

tt=tt+5000; 

reqd_index_set1=t1(3):(t1(3)+5000);%first 100 sample data from awake eyes open series  

end 

end 
disp(size(x));
x1=x'; 

[M,N] = size(x1); 

[B,A]=butter(6,0.69,'low'); 

x2=zeros(M,N); 

for i=1:1:N 

    x2(:,i)=filter(B,A,x1(:,i)); 

end 

x1=x2'; 

[N,M]=size(x1)  % N denotes the number of sample functions and M denotes total samples in each 

if (mod(M,2)~=0) 

    x1=x1(:,1:end-1); 

    M=M-1; 

end;      

%% Extract rhythms 

x2=zeros(N,M); 

x3=zeros(N,M); 

% Filter and down sample by 2 

D=dctmtx(2); 

for i=1:N 

    x2(i,:)=filter(D(1,:),1,x1(i,:)); 

end 

for i=1:N 

    x3(i,:)=filter(D(2,:),1,x1(i,:)); 

end 

y1=zeros(N,floor(M/2)); 

y2=zeros(N,floor(M/2)); 

for i=1:N 

    y1(i,:)=downsample(x2(i,:),2); 

end 

  

% Gamma rhythms  30-60Hz 

for i=1:N 

    y2(i,:)=downsample(x3(i,:),2); 

end 

  

% filtering and downsampling by 5  

D1=dctmtx(5); 

q1=zeros(N,M/2); 

q2=zeros(N,M/2); 

q3=zeros(N,M/2); 

q4=zeros(N,M/2); 

q5=zeros(N,M/2); 

  

for i=1:N 

    q1(i,:)=filter(D1(1,:),1,y1(i,:)); 

end 

for i=1:N 

    q2(i,:)=filter(D1(2,:),1,y1(i,:)); 

end 

for i=1:N 

    q3(i,:)=filter(D1(3,:),1,y1(i,:)); 

end 

for i=1:N 

    q4(i,:)=filter(D1(4,:),1,y1(i,:)); 

end 

for i=1:N 

    q5(i,:)=filter(D1(5,:),1,y1(i,:)); 

end 

% downsampling 

y3=downsample(q1',5); 

y4=downsample(q2',5); 

y5=downsample(q3',5); 

y6=downsample(q4',5); 

y7=downsample(q5',5); 

  

% upsampling and filtering for reconstruction 

D2=fliplr(D1); 

y3=upfirdn(y3,D2(1,:),5,1); 

y4=upfirdn(y4,D2(2,:),5,1); 

y5=upfirdn(y5,D2(3,:),5,1); 

y6=upfirdn(y6,D2(4,:),5,1); 

y7=upfirdn(y7,D2(5,:),5,1); 

  

% beta rhythms  12-30Hz 

y8=y6'+y5'+y7'; 

  

% further downsampling by three 

y9=y3'+y4'; 

  

% filtering and downsampling by 3  

% Filtering and downsampling by 3  

D3 = dctmtx(3); 

q1 = zeros(N, M/2); 

q2 = zeros(N, M/2); 

q3 = zeros(N, M/2); 

  

% Preallocate d, t, and a to match the size 

d = zeros(N, M/2); 

t = zeros(N, M/2); 

a = zeros(N, M/2); 

  

for i = 1:N 

    % Filter and downsample 

    d(i, :) = filter(D3(1, :), 1, y9(i, :)); 

    t(i, :) = filter(D3(2, :), 1, y9(i, 1:M/2));  % Adjust the size of y9(i,:) here 

    a(i, :) = filter(D3(3, :), 1, y9(i, 1:M/2));  % Adjust the size of y9(i,:) here 

end 

  

% Downsampling outside the loop 

ya = downsample(d', 3); 

yb = downsample(t', 3); 

yc = downsample(a', 3); 

  

  

  

  

%delta 

d=ya'; 

d_diff=diff(d,1,2); 

%theta 

t=yb'; 

%alpha 

a=yc'; 

%beta 

b=y8; 

%gamma 

g=y2; 

  

% Conpute H of all rhythms 

for i =1:N 

    df(i)=stat41(d(i,:));  %% first order fbm 

   tf(i)=stat41_fgn(t(i,:),1);  %% first order fgn 

   af(i)=stat41_fgn(a(i,:),1);   %% first order fgn 

   gf(i)=stat41_fgn(g(i,:),1);  %% first order fgn 

   bf(i)=stat41_fgn(b(i,:),2);  %% Second order fgn 

end 

%% Write computed brain rhythms of input dataset to xls file 

% write delta and the first difference of delta


f=strcat('delta_',inpt,'.xlsx'); 

s=xlswrite(f,d); 

f=strcat('deltaH_',inpt,'.xlsx'); 

s=xlswrite(f,df); 

  

f=strcat('delta_diff_',inpt,'.xlsx'); 

s=xlswrite(f,d_diff); 

  

% write theta  

f=strcat('theta_',inpt,'.xlsx'); 

s=xlswrite(f,t); 

f=strcat('thetaH_',inpt,'.xlsx'); 

s=xlswrite(f,tf); 

  

% write alpha  

f=strcat('alpha_',inpt,'.xlsx'); 

s=xlswrite(f,a); 

f=strcat('alphaH_',inpt,'.xlsx'); 

s=xlswrite(f,af); 

  

% write beta  

f=strcat('beta_',inpt,'.xlsx'); 

s=xlswrite(f,b); 

f=strcat('betaH_',inpt,'.xlsx'); 

s=xlswrite(f,bf); 

  

% write gamma  

f=strcat('gamma_',inpt,'.xlsx'); 

s=xlswrite(f,g); 

f=strcat('gammaH_',inpt,'.xlsx'); 

s=xlswrite(f,gf); 

 

 