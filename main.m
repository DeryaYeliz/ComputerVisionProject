%%NAME SURNAME: Derya Yeliz ULUTAS

% Short Description of The Code

% 1 - Finding background and foreground using methods
%   * Median
%   * Moving Average
% 2 - Implement each foreground image of the frames erosion and dilation
%     operations in order to detect the objects.
% 3 - Show the objects in a rectangular box.
% 4 - Track the moving objects calculating the histogram of each object
%     area and comparing the center coordinates.
% 5 - Give each object a number value and track them.
% 6 - Show the frames in imshow()


%read the image from the directory.
[highway_frames, pedestrian_frames] = readFolder(); 
 
%save ('images_read');
[highway_frames_rec_median] = approximate_median(highway_frames);
[highway_frames_rec_average] = moving_average(highway_frames);


[pedestrian_frames_rec_median] = approximate_median2(pedestrian_frames);
[pedestrian_frames_rec_average] = moving_average(pedestrian_frames);


figure('Name','Highway - Median');
for i=1:length(highway_frames_rec_median)
    imshow(highway_frames_rec_median{1,i});
end

figure('Name','Highway - Moving Average');
for i=1:length(highway_frames_rec_average)
    imshow(highway_frames_rec_average{1,i});
end

figure('Name','Pedastrian - Median');
for i=1:length(pedestrian_frames_rec_median)
    imshow(pedestrian_frames_rec_median{1,i});
end

figure('Name','Pedastrian - Moving Average');
for i=1:length(pedestrian_frames_rec_average)
   imshow(pedestrian_frames_rec_average{1,i});
end




%v = VideoWriter('avg.avi','Uncompressed AVI');
%v.FrameRate = 30;
%open(v);
%for u=1:length(highway_frames_rec_average)
 %   writeVideo(v,highway_frames_rec_average{1,u});
%end
%close(v);

