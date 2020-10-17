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

imOrig = imread('Testimage3.tif');

%Testing Dr. Sarrafs code - works for rotation 

%binarize and smooths the image
imBin = double(imbinarize(imOrig));
imSmooth = imgaussfilt(imBin, 4);

%uses the gradient direction to find the angle 
[Gmag, Gdir] = imgradient(imSmooth);
Gdir(Gdir < 0) = Gdir(Gdir < 0) + 180;
hist = histogram(Gdir, 'BinWidth', 4);
hist.BinCounts(1) = 0;
[v, i] = max(hist.BinCounts);
rot_ang = 180 - ((hist.BinEdges(i + 1) + hist.BinEdges(i)) / 2);

%rotates and shows the rotated image
imRot = imrotate(imOrig, rot_ang, 'crop');


%From orginal code for cropping
%Crops the image - for working program
imBinOrig2 =  imbinarize(imRot, .6);
stats = regionprops(imBinOrig2, 'BoundingBox');
bboxes=stats.BoundingBox;
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

for k = 1 : length(stats2)
    thisBB = stats2(k).BoundingBox;
    croppedImages{k,2} = abs(thisBB(3) / thisBB(4));
    if croppedImages{k,2} < 1 && croppedImages{k,2} > 0.5 && stats2(k).Area > 300
        if count == 1
            rank = imcrop(finalImage, thisBB);
        elseif count == 0
            suit = imcrop(finalImage, thisBB);
        end
        croppedImages{k,1} = imcrop(finalImage, thisBB);
        count = count + 1;
    end
end

close all
figure 
imshow(rank);
figure 
imshow(suit);
