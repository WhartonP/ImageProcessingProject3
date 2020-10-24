%Project three for image processing by Peter Wharton and Farshad Bolouri
%Program that opens a webcam and takes a picture of a playing card,
%processes it and then displays the rank and suite of the card.
clear; close all;

%finds and opens the webcam to take the pictures
endCase = 1;
cams = webcamlist;
cam = webcam(cams{1});
while endCase ~= 0
    disp('Press space to take the picture of the card. ')
    preview(cam);
    pause()
    imOrig = rgb2gray(snapshot(cam));
    
    %binarize and smooths the image
    imBin = double(imbinarize(imOrig));
    imSmooth = imgaussfilt(imBin, 10);
    
    %uses the gradient direction to find the angle
    [Gmag, Gdir] = imgradient(imSmooth);
    Gdir(Gdir < 0) = Gdir(Gdir < 0) + 180;
    figure; hist = histogram(Gdir, 'BinWidth', 4);
    hist.BinCounts(1) = 0;
    [~, i] = max(hist.BinCounts);
    rot_ang = 180 - ((hist.BinEdges(i + 1) + hist.BinEdges(i)) / 2);
    
    %rotates the image
    imRot = imrotate(imOrig, rot_ang, 'crop');
    
    %binarize and smooths the rotated image to process for cropping
    imBinOrig2 =  double(imbinarize(imRot, .4));
    imBinOrig2 = imgaussfilt(imBinOrig2, 3);
    stats = regionprops(imBinOrig2, 'BoundingBox', 'Area');
    areas = stats.Area;
    [val,ind] = max([stats.Area]);
    bboxes=stats(ind).BoundingBox;
    
    finalImage = imcrop(imRot, bboxes);
    
    %Makes sure the card is standing upright
    if size(finalImage, 1) < size(finalImage, 2)
        finalImage = imrotate(finalImage, 90);
    end
    
    %make sure that the card was cropped correctly and the image is usable
    if (size(finalImage, 1) / size(finalImage, 2)) > 1.3 && ...
            (size(finalImage, 1) / size(finalImage, 2)) < 1.5
        
        finalImageResized = imresize(finalImage, [400 300]);
        regionOfInterest = imcrop(finalImageResized, [0 0 50 120]);
    else
        disp('Picture is not usable, try taking a new picture in 5 seconds.');
        figure; imshow(imOrig);
        figure; imshow(finalImage);
        pause(5)
        continue
    end
    
    %processes the ROI to prepare for segmenting the suit and rank
    segImg = imgaussfilt(regionOfInterest, 2);
    segImg = imbinarize(segImg);
    segImg = imcomplement(segImg);
    
    stats2 = regionprops(segImg, 'Area', 'BoundingBox');
    
    croppedImages = cell(size(stats2, 1), 2);
    count = 0;
    
    %Segments the suit and rank out
    for j = 1 : length(stats2)
        thisBB = stats2(j).BoundingBox;
        croppedImages{j,2} = thisBB(3) / thisBB(4);
        if count >= 2
            break
        elseif stats2(j).Area > 150 && stats2(j).Area < 1000 && ...
                croppedImages{j,2} < 1.5 && croppedImages{j,2} > 0.5
            if count == 1
                rank = imcrop(regionOfInterest, thisBB);
                count = count + 1;
            elseif count == 0
                suit = imcrop(regionOfInterest, thisBB);
                count = count + 1;
            end
        end
    end
    
    figure;
    imshow(rank);
    figure;
    imshow(suit);
    
    % %% Classifying Rank and Suit
    % load categoryClassifierRanks3
    % load categoryClassifierSuits2
    %
    % [RankIdx1, scores1] = predict(categoryClassifier, rank);
    % [RankIdx2, scores2] = predict(categoryClassifier, suit);
    %
    % if (var((scores1+1)*100) > var((scores2+1)*100))
    %     Rank = categoryClassifier.Labels(RankIdx1);
    %     [SuitIdx, ~] = predict(categoryClassifierSuits, suit);
    %     Suit = categoryClassifierSuits.Labels(SuitIdx);
    % else
    %     Rank = categoryClassifier.Labels(RankIdx2);
    %     [SuitIdx, ~] = predict(categoryClassifierSuits, rank);
    %     Suit = categoryClassifierSuits.Labels(SuitIdx);
    % end
    % fprintf("Rank = %s \n", Rank{1});
    % fprintf("Suit = %s \n", Suit{1});
    % disp("---------------------------------");
    
    close all
    if input('Enter 1 to take another picture, or 0 to exit the program. ') == 1
        continue
    else
        endCase = 0;
        close all;
        clear;
    end
end

