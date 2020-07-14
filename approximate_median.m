function [frames_list ,lebel] = approximate_median(frames_list)
% This function gets the frames and finds all the objects in the frames. 
% Then it shows all objects with an number lebel in a rectangular box. 
% Median background method has been used.


% This m-file implements the approximate median algorithm for background
% subtraction.  It may be used free of charge for any purpose (commercial
% or otherwise), as long as the author (Seth Benton) is acknowledged.

histograms_single_frame = {};
histogram = zeros(1,255);
similarity_coor = [];
hist_before = {};


source = frames_list;
thresh = 75;           

bg = frames_list{1,1};           % read in 1st frame as background frame
bg_bw = double(rgb2gray(bg));     % convert background to greyscale

% ----------------------- set frame size variables -----------------------
fr_size = size(bg);             
width = fr_size(2);
height = fr_size(1);
fg = zeros(height, width);

% --------------------- process frames -----------------------------------

for i = 2:length(source)

    lebel = 1;
    fr = source{1,i}; 
    fr_bw = rgb2gray(fr);       % convert frame to grayscale
    
    fr_diff = abs(double(fr_bw) - double(bg_bw));  % cast operands as double to avoid negative overflow

    for j=1:width                 % if fr_diff > thresh pixel in foreground
         for k=1:height

             if ((fr_diff(k,j) > thresh))
                 fg(k,j) = fr_bw(k,j);
             else
                 fg(k,j) = 0;
             end

             if (fr_bw(k,j) > bg_bw(k,j))          
                 bg_bw(k,j) = bg_bw(k,j) + 1;           
             elseif (fr_bw(k,j) < bg_bw(k,j))
                 bg_bw(k,j) = bg_bw(k,j) - 1;     
             end
         end    
    end
   
   % Implement erosion and dilation.
   se = strel('square',3);
   fg = imerode(fg,se);
   se = strel('square',15);
   fg = imdilate(fg,se);

   cc = bwconncomp(fg);
   stats = regionprops(cc,'Centroid');
   
 
   % Get all objects and calculate coordinates and histogram.
   for j = 1:length(stats)
       coor = stats(j).Centroid;
       coorX = coor(1,1);
       coorY = coor(1,2);
       similarity_coor(1,1) =coorX;
       similarity_coor(2,1) =coorY;
       similarity_coor_list{1,j} = similarity_coor;
       
       % Histogram
       X_begin = coorX - 25;
       Y_begin =  coorY - 25;
       X = coorX + 25;
       Y =  coorY + 25;
       
       % Controls the boundries.
       if(X_begin<1)
           X_begin = 1;
       end
       if(Y_begin<1)
           Y_begin=1;
       end
        if(X_begin>size(frames_list{1,i-1},2))
           X_begin = size(frames_list{1,i-1},2);
       end
       if(Y_begin>size(frames_list{1,i-1},1))
           Y_begin=size(frames_list{1,i-1},1);
       end
       
       if(X>size(frames_list{1,i-1},2))
           X=size(frames_list{1,i-1},2);
       end
       if(Y>size(frames_list{1,i-1},1))
           Y=size(frames_list{1,i-1},1);
       end
       area = frames_list{1,i-1}(Y_begin: Y,X_begin: X);
       histogram = hist(double(area(:)), 255);
       histograms_single_frame = [histograms_single_frame histogram];        
     
   end
   
    %if this is the first found object.
  if length(hist_before)==0 && length(histograms_single_frame)~=0
     for z = 1: length(histograms_single_frame)
          coor = stats(z).Centroid;
          coorX = coor(1,1);
          coorY = coor(1,2);
           
          frames_list{1,i-1} = insertShape(frames_list{1,i-1},'rectangle', [coorX-25, coorY-25 ,50, 50]);
          frames_list{1,i-1} = insertText(frames_list{1,i-1},[coorX-25, coorY-25 ],lebel);
          lebel_before{1,z} = lebel;
          lebel = lebel + 1;
      end
  else
      for z = 1: length(histograms_single_frame)
          coor = stats(z).Centroid;
           coorX = coor(1,1);
           coorY = coor(1,2);
           
          for n = 1: length(object_before)
              % Histogram distance.
              dist = sumsqr( object_before(n).h(:) - histograms_single_frame{1,z}(:) );
              % Coordinates distance.
              cordist = sumsqr( object_before(n).c(:) - similarity_coor_list{1,z}(:) );
              if dist < 50
                  if cordist < 4000
                      frames_list{1,i-1} = insertShape(frames_list{1,i-1},'rectangle', [coorX-25, coorY-25 ,50, 50]);
                      frames_list{1,i-1} = insertText(frames_list{1,i-1},[coorX-25, coorY-25 ],object_before(n).l);
                      lebel_before{1,z} = object_before(n).l; 
                      break;
                  end
              else
                  frames_list{1,i-1} = insertShape(frames_list{1,i-1},'rectangle', [coorX-25, coorY-25 ,50, 50]);
                  frames_list{1,i-1} = insertText(frames_list{1,i-1},[coorX-25, coorY-25 ],lebel);
                  lebel_before{1,z} = lebel;
                  lebel = lebel + 1;
                  break;
              end
          end
      end      
  end
 
    % get the previous frame values if previous is not empty.
   if length(histograms_single_frame) ~= 0
        hist_before = histograms_single_frame;
        similarity_coor_list_before = similarity_coor_list;
        
        histo = 'h';  value1 = hist_before;
        cor = 'c';  value2 = similarity_coor_list_before;
        leb = 'l';  value3 = lebel_before;
        
        
        object_before = struct(histo,value1,cor,value2,leb,value3);
   end
   
   %reset all the values.
    histograms_single_frame = {}; 
    histogram = zeros(1,255);
    similarity_coor = [];
    similarity_coor_list = {};
    lebel_before = {};
end
end
   

    