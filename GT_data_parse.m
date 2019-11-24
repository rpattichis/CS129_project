genres={'blues', 'classical','country','disco','hiphop', 'jazz', 'metal', 'pop','reggae','rock'};

location = fullfile('D:\','genres');
ads = audioDatastore(location,'IncludeSubFolders',true,...
    'LabelSource','foldernames');
countEachLabel(ads)
%%
%Shuffle
rng(100);
ads = shuffle(ads);
[adsTrain,adsVal,adsTest] = splitEachLabel(ads,0.8, .1, .1);
countEachLabel(adsTrain)
countEachLabel(adsVal)
countEachLabel(adsTest)
%% Go through all files
idx = 1;
decimate = 1;
numChannels = 1;
numCoeff = 14;
f=3970;
numFreq = f;
numEx = length(genres)*100;
matrix = zeros(numChannels*f*numCoeff/decimate +f, numEx);
label = zeros(numEx, 1);



myDir = 'D:\genres\';
myFiles = dir(fullfile(myDir,'*')); 
for k = 1:length(genres)
  baseFileName = genres{k};
  subDir = strcat(myDir, baseFileName);
  subFiles = dir(fullfile(subDir,'*.wav')); %gets all wav files in struct
  for j =1:length(subFiles)
    subBaseFileName = strcat(subDir,'\');
    subBaseFileName = strcat(subBaseFileName,subFiles(j).name);
    if(mod(idx,100)==0)
        fprintf(1, 'Now reading %s\n', subBaseFileName);
    end
    try
        [y,Fs] = audioread(subBaseFileName);
        label(idx) = k;
        OVERLAPLENGTH = round(Fs*.03*.75);
        WINDOWLENGTH = round(Fs*.03);
        f0 = pitch(y,Fs, 'WindowLength',WINDOWLENGTH,'OverlapLength',OVERLAPLENGTH); 
        
        
        coeff = mfcc(y,Fs, 'WindowLength',WINDOWLENGTH, 'OverlapLength', OVERLAPLENGTH, 'NumCoeffs',numCoeff,'LogEnergy','Replace'); 
        
        coeffs = [f0(1:f), coeff(1:f,:,1)];
        
        matrix(:,idx) = coeffs(:);
        idx = idx+1;
    catch
        fprintf('Skipping %s\n', subBaseFileName);
        size(f0), size(coeff)
    end
  end
end
%%
save GT.mat matrix -v7.3
save('GT_labels.mat', 'label', 'numChannels', 'numFreq', 'numCoeff', 'numEx')
