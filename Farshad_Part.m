%% Farshad Bolouri - R11630884 - Image Processing - Project 2
clear
close all
%Image = inputdlg("Enter your filename:" + newline + ...%
%"For example: V:\Image-Processing-Projects\ImageSet2\Testimage2.tif");
Image = imread("V:\Image-Processing-Projects\ImageSet2\Testimage1.tif");
%% 
blurred = imgaussfilt(Image);

binary = imbinarize(blurred);

BW = edge(binary,'Canny');

STATS = regionprops('table',BW,'Orientation','Area');
[~,k] = max(STATS.Area);
if STATS.Orientation(k) < 45
    R = imrotate(Image,90 - STATS.Orientation(k));
else
    R = imrotate(Image,STATS.Orientation(k));
end

Enhanced = imadjust(R);

binary2 = im2bw(Enhanced,0.83);

BW2 = edge(binary2,'Canny');

STATS2 = regionprops('table',BW2,'Area','BoundingBox');
[~,k] = max(STATS2.Area);
R = imcrop(R,STATS2.BoundingBox(k,:));
%figure
imshow(R);

%--------------------------------------------------------------------------
hold on
%R = imcrop(R,[0 0 floor(size(R,2)/2) floor(size(R,1)/2)]);
Enhanced2 = imadjust(R);

binary3 = imbinarize(Enhanced2);


BW3 = edge(binary3,'Canny');

STATS3 = regionprops('table',BW3,'Area','BoundingBox');
[~,k] = max(STATS3.Area);
STATS3(k,:) = [];
for i = 1:length(STATS3.BoundingBox)
        rectangle('Position',STATS3.BoundingBox(i,:),'EdgeColor','r'); 
end


%--------------------------------------------------------------------------
load categoryClassifierRanks

cropped = imcrop(R, [STATS3.BoundingBox(3,1) - 8 , STATS3.BoundingBox(3,2) - 8 ,...
    STATS3.BoundingBox(3,3) + 16, STATS3.BoundingBox(3,4) + 16]);

[labelIdx, scores] = predict(categoryClassifier, cropped);


%--------------------------------------------------------------------------
load categoryClassifierSuits

cropped2 = imcrop(R, [STATS3.BoundingBox(4,1) - 8 , STATS3.BoundingBox(4,2) - 8 ,...
    STATS3.BoundingBox(4,3) + 16, STATS3.BoundingBox(4,4) + 16]);

[labelIdx2, ~] = predict(categoryClassifierSuits, cropped2);

%--------------------------------------------------------------------------

RankSuit = insertObjectAnnotation(R,'rectangle',...
    [STATS3.BoundingBox(4,:);STATS3.BoundingBox(3,:)],...
    [categoryClassifierSuits.Labels(labelIdx2) ...
    categoryClassifier.Labels(labelIdx)]);
imshow(RankSuit);
