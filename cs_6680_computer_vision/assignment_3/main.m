% Brendan Robeson
% CS 6680
% Assignment 3

clc
warning('off');
circuit = imread('Circuit.jpg');

%% Problem I {{{
%% Part 1 {{{
weighted_mask = [1 2 1; 2 4 2; 1 2 1];
weighted_mask = weighted_mask ./ sum(weighted_mask(:));
weighted_image = AverageFiltering(circuit, weighted_mask);

standard_mask = ones(5, 5);
standard_mask = standard_mask ./ sum(standard_mask(:));
standard_image = AverageFiltering(circuit, standard_mask);

% plot the scale_function as a function of the intensties in 'food'
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
% }}}

%clear -all
%close all force

