% Brendan Robeson
% CS 6680
% Assignment 6

%% Problem 1 - Color image processing {{{
%% Part 1 {{{
ball = imread('ball.bmp');
figure(1);
subplot(2, 2, 1);
imshow(ball);
title('Original ball');

ball_hsv = rgb2hsv(ball);
hue = medfilt2(ball_hsv(:, :, 1), [7 7]);
subplot(2, 2, 2);
imshow(hue);
title('Blurred hue');

% pick out the red ball using threshold
red = hue < 0.085;
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
bounding_box = [ min(rows) max(rows);
                 min(cols) max(cols) ];
c = floor((bounding_box(2,1) + bounding_box(2,2)) / 2);
r = floor((bounding_box(1,1) + bounding_box(1,2)) / 2);

% add a cross hair to the original image where the centroid
marked_ball = ball;
marked_ball(r-10:r+10, c, :) = 0;
marked_ball(r, c-10:c+10, :) = 0;

%ball(:, min(cols), :) = 0;
%ball(:, max(cols), :) = 0;
%ball(min(rows), :, :) = 0;
%ball(max(rows), :, :) = 0;

figure(2);
imshow(marked_ball);
title('Ball with centroid');

disp('-----Finish Solving Problem 1 part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 {{{
% grab the value channel, and apply a median filter a couple times to smooth out
% the shadow
value = medfilt2(medfilt2(ball_hsv(:,:,3), [7 7]), [7 7]);
figure(3);
subplot(2, 2, 1);
imshow(value, []);
title('Smoothed value');

% pick out the area around the ball
just_ball = value(bounding_box(1,1):bounding_box(1,2), bounding_box(2,1):bounding_box(2,2));
subplot(2, 2, 2);
imshow(just_ball, []);
title('Just the ball');

% find the minimum value in the vicinity of the ball. use this as the shadow
% value. pad it out to find shadow values a bit more than the minimum
shadow_value = min(just_ball(:)) * 1.5;
shadow = value <= shadow_value;
subplot(2, 2, 3);
imshow(shadow);
title('All ''shadows''');

% 1) label the remaining connected components
% 2) find just the shadow elements in the ball cut-out.
% 3) stick the ball cut-out shadow into a black field
% 4) remove all elements of the shadow labels for which the corresponding
%    element in step 3 is 0. this leaves only shadow label elements from the
%    ball
% 5) remove everything from the shadows image that has a different label
%    this leaves just the ball's shadow!
labeled_shadow = bwlabel(shadow);
just_ball = just_ball <= shadow_value;
shadow_bit = zeros(size(labeled_shadow));
shadow_bit(bounding_box(1,1):bounding_box(1,2), bounding_box(2,1):bounding_box(2,2)) = just_ball;
desired_label = labeled_shadow;
desired_label(find(shadow_bit == 0)) = 0;
labeled_shadow(labeled_shadow ~= max(desired_label(:))) = 0;
subplot(2, 2, 4);
imshow(labeled_shadow);
title('Ball shadow');

% set the shadow to brilliant red
colored_shadow_hsv = ball_hsv;
channel = ball_hsv(:,:,1);
channel(labeled_shadow ~= 0) = 0; % set the hue to red
colored_shadow_hsv(:,:,1) = channel;
channel = ball_hsv(:,:,2);
channel(labeled_shadow ~= 0) = 1; % set full saturation
colored_shadow_hsv(:,:,2) = channel;
channel = ball_hsv(:,:,3);
channel(labeled_shadow ~= 0) = 1; % set full value
colored_shadow_hsv(:,:,3) = channel;
colored_shadow = hsv2rgb(colored_shadow_hsv);

figure(4);
imshow(colored_shadow);
title('Shadow colored bright red');

disp('-----Finish Solving Problem 1 part 2-----')
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

%% Part 2 {{{
elephant_1 = imread('Elephant1.jpg');
elephant_2 = imread('Elephant2.jpg');
horse_1    = imread('Horse1.jpg');
horse_2    = imread('Horse2.jpg');

elephant_1_histogram = CalNormalizedHSVHist(elephant_1, 4, 4, 4);
elephant_2_histogram = CalNormalizedHSVHist(elephant_2, 4, 4, 4);
horse_1_histogram    = CalNormalizedHSVHist(horse_1,    4, 4, 4);
horse_2_histogram    = CalNormalizedHSVHist(horse_2,    4, 4, 4);

figure(5);
subplot(2, 2, 1);
bar(1:size(elephant_1_histogram, 2), elephant_1_histogram, 1.0);
title('Elephant1 histogram');

subplot(2, 2, 2);
bar(1:size(elephant_2_histogram, 2), elephant_2_histogram, 1.0);
title('Elephant2 histogram');

subplot(2, 2, 3);
bar(1:size(horse_1_histogram, 2), horse_1_histogram, 1.0);
title('Horse1 histogram');

subplot(2, 2, 4);
bar(1:size(horse_2_histogram, 2), horse_2_histogram, 1.0);
title('Horse2 histogram');

image_db = { elephant_1, elephant_2, horse_1, horse_2 };
histogram_db = { elephant_1_histogram, elephant_2_histogram, horse_1_histogram horse_2_histogram };
QueryImages(6, elephant_1, elephant_1_histogram, image_db, histogram_db);
QueryImages(7, elephant_2, elephant_2_histogram, image_db, histogram_db);
QueryImages(8, horse_1, horse_1_histogram, image_db, histogram_db);
QueryImages(9, horse_2, horse_2_histogram, image_db, histogram_db);

disp('-----Finish Solving Problem 2 part 2-----')
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

