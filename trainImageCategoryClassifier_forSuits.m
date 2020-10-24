%% Farshad Bolouri - Peter Wharton - Project 3 -
% Script for training Image Category Classifier
clear 
close all
%% Load Dataset
imageFolder = 'V:\Datasets\Playing Cards\Card Suits';

imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames',...
    'IncludeSubfolders',true);

%% Split Dataset for training and evaluation
[trainingSet,testSet] = splitEachLabel(imds,0.9,'randomize');

%% counting the labels
tbl = countEachLabel(imds)
disp('-------------------------------------------------------');

%% Create a Visual Vocabulary and Train an Image Category Classifier
bag = bagOfFeatures(trainingSet);
disp('-------------------------------------------------------');

%% Training Classifier
categoryClassifierSuits = trainImageCategoryClassifier(trainingSet,bag);
disp('-------------------------------------------------------');

%% Confusion Matrix
confMatrix = evaluate(categoryClassifierSuits,testSet)
disp('-------------------------------------------------------');

%% Average Accuracy for Classification
mean(diag(confMatrix))
disp('-------------------------------------------------------');

save categoryClassifierSuits3