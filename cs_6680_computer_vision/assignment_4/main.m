% Brendan Robeson
% CS 6680
% Assignment 4

clc
pause off

%% Problem I - FFT filters {{{
sample = imread('Sample.jpg');

%% Part 1 - Gaussian low pass filter {{{
D0 = 25;
%D0 = 50;
two_d0_squared = 2 * D0^2;

% build a matrix such that the value of each element is the negative of the
% square distance from the center. the gaussian low-pass filter equation is
%   H(u,v) = e^(-D(u,v) * D(u,v) / 2 * D0^2)
% this matrix is the numerator of the exponent.
sz = size(sample);
rws = repmat([1:sz(1)]',     1, sz(2)); % a matrix of row numbers
cls = repmat([1:sz(2)],  sz(1),     1); % a matrix of column numbers
center = [ floor(sz(1) / 2 + 1), floor(sz(2) / 2 + 1) ];
neg_d_squared = -((rws - center(1)).^2 + (cls - center(2)).^2);

% complete the filter, combining the matrix of exponent numerators, and the
% scalar denominator. then apply the filter.
filter = exp(neg_d_squared ./ two_d0_squared);
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

