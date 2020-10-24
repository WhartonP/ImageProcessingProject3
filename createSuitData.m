%for making a suit trainging set with rotation - replace second for with
%range for rotation
count = 0;
for j = 1 : 11
    for i = -5:-1
       imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
       imRot = imrotate(imOrig, i, 'crop');
       imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
       count = count + 1;
    end
    for i = 1:5
       imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
       imRot = imrotate(imOrig, i, 'crop');
       imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
       count = count + 1;
    end
end

%for making more images imadjust
for j = 1 : 11
    imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
    imRot = imadjust(imOrig);
    imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
    count = count + 1;
end

%double imadjusts
for j = 1 : 11
    imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
    imRot = imadjust(imOrig);
    imRot = imadjust(imRot);
    imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
    count = count + 1;
end

%sharpens the images
for j = 1 : 11
    imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
    imRot = imsharpen(imOrig);
    imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
    count = count + 1;
end

%sharpens the images twice 
for j = 1 : 11
    imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
    imRot = imsharpen(imOrig);
    imRot = imsharpen(imRot);
    imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
    count = count + 1;
end

%for blurring the images slightly
for j = 1 : 11
    imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
    imRot = imgaussfilt(imOrig);
    imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
    count = count + 1;
end

%for blurring the images a little more
for j = 1 : 11
    imOrig = imread(['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/' num2str(j) '.jpg']);
    imRot = imgaussfilt(imOrig, 1);
    imwrite(imRot, ['/Users/peter/Documents/MATLAB/ImageProcessing/ProjectThree/ImageProcessingProject3/Diamonds/New/' num2str(count) '.jpg']);
    count = count + 1;
end






