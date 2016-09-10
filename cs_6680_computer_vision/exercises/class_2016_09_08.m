% Brendan Robeson
% CS 6680
% In class exercises

% These exercies were assigned on 2016 September 08 in class. Professor Qi wants
% us to be prepared to present solutions in class on 2016 September 13.

clear -all
close all force

%% Problem 1 {{{
% What does imshow(A, [ ]) do? What are the acceptable data types for variable A?
%
% imshow(A, []) will stretch A to fill the gamut of its data type. If A has
% intensity values that are unsigned bytes, the image will be remapped from
% [min, max] to [0, 255]. If A has floating point intensity values, the image
% will be remapped from [min, max] to [0, 1].
%
% A can be a 2D or 3D image. That is, a grayscale or RGB image. The data can be
% floating point, on [0, 1]. Or they can be unsigned byte, on [0, 255].

% load an image, and convert it to grayscale for 
original = rgb2gray(imread('peppers.bmp'));

% cut the intensity in half as a starting point
halved = original ./ 2;

% convert to floating point representation
fp = im2double(halved);

figure;
subplot(2, 2, 1);
imshow(original);
title('Original');

subplot(2, 2, 2);
imshow(halved);
title('Halved');

subplot(2, 2, 3);
imshow(halved, []);
title('Unsigned Byte []');

subplot(2, 2, 4);
imshow(fp, []);
title('Floating Point []');

pause
%}}}

%% Problem 2 {{{

%}}}

clear -all
close all force
