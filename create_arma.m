% Create ARMA features
%function create_arma(inputdataset)
%% Load input dataset
inputdataset = 'George'
f=strcat('alpha_',inputdataset,'.xlsx');
a0=readmatrix(f);

f=strcat('delta_diff_',inputdataset,'.xlsx');
d0=readmatrix(f);

f=strcat('theta_',inputdataset,'.xlsx');
t0=readmatrix(f);

f=strcat('gamma_',inputdataset,'.xlsx');
g0=readmatrix(f);

f=strcat('beta_',inputdataset,'.xlsx');
b0=readmatrix(f);

%% Read number of data sample functions
[N,M]=size(a0)  % N denotes the number of sample functions and M denotes total samples in each

%% Compute ARMA features
a1_a(1:3,1:N)=0;
b1_a(1:2,1:N)=0;
a1_b(1:3,1:N)=0;
b1_b(1:2,1:N)=0;
a1_g(1:3,1:N)=0;
b1_g(1:2,1:N)=0;
a1_d(1:3,1:N)=0;
b1_d(1:2,1:N)=0;
a1_t(1:3,1:N)=0;
b1_t(1:2,1:N)=0;

for i=1:1:N
a=a0(i,:);
a=a';
da = iddata(a,[],1);
model1 = armax(da, [2 1]);
a1_a(:,i)=get(model1,'a');
b1_a(:,i)=get(model1,'c');
mse_a(i)=model1.Report.Fit.MSE;
clear model1;

a=d0(i,:);
a=a';
da = iddata(a,[],1);
model1 = armax(da, [2 1]);
a1_d(:,i)=get(model1,'a');
b1_d(:,i)=get(model1,'c');
mse_d(i)=model1.Report.Fit.MSE;
clear model1;

a=t0(i,:);
a=a';
da = iddata(a,[],1);
model1 = armax(da, [2 1]);
a1_t(:,i)=get(model1,'a');
b1_t(:,i)=get(model1,'c');
mse_t(i)=model1.Report.Fit.MSE;
clear model1;

a=b0(i,:);
a=a';
da = iddata(a,[],1);
model1 = armax(da, [2 1]);
a1_b(:,i)=get(model1,'a');
b1_b(:,i)=get(model1,'c');
mse_b(i)=model1.Report.Fit.MSE;
clear model1;

a=g0(i,:);
a=a';
da = iddata(a,[],1);
model1 = armax(da, [2 1]);
a1_g(:,i)=get(model1,'a');
b1_g(:,i)=get(model1,'c');
mse_g(i)=model1.Report.Fit.MSE;
clear model1;
end;

a2_a=[a1_a(2:3,:);b1_a(2,:)];
a2_d=[a1_d(2:3,:);b1_d(2,:)];
a2_b=[a1_b(2:3,:);b1_b(2,:)];
a2_g=[a1_g(2:3,:);b1_g(2,:)];
a2_t=[a1_t(2:3,:);b1_t(2,:)];

% write arma parameters to a dataset 
f=strcat('alpha_ARMA_',inputdataset,'.xlsx');
writematrix(a2_a,f);
f=strcat('beta_ARMA_',inputdataset,'.xlsx');
writematrix(a2_b,f);
f=strcat('gamma_ARMA_',inputdataset,'.xlsx');
writematrix(a2_g,f);
f=strcat('delta_ARMA_',inputdataset,'.xlsx');
writematrix(a2_d,f);
f=strcat('theta_ARMA_',inputdataset,'.xlsx');
writematrix(a2_t,f);

f=strcat('alpha_ARMA_mse_',inputdataset,'.xlsx');
writematrix(mse_a,f);
f=strcat('beta_ARMA_mse_',inputdataset,'.xlsx');
writematrix(mse_b,f);
f=strcat('gamma_ARMA_mse_',inputdataset,'.xlsx');
writematrix(mse_g,f);
f=strcat('delta_ARMA_mse_',inputdataset,'.xlsx');
writematrix(mse_d,f);
f=strcat('theta_ARMA_mse_',inputdataset,'.xlsx');
writematrix(mse_t,f);
