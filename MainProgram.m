%Project two for image processing by Peter Wharton
%Program that reads in an image of a rotated playing card, undoes the
%rotation and then crops the card out of the picture, and then displays the
%original and the cropped card. 
clear; 

fileName = input("Enter the image name with file type (.tif) (assuming in the same dir. as program): \n", 's');
while fileName ~= '0'
    close all;
    imOrig = imread(fileName);
    
    ocrResults = ocr(imOrig);
    Iocr = insertObjectAnnotation(imOrig, 'rectangle', ...
                           ocrResults.WordBoundingBoxes, ...
                           ocrResults.WordConfidences);
    figure; imshow(Iocr);

    %Rotates the image
    imBinOrig = imbinarize(imOrig, .6);
    [cornerA, cornerB, cornerC] = findCorner(imBinOrig);
    [angle, w, z] = findAngle(cornerA, cornerB, cornerC);
    imOrig2 = imrotate(imOrig, angle);

    %Crops the image - for working program
    imBinOrig2 =  imbinarize(imOrig2, .6);
    stats = regionprops(imBinOrig2, 'all');
    bboxes=stats.BoundingBox;
    finalImage = imcrop(imOrig2, bboxes);
    
    figure;
    subplot(1,2,1), imshow(imOrig);
    subplot(1,2,2), imshow(finalImage);
    fileName = input("Enter a new image name or a 0 to stop reading images in.\n", 's');

end

%Function that finds 3 corners and then returns the angle needed to rotate
function [A, B, C] = findCorner(im)
    Gmag = imgradient(im);          %finds gradients of the filtered image
    
    %finds the size of the region to traverse the picture to find a cornor
    pictureSize = size(im);
    hSize = round(.001 * pictureSize(2));
    vSize = round(.001 * pictureSize(1));

    %finds the top left most cornor
    foundC = false;
    for i = 1:vSize:pictureSize(1) - vSize
        for j = 1:hSize:pictureSize(2) - hSize
            if mean(mean(Gmag(i : i + vSize, j : j + hSize))) ~= 0
                C = [i + vSize, j + hSize];
                foundC = true;
            end
            if foundC
                break
            end
        end
        if foundC
            break
        end
    end

    %finds the bottom right most cornor
    foundC = false;
    for i = pictureSize(1) - vSize: -vSize: vSize
        for j = pictureSize(2) - hSize: -hSize: 1
            if mean(mean(Gmag(i : i + vSize, j : j + hSize))) ~= 0
                B = [i + vSize, j + hSize];
                foundC = true;
            end
            if foundC
                break
            end
        end
        if foundC
            break
        end
    end

    %Finds the second top right hand corner 
    foundC = false;
    for i = pictureSize(2) - hSize: -hSize: hSize
        for j = 1:vSize:pictureSize(1) - vSize
            if mean(mean(Gmag(j : j + vSize, i : i + hSize))) ~= 0
                A = [j + hSize, i + vSize];
                foundC = true;
            end
            if foundC
                break
            end
        end
        if foundC
            break
        end
    end
end

%Finds the angle of rotation 
function [angle, w, z] = findAngle(cornerA, cornerB, cornerC)
    %Finds all the magnitudes and distances needed 

    %distance from C - A
    w = norm(cornerC - cornerA);

    %x distance from A - B
    x = abs(cornerA(2) - cornerB(2));

    %y distance form A - B
    y = abs(cornerA(1) - cornerB(1));

    %distance between A - B
    z = norm(cornerA - cornerB);

    %card is perpenducular to x axis and standing up
    if cornerA(2) == cornerB(2) && w < z
        angle = 0;
    %card is perpendicular to x axis but on its side
    elseif cornerA(2) == cornerB(2) && w > z
        angle = 90;
    %card is angled and long side is tilted to ground so has to rotate left
    elseif w < z
        angle = 90 - atand(y / x); 
    %card is angled and short side is tilited to ground so has to rotate right
    else
        angle = -atand(y/x);
    end
end





