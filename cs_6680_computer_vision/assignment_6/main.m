% Brendan Robeson
% CS 6680
% Assignment 6

%clc
pause off

%% Problem 1 - Color image processing {{{
%% Part 1 {{{
ball = imread('ball.bmp');
figure(1);
subplot(2, 2, 1);
imshow(ball);
title('Original ball');

ball_hsv = rgb2hsv(ball);
hue = ball_hsv(:, :, 1);
subplot(2, 2, 2);
imshow(hue);
title('Hue');

% pick out the red ball using threshold
red = hue < 0.075;
subplot(2, 2, 3);
imshow(red);
title('Red');

% get rid of any noise by eroding, then restore the ball by dilating.
se = strel('square', 7);
red = imdilate(imerode(red, se), se);
subplot(2, 2, 4);
imshow(red);
title('Red de-noised');

% get the indices of the remaining pixels. the average of the min & max of each
% dimension gives the centroid
[rows, cols] = find(red);
c = floor((min(cols) + max(cols)) / 2);
r = floor((min(rows) + max(rows)) / 2);

% add a cross hair to the original image where the centroid
ball(r-10:r+10, c, :) = 0;
ball(r, c-10:c+10, :) = 0;

%ball(:, min(cols), :) = 0;
%ball(:, max(cols), :) = 0;
%ball(min(rows), :, :) = 0;
%ball(max(rows), :, :) = 0;

figure(2);
imshow(ball);
title('Ball with centroid');

disp('-----Finish Solving Problem 1 part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

%% Problem 2 - Color image retrieval {{{
%% Part 1 {{{

% implemented in CalNormalizedHSVHist.m

disp('-----Finish Solving Problem 2 part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

%% Problem 3 - Watermarking {{{
%% Part 1 {{{
lena = imread('Lena.jpg');
figure(10);
subplot(2, 3, 1);
imshow(lena);
title('Lena');

[marked_30, water_30] = EmbedWatermark(lena, 30);
subplot(2, 3, 2);
imshow(marked_30);
title('𝛽 = 30');

subplot(2, 3, 3);
imshow(abs(marked_30 - lena), []);
title('𝛽 = 30 - lena');

[marked_90, water_90] = EmbedWatermark(lena, 90);
subplot(2, 3, 5);
imshow(marked_90);
title('𝛽 = 90');

subplot(2, 3, 6);
imshow(abs(marked_90 - lena), []);
title('𝛽 = 90 - lena');

disp('-----Finish Solving Problem 3 part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 {{{
ex_water_30 = ExtractWatermark(marked_30, 30);
ex_water_90 = ExtractWatermark(marked_90, 90);

fprintf(1, 'For 𝛽=30, %.2f%% of extracted bits match embedded bits.\n', 100 * sum(water_30 ~= ex_water_30) / size(water_30, 2));
fprintf(1, 'For 𝛽=90, %.2f%% of extracted bits match embedded bits.\n', 100 * sum(water_90 ~= ex_water_90) / size(water_90, 2));

disp('-----Finish Solving Problem 3 part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

clear -all
close all force

