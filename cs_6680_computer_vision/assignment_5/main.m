% Brendan Robeson
% CS 6680
% Assignment 5

clc
pause off

%% Problem I - Problem solving using morphological operations {{{
%% Part 1 {{{
city = imread('City.jpg');
se = strel('square', 3);
city_gradient = imsubtract(imdilate(city, se), imerode(city, se));

figure(1);
imshow(city_gradient);
title('City gradient');

disp('The result shows edge information. The dilation expands the objects in the image');
disp('and the erosion shrinks them. Subtracting the erosion from the dilation removes');
disp('object interiors, leaving behind the edges.');

disp('-----Finish Solving Problem I part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 {{{
squares = imread('SmallSquares.tif');

figure(2);
imshow(squares);

disp('-----Finish Solving Problem I part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 3 {{{
wire_bond = imread('Wirebond.tif');

se = strel('square', 15);
wire_bond_b = imerode(wire_bond, se);

se = strel('square', 8);
wire_bond_c = imerode(wire_bond, se);

se = strel('square', 37);
wire_bond_d = imerode(wire_bond, se);

figure(3);
subplot(1, 3, 1);
imshow(wire_bond_b);
title('Desired image 1');

subplot(1, 3, 2);
imshow(wire_bond_c);
title('Desired image 2');

subplot(1, 3, 3);
imshow(wire_bond_d);
title('Desired image 3');

disp('-----Finish Solving Problem I part 3-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 4 {{{
shapes = imread('Shapes.tif');
se = strel('square', 20);

shapes_b = imopen(shapes, se);
shapes_c = imclose(shapes, se);
shapes_d = imclose(imopen(shapes, se), se);

figure(4);
subplot(1, 3, 1);
imshow(shapes_b);
title('Desired image 1');

subplot(1, 3, 2);
imshow(shapes_c);
title('Desired image 2');

subplot(1, 3, 3);
imshow(shapes_d);
title('Desired image 3');

disp('-----Finish Solving Problem I part 4-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 5 {{{
dowels = imread('Dowels.tif');

% open-close with a disk SE, and a close-open
se = strel('disk', 5);
dowels_oc = imclose(imopen(dowels, se), se);
dowels_co = imopen(imclose(dowels, se), se);

figure(5);
subplot(1, 2, 1);
imshow(dowels_oc);
title('Open-close');

subplot(1, 2, 2);
imshow(dowels_co);
title('Close-open');

disp('Opening an image exposes more black background, dimming the image. Closing');
disp('increases the foreground, brightening the image. The first operation used');
disp('dominates, hence open-close appears dimmer than close-open.');

% open-close series
dowels_oc = dowels;
dowels_co = dowels;
for i = 2:5
    se = strel('disk', i);
    dowels_oc = imclose(imopen(dowels_oc, se), se);
    dowels_co = imopen(imclose(dowels_co, se), se);
end

figure(6);
subplot(1, 2, 1);
imshow(dowels_oc);
title('Open-close');

subplot(1, 2, 2);
imshow(dowels_co);
title('Close-open');

disp('-----Finish Solving Problem I part 5-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

%% Problem II - Applications of morphological operations {{{
%% Part 1 {{{
ball = imread('Ball.tif');
[labelIm, num] = FindComponentLabels(ball, strel('square', 3));

fprintf(1, '%d connected objects were found.\n', num);

figure(7);
imshow(labelIm, []);
title('Labeled objects');

disp('-----Finish Solving Problem II part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 {{{
[L, num] = bwlabel(ball);

fprintf(1, 'Matlab found %d components\n', num);
figure(8);
imshow(L, []);
title('Matlab''s labels');

disp('-----Finish Solving Problem II part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

clear -all
close all force

