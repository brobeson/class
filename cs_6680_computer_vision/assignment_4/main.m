% Brendan Robeson
% CS 6680
% Assignment 4

clc
pause off

%% Problem IV - Noise removal {{{
noisy_boy = imread('boy_noisy.gif');

% step 1
noisy_boy_dft = fftshift(fft2(noisy_boy));

% step 2
% extract the magnitudes from the DFT data. only the lower right corner of the
% matrix is required at the moment
magnitude = abs(noisy_boy_dft);
% sort the magnitude data, and extract the highest four after the highest.
% using unique() gives us distinct magnitudes as requested in the problem.
sorted = sort(unique(magnitude(:), 'stable'), 'descend');
highest_mags = sorted(2:5)
% find the indices of the highest magnitudes. use the full magnitude matrix,
% because the complex conjugates also need to be adjusted
h = (magnitude == highest_mags(1)) + ...
    (magnitude == highest_mags(2)) + ...
    (magnitude == highest_mags(3)) + ...
    (magnitude == highest_mags(4));
[rows, cols] = find(h);

% step 3
% copy the noisy boy DFT. this prevents adjacent high magnitudes from
% influenceing the math on each other.
mod_noisy_boy_dft = noisy_boy_dft;
avg_filter = [ 0.125 0.125 0.125;   % a filter to average a pixel's 8 neighbors
               0.125 0     0.125;
               0.125 0.125 0.125 ];
% for the high frequencies, replace the magnitude with the average of their
% neighbors. don't use imfilter here, because that will apply the filter to all
% nine elements (the magnitude of interest, and its neighbors).
for r = 1:8
    for c = 1:8
        mod_noisy_boy_dft(rows(r), cols(c)) = sum(sum(noisy_boy_dft(rows(r) - 1:rows(r) + 1, cols(c) - 1:cols(c) + 1) .* avg_filter));
    end
end

% step 4
boy = ifft2(ifftshift(mod_noisy_boy_dft), 'symmetric');
figure(7);
subplot(1, 2, 1);
imshow(noisy_boy);
title('Noisy boy');
subplot(1, 2, 2);
imshow(boy, []);
title('Boy');

% }}}

%% Problem III - Frequency domain {{{
% todo  remove this before submission
sample = imread('Sample.jpg');

capitol = imread('Capitol.jpg');

%% Part 1 - Visualizing magnitude & phase {{{
capitol_fft = fftshift(fft2(capitol));
capitol_mag = abs(capitol_fft);
capitol_mag_display = log10(capitol_mag - min(capitol_mag(:)) + 1);

%cp = atan2(imag(capitol_fft), real(capitol_fft));
%mn = min(cp(:))
%mx = max(cp(:))
capitol_phase = angle(capitol_fft);
%mn = min(capitol_phase(:))
%mx = max(capitol_phase(:))

sample_fft = fftshift(fft2(sample));
sample_mag = abs(sample_fft);
sample_mag_display = log10(sample_mag - min(sample_mag(:)) + 1);
sample_phase = angle(sample_fft);

% show the images
figure(3);
subplot(2, 2, 1);
imshow(capitol_mag_display, []);
title('Capitol magnitude');
subplot(2, 2, 2);
imshow(capitol_phase, []);
title('Capitol phase');
subplot(2, 2, 3);
imshow(sample_mag_display, []);
title('Sample magnitude');
subplot(2, 2, 4);
imshow(sample_phase, []);
title('Sample phase');

disp('-----Finish Solving Problem III part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Part 2 - Swapping phase {{{
% swap the two magnitude matrices
tmp = capitol_mag;
capitol_mag = sample_mag;
sample_mag = tmp;

% changing the phase, necessitates recalculating the FFT result.
% transforming the equations given in the notes results in the these equations
% to calculate the real and imaginary components:
%   R^2 = F^2 / (1 + tan^2(phi))
%   I = R tan(phi)
R = sqrt(capitol_mag.^2 ./ (1 + tan(capitol_phase).^2));
I = R .* tan(capitol_phase);
capitol_fft = complex(R, I);
new_capitol = ifft2(ifftshift(capitol_fft));

R = sqrt(sample_mag.^2 ./ (1 + tan(sample_phase).^2));
I = R .* tan(sample_phase);
sample_fft = complex(R, I);
new_sample = ifft2(ifftshift(sample_fft));

% show the images
figure(6);
subplot(1, 2, 1);
imshow(new_capitol, []);
title('Capitol phase');
subplot(1, 2, 2);
imshow(new_sample, []);
title('Sample phase');

disp('-----Finish Solving Problem III part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

% }}}

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

