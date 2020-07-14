function [ listOfHighway, listOfPedestrian] = readFolder()

% This function reads images in the given directory. 
    listOfHighway = {};
    listOfPedestrian = {};


    path1 = 'highway';
    path2 = 'pedestrian';
    folder1 = dir(path1);
    folder2 = dir(path2);
        
    k = 1;
    while k <= numel(folder1)
        if strcmp(folder1(k).name,'.') || strcmp(folder1(k).name,'..') || strcmp(folder1(k).name,'.DS_Store')
            folder1(k) = [];
        else 
            listOfHighway = [listOfHighway imread(strcat('highway/',folder1(k).name))];            
        k = k+1;
        end
    end
    
     k = 1;
    while k <= numel(folder2)
        if strcmp(folder2(k).name,'.') || strcmp(folder2(k).name,'..') || strcmp(folder2(k).name,'.DS_Store')
            folder2(k) = [];
        else 
            listOfPedestrian = [listOfPedestrian imread(strcat('pedestrian/',folder2(k).name))];            
        k = k+1;
        end
    end
end

