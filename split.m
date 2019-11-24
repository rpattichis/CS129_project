%% Project
% load GT.mat
% load GT_labels.mat
% genres={'blues', 'classical','country','disco','hiphop', 'jazz', 'metal', 'pop','reggae','rock'};

%%
a=.8;b=.1;c=.1;
[X_tr,Y_tr,X_val,Y_val,X_test,Y_test] = split_samples(matrix,label,a,b,c);
[X_tr,Y_tr,X_val,Y_val,X_test,Y_test] = shuffle(X_tr,Y_tr,X_val,Y_val,X_test,Y_test);
%%
Y_Train = categorical(genres(Y_tr))';
Y_Val = categorical(genres(Y_val))';
Y_Test = categorical(genres(Y_test))';

names = categorical(genres(unique(Y_tr)));

Train_table = countLabels(Y_tr, names)
Validation_table = countLabels(Y_val, names)
Test_table = countLabels(Y_test, names)
%%
% for k=[10]
%     knn(X_tr', X_val', Y_tr', Y_val', k, 1);
% end

%%
numTrain = length(Y_tr);
numVal = length(Y_val);
numTest = length(Y_test);
numChannels = 1;

X_Train = zeros(numCoeff,numFreq,  numChannels, numTrain);
X_Val = zeros(numCoeff,numFreq, numChannels, numVal);
X_Test = zeros(numCoeff,numFreq, numChannels, numTest);

for i =1:numTrain
    X_Train(:,:,i) = reshape(X_tr(:,i), [numCoeff,numFreq, numChannels]);
end
for i =1:numVal
    X_Val(:,:,i) = reshape(X_val(:,i), [numCoeff,numFreq,numChannels]);
end

for i =1:numTest
    X_Test(:,:,i) = reshape(X_test(:,i), [numCoeff,numFreq,numChannels]);
end

%%
num_classes = length(genres);
layers = [imageInputLayer([numCoeff,numFreq, 1])
            fullyConnectedLayer(2000)
            fullyConnectedLayer(1000)
            fullyConnectedLayer(500)
            fullyConnectedLayer(250)
            fullyConnectedLayer(num_classes)
            softmaxLayer
            classificationLayer()];



miniBatchSize = 8;
options = trainingOptions( 'sgdm',...
    'MiniBatchSize', miniBatchSize,...
    'Plots', 'training-progress',...
    'MaxEpoch',20,'ValidationData',{X_Val,Y_Val});
net = trainNetwork(X_Train, Y_Train, layers, options);	
%% Test Validation accuracy
predLabelsTest = net.classify(X_Val);
Validation_accuracy = sum(predLabelsTest == Y_Val) / numel(Y_Val)
%% Test Test Accuracy
predLabelsTest = net.classify(X_Test);
Test_accuracy = sum(predLabelsTest == Y_Test) / numel(Y_Test)
