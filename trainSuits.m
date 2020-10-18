clear 
close all
%% Load Training Data
imageFolder = 'V:\Datasets\Card Suits';

%augmenter = imageDataAugmenter('RandRotation',[0 360], 'RandScale',[0.5 1]);

imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames',...
    'IncludeSubfolders',true);

% Load pretrained Network
net = resnet50();

[trainingSet, testSet] = splitEachLabel(imds, 0.8, 'randomize');

%augmenter = imageDataAugmenter('RandRotation',[0 360],'RandScale',[0.5 1]);

imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet,...
    'ColorPreprocessing', 'gray2rgb');%, 'DataAugmentation',augmenter);
augmentedTestSet = augmentedImageDatastore(imageSize, testSet,...
    'ColorPreprocessing', 'gray2rgb');

featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Get training labels from the trainingSet
trainingLabels = trainingSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

% Extract test features using the CNN
testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))

% Display the mean accuracy
mean(diag(confMat))

%testImage = readimage(testSet,1);
%testLabel = testSet.Labels(1)

load cropped2
% Create augmentedImageDatastore to automatically resize the image when
% image features are extracted using activations.
ds = augmentedImageDatastore(imageSize, cropped2, 'ColorPreprocessing', 'gray2rgb');

% Extract image features using the CNN
imageFeatures = activations(net, ds, featureLayer, 'OutputAs', 'columns');

% Make a prediction using the classifier
predictedLabel = predict(classifier, imageFeatures, 'ObservationsIn', 'columns')

save classifier
