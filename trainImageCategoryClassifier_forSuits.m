%% Farshad Bolouri - Peter Wharton - Project 3 -
% Script for training Image Category Classifier
clear 
close all
%% Load Dataset
imageFolder = 'V:\Datasets\Card Suits';

imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames',...
    'IncludeSubfolders',true);

%% counting the labels
tbl = countEachLabel(imds)
disp('-------------------------------------------------------');

%% Create a Visual Vocabulary and Train an Image Category Classifier
bag = bagOfFeatures(imds);
disp('-------------------------------------------------------');

%% Training Classifier
% Due to small dataset training is going to be done on all available
% pictures and Evaluation will be done on test images from webcam
categoryClassifier = trainImageCategoryClassifier(imds, bag);

save categoryClassifier