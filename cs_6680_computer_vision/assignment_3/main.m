% Brendan Robeson
% CS 6680
% Assignment 3

clc
pause off

%% Problem I {{{
circuit = imread('Circuit.jpg');
%% Part 1 {{{
weighted_mask = [1 2 1; 2 4 2; 1 2 1];
weighted_mask = weighted_mask ./ sum(weighted_mask(:));
tic
weighted_circuit = AverageFiltering(circuit, weighted_mask);
toc

standard_mask = ones(5, 5);
standard_mask = standard_mask ./ sum(standard_mask(:));
tic
standard_circuit = AverageFiltering(circuit, standard_mask);
toc

% show the circuit images
figure(1);
subplot(1, 3, 1);
imshow(circuit);
title('Original circuit.jpg');
subplot(1, 3, 2);
imshow(weighted_circuit);
title('3x3 Weighted average');
subplot(1, 3, 3);
imshow(standard_circuit);
title('5x5 Standard average');

disp('-----Finish Solving Problem I part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 {{{
%weighted_mask = [1 2 1; 2 4 2; 1 2 1];
%weighted_mask = weighted_mask ./ sum(weighted_mask(:));
%weighted_circuit = AverageFiltering(circuit, weighted_mask);

standard_mask = ones(5, 5);
tic
standard_circuit = MedianFiltering(circuit, standard_mask);
toc

% show the circuit images
figure(2);
subplot(1, 3, 1);
imshow(circuit);
title('Original circuit.jpg');
%subplot(1, 3, 2);
%imshow(weighted_circuit);
%title('3x3 Weighted average');
subplot(1, 3, 3);
imshow(standard_circuit);
title('5x5 Standard median');

disp('-----Finish Solving Problem I part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 3 {{{
moon = imread('Moon.jpg');
strong_laplacian = [ 1  1  1;
                     1 -8  1;
                     1  1  1 ];
filtered_moon = conv2(double(moon), strong_laplacian, 'same');
m = min(filtered_moon(:));
M = max(filtered_moon(:));
scaled_moon = uint8((filtered_moon - m) ./ (M - m) * 255.0);
enhanced_moon = uint8(double(moon) - filtered_moon);

% show the moon images
figure(3);
subplot(2, 2, 1);
imshow(moon);
title('Original moon.jpg');
subplot(2, 2, 2);
imshow(filtered_moon, [0 255]);
title('Filtered moon');
subplot(2, 2, 3);
imshow(scaled_moon);
title('Filtered & scaled moon');
subplot(2, 2, 4);
imshow(enhanced_moon);
title('Enhanced moon');

disp('-----Finish Solving Problem I part 3-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

%% Problem II {{{
rice = imread('Rice.jpg');

% Part 1 {{{
% construct the sobel masks
normalized_rice = im2double(rice);
Gx = [ -1 -2 -1;
        0  0  0;
        1  2  1 ];
Gy = Gx';
Fx = imfilter(normalized_rice, Gx, 'replicate');
Fy = imfilter(normalized_rice, Gy, 'replicate');
F = abs(Fx) + abs(Fy);
c = max(F(:)) * 0.4375;
rice_edges = zeros(size(F), 'double');
rice_edges = double(F > c);

disp('I started with half of the maximum of F. I compared my edges image to that');
disp('produced by Matlab''s edge() function. I repeated this method, using a binary');
disp('search until I was satisfied with my edge image. My threshold value is 0.4375 of');
disp('the maximum of F.');

disp('-----Finish Solving Problem II part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

% Part 2 {{{
edge_histogram = CalEdgeHist(rice, 20);
% show the rice images
figure(4);
subplot(1, 3, 1);
imshow(rice);
title('Original rice.jpg');
subplot(1, 3, 2);
imshow(rice_edges);
title('My edges');
subplot(1, 3, 3);
bar([1:360/20:360], edge_histogram);
title('Edge histogram');

disp('-----Finish Solving Problem II part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

%clear -all
%close all force

