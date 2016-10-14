% Brendan Robeson
% CS 6680
% Assignment 4

clc
pause off

%% Problem II - Noise modeling {{{
city = imread('City.jpg');

%% Part 1 - Blurring {{{
k = 0.0025;

% build the filter according to the formula
%   H(u,v) = e^(-k D(u,v)^5/3)
sz = size(city);
rws = repmat([1:sz(1)]',     1, sz(2)); % a matrix of row numbers
cls = repmat([1:sz(2)],  sz(1),     1); % a matrix of column numbers
center = [ floor(sz(1) / 2 + 1), floor(sz(2) / 2 + 1) ];
filter = exp(-k .* ((rws - center(1)).^2 + (cls - center(2)).^2) .^ (5/6));

% apply the filter in the frequency domain, then convert back to spatial
blur_city = uint8(ifft2(ifftshift(fftshift(fft2(city)) .* filter)));
imwrite(blur_city, 'BlurCity.bmp');

% show the images
figure(3);
subplot(1, 3, 1);
imshow(city);
title('Original city.jpg');
subplot(1, 3, 2);
imshow(filter, []);
title('Filter H');
subplot(1, 3, 3);
imshow(blur_city);
title('Blurred city');

disp('-----Finish Solving Problem II part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 - Restoration {{{
g = 0.0001;
blur_city = imread('BlurCity.bmp');
filter_sq = filter.^2;
wiener_filter = filter_sq ./ (filter .* (filter_sq + g));
restored_city = ifft2(ifftshift(fftshift(fft2(blur_city)) .* wiener_filter));

% show the images
figure(4);
imshow(restored_city, []);
title('Restored city');

disp('-----Finish Solving Problem II part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

% }}}

return

%% Problem I - FFT filters {{{
sample = imread('Sample.jpg');

%% Part 1 - Gaussian low pass filter {{{
Do = 25;
%Do = 50;
two_d0_squared = 2 * Do^2;

% build a matrix such that the value of each element is the negative of the
% square distance from the center. the gaussian low-pass filter equation is
%   H(u,v) = e^(-D(u,v) * D(u,v) / 2 * Do^2)
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

%% Part 2 - Butterworth high pass filter {{{
Do = 50;
n = 2;

% build a matrix such that the value of each element is the distance from the
% center. the butterworth high-pass filter equation is
%                           1
%   H(u,v) = 1 - ----------------------
%                 1 + [D(u,v) / Do]^2n
% note that the alternate form introduces a division by 0 for the center pixel,
% so this form is used.
sz = size(sample);
rws = repmat([1:sz(1)]',     1, sz(2)); % a matrix of row numbers
cls = repmat([1:sz(2)],  sz(1),     1); % a matrix of column numbers
center = [ floor(sz(1) / 2 + 1), floor(sz(2) / 2 + 1) ];
D = sqrt((rws - center(1)).^2 + (cls - center(2)).^2);

% complete the filter, combining the matrix of exponent numerators, and the
% scalar denominator. then apply the filter.
filter = 1 - 1 ./ (1 + (D ./ Do).^(2*n));
filtered_sample = ifft2(ifftshift(fftshift(fft2(sample)) .* filter));

% show the images
figure(2);
subplot(1, 3, 1);
imshow(sample);
title('Original sample.jpg');
subplot(1, 3, 2);
imshow(filter);
title('Butterworth high-pass filter');
subplot(1, 3, 3);
imshow(filtered_sample, []);
title('Filtered sample');

disp('-----Finish Solving Problem I part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

% }}}

clear -all
%close all force

