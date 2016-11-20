%img = imread('~/Documents/class/cs6680/final_project/data_sets/horizontal_mapping_4cm/IMG_0078.JPG');
%[f, d] = uav_sift(img);

img = imread('lena.jpg');
img = cat(3, img, img, img);
[f, d] = uav_sift(img);
