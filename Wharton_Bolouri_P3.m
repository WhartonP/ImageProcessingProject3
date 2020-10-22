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

for k = 1:52
% imOrig = rgb2gray(imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/TestImages/IMG_' num2str(k) '.jpeg']));
% imOrig = rgb2gray(imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/TestImages/IMG_2556.jpeg']));
imOrig = imread(['CardTestImage' num2str(k) '.jpg']);
figure; imshow(imOrig);
imOrig = rgb2gray(imOrig);

%Testing Dr. Sarrafs code - works for rotation 

%binarize and smooths the image
imBin = double(imbinarize(imOrig));
imSmooth = imgaussfilt(imBin, 10);

figure; imshow(imBin);

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
[~, i] = max(hist.BinCounts);
currMax = hist.BinEdges(i);
currMax1 = hist.BinEdges(i + 1);
hist.BinCounts(i) = 0;
[~, i] = max(hist.BinCounts);
nextMax = hist.BinEdges(i);
if nextMax > 170 && currMax >= 88 && currMax <= 92
    rot_ang = 0;
else
    rot_ang = 180 - ((currMax1 + currMax) / 2);
end

%rotates and shows the rotated image
imRot = imrotate(imOrig, rot_ang, 'crop');
figure; imshow(imRot);

%From orginal code for cropping
%Crops the image - for working program

imBinOrig2 =  double(imbinarize(imRot, .4));
figure; imshow(imBinOrig2);
imBinOrig2 = imgaussfilt(imBinOrig2, 3);
stats = regionprops(imBinOrig2, 'BoundingBox', 'Area');
areas = stats.Area;
[val,ind] = max([stats.Area]);
bboxes=stats(ind).BoundingBox;

figure; imshow(imBinOrig2);

for l = 1:length(stats)
    rectangle('Position',stats(l).BoundingBox,'EdgeColor','r');
end

finalImage = imcrop(imRot, bboxes);
figure; imshow(finalImage);

segImg = imbinarize(finalImage);
segImg = imcomplement(segImg);
% connLabel = bwlabel(segImg);
% [Gmag2, Gdir2] = imgradient(connLabel);
% Gdir2(Gdir2 < 0) = Gdir2(Gdir2 < 0) + 180;
% connLabel2 = bwlabel(Gdir2);
% figure; hist2 = histogram(Gdir2, 'BinWidth', 4);
% hist2.BinCounts(1) = 0;

stats2 = regionprops(segImg, 'Area', 'BoundingBox');

croppedImages = cell(size(stats2, 1), 2);
count = 0;

figure; imshow(segImg);

% for i = 1:length(stats2)
%     rectangle('Position',stats2(i).BoundingBox,'EdgeColor','r');
% end


for j = 1 : length(stats2)
    thisBB = stats2(j).BoundingBox;
    croppedImages{j,2} = thisBB(3) / thisBB(4);
%     rectangle('Position', thisBB,'EdgeColor','r')
    if count >= 2
        break
    elseif croppedImages{j,2} < 1 && croppedImages{j,2} > 0.5 && ...
                            stats2(j).Area > 300 && stats2(j).Area < ...
                            max([stats2.Area])
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




