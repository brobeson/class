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

disp('-----Finish Solving Problem I part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

clear -all
close all force

