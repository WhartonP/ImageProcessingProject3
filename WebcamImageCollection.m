%finds and opens the webcam to take the pictures
cams = webcamlist;
cam = webcam(cams{1});
disp('Press space to take the picture')


preview(cam);
pause()
for k = 1:500
    imOrig = rgb2gray(snapshot(cam));
    imwrite(imOrig, ['SuitRankImages' num2str(k) '.jpg']);
    pause()
end