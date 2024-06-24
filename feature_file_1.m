% merge all features and create one feature file
%function feature_file_1(inputdataset)
inputdataset = 'George'
%% read features
f=strcat('alphaH_',inputdataset,'.xlsx');
ah=readmatrix(f);



f=strcat('alpha_ARMA_',inputdataset,'.xlsx');
af=readmatrix(f);

f=strcat('betaH_',inputdataset,'.xlsx');
bh=readmatrix(f);
f=strcat('beta_ARMA_',inputdataset,'.xlsx');
bf=readmatrix(f);


f=strcat('gammaH_',inputdataset,'.xlsx');
gh=readmatrix(f);
f=strcat('gamma_ARMA_',inputdataset,'.xlsx');
gf=readmatrix(f);


f=strcat('deltaH_',inputdataset,'.xlsx');
dh=readmatrix(f);
f=strcat('delta_ARMA_',inputdataset,'.xlsx');
df=readmatrix(f);


f=strcat('thetaH_',inputdataset,'.xlsx');
th=readmatrix(f);
f=strcat('theta_ARMA_',inputdataset,'.xlsx');
tf=readmatrix(f);


%fea=[af;bf(1:2,:);gf;df;tf];
fea=[af;bf(1:2,:);gf;df;tf;ah;bh;gh;dh;th];
f=strcat('features_',inputdataset,'.xlsx');
writematrix(fea,f);

