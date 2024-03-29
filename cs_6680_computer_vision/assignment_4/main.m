% Brendan Robeson
% CS 6680
% Assignment 4

%% Problem I - FFT filters {{{
sample = imread('Sample.jpg');

%% Part 1 - Gaussian low pass filter {{{
Dx = 25;
Dy = 50;

% build up the gaussian low-pass filter:
%     e^(-D(u,v)^2 /  2Do^2)
%   = e^( D(u,v)^2 / -2Do^2)
denominators = [ -2 * Dy^2, -2 * Dx^2 ];
[rows, cols] = size(sample);
center_row = floor(rows / 2) + 1;
center_col = floor(cols / 2) + 1;
% each row is the square distance from the center row
row_matrix = repmat(([1:rows] - center_row).^2',    1, cols);
% each column is the square distance from the center column
col_matrix = repmat(([1:cols] - center_col).^2,  rows,    1);
filter = exp(row_matrix ./ denominators(1) + col_matrix ./ denominators(2));

% transform to shifted frequency, apply the filter, and convert back to spatial
filtered_sample = ifft2(ifftshift(fftshift(fft2(sample)) .* filter));

% show the images
figure(1);
subplot(1, 3, 1);
imshow(sample);
title('Original sample');
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
% note also, that the number of operations can be reduced by transforming the
% math a little bit:
%     [D(u,v) / Do]^2n
%   = D(u,v)^2n / Do^2n
%   = sqrt((p_u - c_u)^2 + (p_v - c_v)^2)^2n / Do^2n
%   = ((p_u - c_u)^2 + (p_v - c_v)^2)^n / Do^2n
[rows, cols] = size(sample);
center_row = floor(rows / 2) + 1;
center_col = floor(cols / 2) + 1;
row_matrix = repmat([1:rows]',     1, cols); % a matrix of row numbers
col_matrix = repmat([1:cols] ,  rows,    1); % a matrix of column numbers
D = ((row_matrix - center_row).^2 + (col_matrix - center_col).^2).^n;

% complete the filter, combining the matrix of exponent numerators, and the
% scalar denominator. then apply the filter.
filter = 1 - 1 ./ (1 + (D ./ Do.^(2*n)));
filtered_sample = ifft2(ifftshift(fftshift(fft2(sample)) .* filter));

% show the images
figure(2);
subplot(1, 3, 1);
imshow(sample);
title('Original sample');
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

%% Problem II - Noise modeling {{{
city = imread('City.jpg');

%% Part 1 - Blurring {{{
k = 0.0025;

% build the filter according to the formula
%   H(u,v) = e^(-k D(u,v)^5/3)
[rows, cols] = size(city);
row_matrix = repmat([1:rows]',    1, cols); % a matrix of row numbers
col_matrix = repmat([1:cols] , rows,    1); % a matrix of column numbers
center_row = floor(rows / 2) + 1;
center_col = floor(cols / 2) + 1;
% note that sqrt(x)^5/3 == x^5/6
filter = exp(-k .* ((row_matrix - center_row).^2 + (col_matrix - center_col).^2) .^ (5/6));

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

%% Problem III - Frequency domain {{{
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
capitol_fft = capitol_mag .* exp(capitol_phase .* sqrt(-1));
new_capitol = ifft2(ifftshift(capitol_fft), 'symmetric');

sample_fft = sample_mag .* exp(sample_phase .* sqrt(-1));
new_sample = ifft2(ifftshift(sample_fft), 'symmetric');

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
highest_mags = sorted(2:5);
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

% step 5
disp('It''s very evident that the noise is periodic in nature, which is produced by');
disp('high amplitudes in the frequency domain. Blending those frequencies with');
disp('adjacent ones smooths out the noise.');

disp('-----Finish Solving Problem IV-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Problem V - Wavelets {{{
lena = imread('Lena.jpg');
wavelet_type = 'db2';

% Part 1 - Deconstruction & reconstruction {{{
max_level = wmaxlev(size(lena), wavelet_type);
[coefficients, sizes] = wavedec2(double(lena), max_level, wavelet_type);
reconstructed_lena = uint8(waverec2(coefficients, sizes, wavelet_type));
if (isequal(lena, reconstructed_lena))
    disp('Original Lena and reconstructed Lena are equal.');
else
    disp('Original Lena and reconstructed Lena are not equal.');
end

disp('-----Finish Solving Problem V part 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

% Part 2 - Wavelet modification {{{
level = floor(max_level / 2);
[coefficients, sizes] = wavedec2(double(lena), level, wavelet_type);

% part a - set approximation coefficients to 0, and reconstruct
coefficients_a = coefficients;
coefficients_a(1:sizes(1)*sizes(2)) = 0;
lena_a = uint8(waverec2(coefficients_a, sizes, wavelet_type));

% part b - set 2nd level horizontal coefficients to 0, and reconstruct
% calculate the start and end index for the horizontal coefficients. start at
% the end of the coefficients and work backwards: pass the 1st level
% coefficients, and the vertical & diagonal 2nd level coefficients.
lvl_1_row = size(sizes, 1) - 1;                                 % row of the 1st level coefficient sizes
lvl_2_row = lvl_1_row - 1;                                      % row of the 2nd level coefficient sizes
wavelet_length = 3 * sizes(lvl_1_row, 1) * sizes(lvl_1_row, 2); % # of 1st level coefficients
lvl_2_stop = size(coefficients, 2) - wavelet_length;            % last index of the 2nd level coefficients
lvl_2_stop = lvl_2_stop - (2 * sizes(lvl_2_row, 1) * sizes(lvl_2_row, 2));  % last index of the 2nd lvl hor. coeff.
lvl_2_start = lvl_2_stop - (sizes(lvl_2_row, 1) * sizes(lvl_2_row, 2)) + 1; % first index of the 2nd lvl hor. coeff.

% modify the coefficients and reconstruct
coefficients_b = coefficients;
coefficients_b(lvl_2_start:lvl_2_stop) = 0;
lena_b = uint8(waverec2(coefficients_b, sizes, wavelet_type));

figure;
subplot(1, 2, 1);
imshow(lena_a, []);
title('0 approximation');
subplot(1, 2, 2);
imshow(lena_b, []);
title('0 horizontal');

disp('Part A set the intensity information to 0, which propagates up to the');
disp('reconstruction, giving a predominantly black appearance. Setting the horizontal');
disp('coefficients to 0 removes any difference between horizontally adjacent pixels,');
disp('creating small horizontal streaks.');

disp('-----Finish Solving Problem V part 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}
% }}}

%% Problem VI - Denoise via wavelets {{{
% step 1 - add noise to lena.jpg
lena = imread('Lena.jpg');
noisy_lena = imnoise(lena, 'gaussian', 0, 0.01);

% step 2 - wavelet decomposition
wavelet_type = 'db2';
level = 3;
[coefficients, sizes] = wavedec2(noisy_lena, level, wavelet_type);

% step 3 - noise variance estimation
stop_index = size(coefficients, 2);
start_index = stop_index - (sizes(4, 1) * sizes(4, 2) * 3) + 1;
subband = coefficients(start_index:stop_index);
variance = (median(abs(subband)) / 0.6745)^2;

% step 4 - adaptive threshold
t = sqrt(variance * 2 * log10(size(subband, 2)));

% step 5 - wavelet coefficient modification
for idx = start_index:stop_index
    if t <= coefficients(idx)
        coefficients(idx) = coefficients(idx) - t;
    elseif coefficients(idx) <= -t
        coefficients(idx) = coefficients(idx) + t;
    else
        coefficients(idx) = 0;
    end
end

% step 6 - repeat 3, 4, and 5 for level 2
start_index = sizes(1, 1) * sizes(1, 2)     ... % by pass the approximation coeff.
            + sizes(2, 1) * sizes(2, 2) * 3 ... % bypass the level 3 approximation coeff.
            + 1;
stop_index = start_index + sizes(3, 1) * sizes(3, 2) * 3 - 1;
subband = coefficients(start_index:stop_index);
variance = (median(abs(subband)) / 0.6745)^2;
t = sqrt(variance * 2 * log10(size(subband, 2)));
for idx = start_index:stop_index
    if t <= coefficients(idx)
        coefficients(idx) = coefficients(idx) - t;
    elseif coefficients(idx) <= -t
        coefficients(idx) = coefficients(idx) + t;
    else
        coefficients(idx) = 0;
    end
end

% step 7 - repeat 3, 4, and 5 for level 3
start_index = sizes(1, 1) * sizes(1, 2) + 1; % by pass the approximation coeff.
stop_index = start_index + sizes(2, 1) * sizes(2, 2) * 3 - 1;
subband = coefficients(start_index:stop_index);
variance = (median(abs(subband)) / 0.6745)^2;
t = sqrt(variance * 2 * log10(size(subband, 2)));
for idx = start_index:stop_index
    if t <= coefficients(idx)
        coefficients(idx) = coefficients(idx) - t;
    elseif coefficients(idx) <= -t
        coefficients(idx) = coefficients(idx) + t;
    else
        coefficients(idx) = 0;
    end
end

% step 8 - reconstruct the image
clean_lena = uint8(waverec2(coefficients, sizes, wavelet_type));

% step 9 - display
figure(9);
subplot(1, 2, 1);
imshow(noisy_lena);
title('Noisy lena');
subplot(1, 2, 2);
imshow(clean_lena);
title('Clean lena');

disp('-----Finish Solving Problem VI-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

clear -all
close all force

