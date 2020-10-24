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
    
    imageNum = 0;
    
    for k = 39:52
        % imOrig = rgb2gray(imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/TestImages/IMG_' num2str(k) '.jpeg']));
        % imOrig = rgb2gray(imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/TestImages/IMG_2556.jpeg']));
        imOrig = imread(['CardTestImage' num2str(k) '.jpg']);
        %     figure; imshow(imOrig);
        imOrig = rgb2gray(imOrig);
        
        %Testing Dr. Sarrafs code - works for rotation
        
        %binarize and smooths the image
        imBin = double(imbinarize(imOrig));
        imSmooth = imgaussfilt(imBin, 10);
        
        %     figure; imshow(imBin);
        
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
        % if nextMax > 170 && currMax >= 88 && currMax <= 92
        %     rot_ang = 0;
        % else
        rot_ang = 180 - ((currMax1 + currMax) / 2);
        % end
        
        %rotates and shows the rotated image
        imRot = imrotate(imOrig, rot_ang, 'crop');
        %     figure; imshow(imRot);
        
        %From orginal code for cropping
        %Crops the image - for working program
        
        imBinOrig2 =  double(imbinarize(imRot, .4));
        figure; imshow(imBinOrig2);
        imBinOrig2 = imgaussfilt(imBinOrig2, 3);
        stats = regionprops(imBinOrig2, 'BoundingBox', 'Area');
        areas = stats.Area;
        [val,ind] = max([stats.Area]);
        bboxes=stats(ind).BoundingBox;
        
        %     figure; imshow(imBinOrig2);
        %
        %     for l = 1:length(stats)
        %         rectangle('Position',stats(l).BoundingBox,'EdgeColor','r');
        %     end
        
        finalImage = imcrop(imRot, bboxes);
        %Makes sure the card is standing upright
        if size(finalImage, 1) < size(finalImage, 2)
            finalImage = imrotate(finalImage, 90);
        end
        
        %make sure that the card was cropped correctly and the image is usable
        if size(finalImage, 1) / size(finalImage, 2) > 1.3 && ...
                size(finalImage, 1) / size(finalImage, 2) < 1.5
            
            finalImageResized = imresize(finalImage, [400 300]);
            regionOfInterest = imcrop(finalImageResized, [0 0 50 120]);
            figure; imshow(regionOfInterest);
        else
            disp('Invalid picture, take a new one');
            pause
            continue
        end
        
        segImg = imgaussfilt(regionOfInterest, 2);
        segImg = imbinarize(segImg);
        segImg = imcomplement(segImg);
        
        stats2 = regionprops(segImg, 'Area', 'BoundingBox');
        
        croppedImages = cell(size(stats2, 1), 2);
        count = 0;
        figure; imshow(segImg);
        
        for i = 1:length(stats2)
            rectangle('Position',stats2(i).BoundingBox,'EdgeColor','r');
        end
        
        
        for j = 1 : length(stats2)
            thisBB = stats2(j).BoundingBox;
            croppedImages{j,2} = thisBB(3) / thisBB(4);
            %     rectangle('Position', thisBB,'EdgeColor','r')
            if count >= 2
                break
            elseif stats2(j).Area > 150 && stats2(j).Area < 1000 && ...
                    croppedImages{j,2} < 1.5 && croppedImages{j,2} > 0.5
                if count == 1
                    rank = imcrop(regionOfInterest, thisBB);
                    imwrite(rank, ['CardRank' num2str(imageNum) '.jpg']);
                    imageNum = imageNum + 1;
                elseif count == 0
                    suit = imcrop(regionOfInterest, thisBB);
                    imwrite(suit, ['CardSuit' num2str(imageNum) '.jpg']);
                    imageNum = imageNum + 1;
                end
                croppedImages{j,1} = imcrop(regionOfInterest, thisBB);
                croppedImages{j,1} = imadjust(croppedImages{j,1});
                count = count + 1;
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
        pause
        close all
    end
    
    
end

