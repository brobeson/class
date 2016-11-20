img = imread('~/Documents/phd/cs6680/final_project/data_sets/horizontal_mapping_4cm/IMG_0078.JPG');
%img = imread('lena.jpg');
%img = cat(3, img, img, img);

tic
[f, d] = uav_sift(img);
end_time = toc;
fprintf(1, 'uav_sift() ran in %.2f seconds\n', end_time);

figure;
imshow(img);
hold on
plot(f(1,:), f(2,:), 'r.');
hold off
