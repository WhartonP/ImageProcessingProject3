
directory = 'V:\Datasets\Playing Cards\SuitRankTests\2';
load categoryClassifierRanks3
load categoryClassifierSuits2

% Using Both Category Classifiers
if ~isempty(directory)
    ImageSet = dir(fullfile(directory,'*.jpg'));
    for i = 1:numel(ImageSet)
        image = imadjust(imread(fullfile(directory,ImageSet(i).name)));
        imshow(image)
        [labelIdx, scores] = predict(categoryClassifier, image);
        [labelIdx2, ~] = predict(categoryClassifierSuits, image);
        Rank = categoryClassifier.Labels(labelIdx);
        Suit = categoryClassifierSuits.Labels(labelIdx2);
        T = sprintf("Rank: %s  /  Suit: %s", Rank{1}, Suit{1});
        title(T);
        saveas(gcf,"V:\Datasets\Playing Cards\SuitRankTests\2\FinalResults1\Result " + sprintf("%d.jpg",i)); 
        disp("------------------------------Next-------------------------------");
        %pause;
    end
    close
end
%% Using CNN
% if ~isempty(directory)
%     ImageSet = dir(fullfile(directory,'*.jpg'));
%     for i = 1:numel(ImageSet)
%         image = imadjust(imread(fullfile(directory,ImageSet(i).name)));
%         imshow(image)
%         labelCNN = classify(net, imresize(image,[128 128]));
%         T = sprintf("Rank: %s ", labelCNN);
%         title(T);
%         saveas(gcf,sprintf("Result %d.jpg" ,i)); 
%         disp("------------------------------Next-------------------------------");
%         %pause;
%     end
%     close
%end