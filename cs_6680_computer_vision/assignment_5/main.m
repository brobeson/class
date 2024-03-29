% Brendan Robeson
% CS 6680
% Assignment 5

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

se1 = [ 0 1 0;
        0 1 1;
        0 0 0 ];

se2 = [ 1 0 0;
        1 0 0;
        1 1 1 ];

res = bwhitmiss(squares, strel(se1), strel(se2));

figure(2);
imshow(res);
title('Result');

fprintf(1, '%d pixels have north, east, and northeast neighbors.\n', sum(res(:)));

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

fprintf(1, 'Opening an image exposes more black background, dimming the image. Closing\n');
fprintf(1, 'increases the foreground, brightening the image. The first operation used\n');
fprintf(1, 'dominates, hence open-close appears dimmer than close-open.\n\n');

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

fprintf(1, 'Progressively increasing the SE radius appears to make smoother transitions\n');
fprintf(1, 'between regions of varying intensity.\n\n');

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

% convert the labels to HSV. the labels are converted to hue. saturation and
% value are fixed at 1
labels = ones(size(labelIm, 1), size(labelIm, 2), 3, 'double');
labels(:, :, 1) = double(labelIm) ./ num;
labels(:, :, 2) = ball;
labels(:, :, 2) = ball;

figure(7);
imshow(hsv2rgb(labels));
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

disp('-----Finish Solving Problem II part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 3 {{{
initial_points = ball;
initial_points(2:size(ball, 1) - 1, 2:size(ball, 2) - 1) = 0;
se = strel('square', 3);

% initialize to no objects
A = zeros(size(ball), 'logical');

% loop while there are unprocessed initial_points. each iteration of the loop
% will remove a point from the initial points.
while sum(initial_points(:)) ~= 0
    Xk_1 = zeros(size(ball), 'logical');
    Xk = Xk_1;
    idx = find(initial_points, 1);
    Xk(idx(1)) = 1;
    while ~isequal(Xk, Xk_1)
        Xk_1 = Xk;
        Xk = imdilate(Xk_1, se) & ball;
    end

    % only record the object if a component was found
    if (any(Xk(:)))
        A = A + Xk;

        % remove the found component from the input image. we don't want to
        % find it again
        initial_points = ~Xk & initial_points;
    end
end

figure(9);
subplot(1, 2, 1);
imshow(ball);
title('Balls');
subplot(1, 2, 2);
imshow(A);
title('Border objects');

disp('-----Finish Solving Problem II part 3-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 4 {{{
% remove the border items found in part 3. then label the remaining particles
B = ball & ~A;
[B, num] = FindComponentLabels(B, strel('square', 3));

% find the labeled item with the smalled area. this is used to estimate the size
% of single items. recall that no border items are present, so no partial items
% are present. if they were, this would not be a robust method.
areas = zeros(1, num, 'int32');
for n = 1:num
    comp = B == n;
    areas(n) = sum(comp(:));
end

% grow the minimum area by 2% to account for size error due to manipulating
% discrete data (instead of continuous).
minimum_area = min(areas);
minimum_area = minimum_area * 1.02;

% remove any items with mn area
rejected_labels = find(areas <= minimum_area);
to_remove = B == rejected_labels(1);
for r = 2:size(rejected_labels, 2)
    to_remove = to_remove | B == rejected_labels(r);
end
B = B & ~to_remove;

figure(10);
subplot(1, 2, 1);
imshow(ball);
title('Balls');
subplot(1, 2, 2);
imshow(B, []);
title('Interior overlapping');

fprintf(1, 'There are %d interior overlapping components.\n', num - size(rejected_labels, 2));

disp('-----Finish Solving Problem II part 4-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

clear -all
close all force

