% Brendan Robeson
% CS 6680
% Assignment 3

clc
circuit = imread('Circuit.jpg');

%% Problem I {{{
%% Part 1 {{{
weighted_mask = [1 2 1; 2 4 2; 1 2 1];
weighted_mask = weighted_mask ./ sum(weighted_mask(:));
tic
weighted_image = AverageFiltering(circuit, weighted_mask);
toc

standard_mask = ones(5, 5);
standard_mask = standard_mask ./ sum(standard_mask(:));
tic
standard_image = AverageFiltering(circuit, standard_mask);
toc

% show the circuit images
figure(1);
subplot(1, 3, 1);
imshow(circuit);
title('Original circuit.jpg');
subplot(1, 3, 2);
imshow(weighted_image);
title('3x3 Weighted average');
subplot(1, 3, 3);
imshow(standard_image);
title('5x5 Standard average');

disp('-----Finish Solving Problem I.1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 {{{
%weighted_mask = [1 2 1; 2 4 2; 1 2 1];
%weighted_mask = weighted_mask ./ sum(weighted_mask(:));
%weighted_image = AverageFiltering(circuit, weighted_mask);

standard_mask = ones(5, 5);
tic
standard_image = MedianFiltering(circuit, standard_mask);
toc

% show the circuit images
figure(2);
subplot(1, 3, 1);
imshow(circuit);
title('Original circuit.jpg');
%subplot(1, 3, 2);
%imshow(weighted_image);
%title('3x3 Weighted average');
subplot(1, 3, 3);
imshow(standard_image);
title('5x5 Standard median');

disp('-----Finish Solving Problem I.2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

clear -all
close all force

