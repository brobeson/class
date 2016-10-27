% Brendan Robeson
% CS 6680
% Assignment 5

clc
pause off

%% Problem I - Problem solving using morphological operations {{{
%% Part 1 {{{
city = imread('City.jpg');
se = [ 1 1 1;
       1 1 1;
       1 1 1 ];
city_gradient = imdilate(city, se) - imerode(city, se);

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
% }}}

clear -all
close all force

