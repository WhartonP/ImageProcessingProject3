%Project three for image processing by Peter Wharton and Farshad Bolouri
%Program that takes opens a webcam and takes a picture of a playing card,
%processes it and then displays the rank and suite of the card. 
clear; close all; 

%finds and opens the webcam to take the pictures
% cams = webcamlist;
% cam = webcam(cams{1});
% disp('Press space to take the picture')
% preview(cam);
% pause()
% imOrig = rgb2gray(snapshot(cam));


imageNum = 0;

for k = 2545:2596
imOrig = rgb2gray(imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/TestImages/IMG_' num2str(k) '.jpeg']));
% imOrig = rgb2gray(imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/TestImages/IMG_2556.jpeg']));
% imshow(imOrig);

%Testing Dr. Sarrafs code - works for rotation 

%binarize and smooths the image
imBin = double(imbinarize(imOrig));
imSmooth = imgaussfilt(imBin, 10);

% figure; imshow(imBin);

% stats = regionprops(imBin, 'BoundingBox');
% for i = 1:length(stats)
%     rectangle('Position',stats.BoundingBox(i,:),'EdgeColor','r'); 
% end
% imCrop = imcrop(imSmooth, stats.BoundingBox);

%uses the gradient direction to find the angle 
[Gmag, Gdir] = imgradient(imSmooth);
Gdir(Gdir < 0) = Gdir(Gdir < 0) + 180;
figure; hist = histogram(Gdir, 'BinWidth', 4);
hist.BinCounts(1) = 0;
[v, i] = max(hist.BinCounts);
rot_ang = 180 - ((hist.BinEdges(i + 1) + hist.BinEdges(i)) / 2);

%rotates and shows the rotated image
imRot = imrotate(imOrig, rot_ang, 'crop');
% imshow(imRot);

%From orginal code for cropping
%Crops the image - for working program
imBinOrig2 =  imbinarize(imRot, .6);
stats = regionprops(imBinOrig2, 'BoundingBox', 'Area');
areas = stats.Area;
[val,ind] = max([stats.Area]);
bboxes=stats(ind).BoundingBox;
% imshow(imBinOrig2);
% for i = 1:length(stats)
%     rectangle('Position',stats(i).BoundingBox,'EdgeColor','r');
%     pause()
% end
finalImage = imcrop(imRot, bboxes);

segImg = imbinarize(finalImage);
segImg = imcomplement(segImg);
connLabel = bwlabel(segImg);
[Gmag2, Gdir2] = imgradient(connLabel);
Gdir2(Gdir2 < 0) = Gdir2(Gdir2 < 0) + 180;
connLabel2 = bwlabel(Gdir2);
figure; hist2 = histogram(Gdir2, 'BinWidth', 4);
hist2.BinCounts(1) = 0;

stats2 = regionprops(segImg, 'Area', 'BoundingBox');
croppedImages = cell(size(stats2, 1), 2);
count = 0;

% figure; imshow(segImg);

% for i = 1:length(stats2)
%     rectangle('Position',stats2(i).BoundingBox,'EdgeColor','r');
% %     pause()
% end

for j = 1 : length(stats2)
    thisBB = stats2(j).BoundingBox;
    croppedImages{j,2} = thisBB(3) / thisBB(4);
    rectangle('Position', thisBB,'EdgeColor','r')
    if count >= 2
        break
    elseif croppedImages{j,2} < 1 && croppedImages{j,2} > 0.5 && ...
                            stats2(j).Area > 300 && stats2(j).Area < 10000
        if count == 1
            rank = imcrop(finalImage, thisBB);
            imwrite(rank, ['CardRank' num2str(imageNum) '.jpg']);
            imageNum = imageNum + 1;
        elseif count == 0
            suit = imcrop(finalImage, thisBB);
            imwrite(suit, ['CardSuit' num2str(imageNum) '.jpg']);
            imageNum = imageNum + 1;
        end
        croppedImages{j,1} = imcrop(finalImage, (thisBB + 8));
        croppedImages{j,1} = imadjust(croppedImages{j,1});
        count = count + 1;
    end
end

end

close all
figure 
imshow(rank);
figure 
imshow(suit);

digits = {};
while isempty(digits)
    %To get the rank of the card
    figure('Name', 'Rank'); imshow(rank);
    Enhanced3 = imadjust(rank);
    binary4 = imbinarize(Enhanced3);
    results = ocr(binary4,'TextLayout','Block');
    regularExpr = '\d';
    % Get bounding boxes around text that matches the regular expression
    bboxes = locateText(results,regularExpr,'UseRegexp',true);
    digits = regexp(results.Text,regularExpr,'match');
    if isempty(digits)
        temp = rank;
        rank = suit;
        suit = rank;
    end
end

% draw boxes around the digits
% Idigits = insertObjectAnnotation(R,'rectangle',STATS3.BoundingBox(10,:),digits);
% 
% figure; 
% imshow(Idigits);

%--------------------------------------------------------------------------
load categoryClassifier

% cropped2 = imcrop(R, STATS3.BoundingBox(20,:));
figure('Name', 'Suit'); imshow(suit);

[labelIdx, ~] = predict(categoryClassifier, suit);

%--------------------------------------------------------------------------

predictSuit = categoryClassifier.Labels(labelIdx);


disp(digits{1,1}); 
disp(predictSuit);
% RankSuit = insertObjectAnnotation(rank,'rectangle',...
%     [STATS3.BoundingBox(20,:);STATS3.BoundingBox(10,:)],...
%     [categoryClassifier.Labels(labelIdx) digits]);
% imshow(RankSuit);
