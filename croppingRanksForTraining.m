clear 
close all
folders = ["8","9","A","K","J","Q"];
tic
for j= 1:length(folders)
    
    directory = "V:\Datasets\Playing Cards\Card Ranks\" + folders(j);
    if ~isempty(directory)
        ImageSet = dir(fullfile(directory,'*.png'));
        for i = 1:numel(ImageSet)
            image = imread(fullfile(directory,ImageSet(i).name));
            binary = imbinarize(image);
            BW = edge(binary,'Canny');
            STATS = regionprops('table',BW,'Area','BoundingBox');
            [~,k] = max(STATS.Area);
            image = imcrop(image,STATS.BoundingBox(k,:));
            %figure
            image = imresize(image,0.5);
            file = "V:\Datasets\Playing Cards\Card Ranks\" + folders(j) +...
                "Cropped\" + sprintf("%d.png",i);
            imwrite(image,file);
        end
    end
end
toc