%function resultsall=sp_SVM_classification(awake,anesth)
awake=readmatrix("features_george_awake5000_H.xlsx");
anesth=readmatrix("features_george_anas5000_H.xlsx");
% awake= awake';
% anesth= anesth';
K= 10;  % no. of folds

for p=1:K % K folds K times

 rng('shuffle');
 randomShuffle = randperm(size(awake,2));
 awake = (awake(:,randomShuffle));
 anesth = (anesth(:,randomShuffle)); % sp

L=size(anesth,2);  % No. of samples
indices = crossvalind('Kfold',L,K);
for i = 1:K
    test = (indices == i); train = ~test;
     X00_test=awake(:,test);
     X01_test=anesth(:,test);
     X_test=[X00_test  X01_test];
     Y_test=[zeros(1,size(X00_test,2)) ones(1,size(X01_test,2))];

     X00_train=awake(:,train);
     X01_train=anesth(:,train);
     X_train=[X00_train  X01_train];
     Y_train=[zeros(1,size(X00_train,2)) ones(1,size(X01_train,2))];

%    SVMModel = fitcsvm(X_train',Y_train','Standardize',true);
      SVMModel = fitcsvm(X_train',Y_train','Standardize',true,'KernelFunction','RBF','KernelScale','auto');
    SVMModelPosteriorProb = fitSVMPosterior(SVMModel); % 'RBF', 'gaussian', 'linear', and 'polynomial'.

    [label, probability] = predict(SVMModelPosteriorProb,X_test');
    cp = classperf(Y_test',label);
    sen(i)=cp.Sensitivity;
    spec(i)=cp.Specificity;
    acc(i)=cp.CorrectRate;
end
cp.ErrorRate
sensitivity(p)=mean(sen);
specificity(p)=mean(spec);
accuracy(p)=mean(acc);
end

resultsall=[mean(sensitivity) mean(specificity) mean(accuracy)];
tt=1; 
%return resultsall;


