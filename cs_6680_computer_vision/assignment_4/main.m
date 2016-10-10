% Brendan Robeson
% CS 6680
% Assignment 4

clc
pause off

%% Problem I - FFT filters {{{
sample = imread('Sample.jpg');

%% Part 1 - Gaussian low pass filter {{{
filter = zeros(size(sample));
filter_size = size(filter);
center = [ floor(filter_size(1) / 2 + 1), floor(filter_size(2) / 2 + 1) ];
D0 = 25;
%D0 = 50;
two_d_square = 2 * D0^2;
for r = 1:size(filter, 1)
    for c = 1:size(filter, 2)
        % no reason to take square root, only to square it in the next operation
        distance_squared = (r - center(1)) ^ 2 + (c - center(2)) ^ 2;
        filter(r, c) = exp(-distance_squared / two_d_square);
    end
end

filtered_sample = ifft2(ifftshift(fftshift(fft2(sample)) .* filter));

% show the images
figure(1);
subplot(1, 3, 1);
imshow(sample);
title('Original sample.jpg');
subplot(1, 3, 2);
imshow(filter);
title('Gaussian low-pass filter');
subplot(1, 3, 3);
imshow(filtered_sample, []);
title('Filtered sample');

disp('-----Finish Solving Problem I part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

% }}}

clear -all
%close all force

