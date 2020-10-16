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

imOrig = imread('Testimage1.tif');

%Testing Dr. Sarrafs code - works for rotation 

%binarize and smooths the image
imBin = double(imbinarize(imOrig));
imSmooth = imgaussfilt(imBin, 4);

%trying use edge?

%uses the gradient direction to find the angle 
[Gmag, Gdir] = imgradient(imSmooth);
Gdir(Gdir < 0) = Gdir(Gdir < 0) + 180;
% figure; imshow(Gdir, []);
figure; hist = histogram(Gdir, 'BinWidth', 4);
hist.BinCounts(1) = 0;
[v, i] = max(hist.BinCounts);
rot_ang = 180 - ((hist.BinEdges(i + 1) + hist.BinEdges(i)) / 2);

%rotates and shows the rotated image
imRot = imrotate(imOrig, rot_ang, 'crop');
% figure; imshow(imRot);
% title(num2str(rot_ang));


%From orginal code for cropping
%Crops the image - for working program
imBinOrig2 =  imbinarize(imRot, .6);
stats = regionprops(imBinOrig2, 'BoundingBox');
bboxes=stats.BoundingBox;
finalImage = imcrop(imRot, bboxes);

% figure;
% subplot(1,2,1), imshow(imOrig);
% subplot(1,2,2), imshow(finalImage);

imshow(finalImage);
segImg = imbinarize(finalImage);
segImg = imcomplement(segImg);
connLabel = bwlabel(segImg);
% connLabel = imgaussfilt(connLabel, 4);
[Gmag2, Gdir2] = imgradient(connLabel);
Gdir2(Gdir2 < 0) = Gdir2(Gdir2 < 0) + 180;
connLabel2 = bwlabel(Gdir2);
figure; hist2 = histogram(Gdir2, 'BinWidth', 4);
hist2.BinCounts(1) = 0;

SE = [0 1 0; 1 1 1; 0 1 0];

test = imerode(connLabel2, SE);
test = imgaussfilt(test, 2);
test = imdilate(test, SE);



stats2 = regionprops(segImg, 'Area', 'BoundingBox');
for k = 1 : length(stats2)
  if stats2(k).Area < 300 || stats2(k).Area > 1300
      continue
  end
  thisBB = stats2(k).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 )
end

%none of this worked 
% segImg = bwlabel(imbinarize(finalImage));
% stats2 = regionprops(segImg, 'Area', 'BoundingBox');
% for k = 1 : length(stats2)
%   thisBB = stats2(k).BoundingBox;
%   rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
%   'EdgeColor','r','LineWidth',2 )
% end
% 
% %maybe binarized final image and then use bwlabel to find connected objects
% segImg = bwlabel(imbinarize(finalImage));
% figure; imshow(segImg);
% 
% hold on
% boundaries = bwboundaries(segImg);
% numberOfBoundaries = size(boundaries, 1);
% for k = 1 : numberOfBoundaries
% 	thisBoundary = boundaries{k};
% 	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
% end
% hold off;






