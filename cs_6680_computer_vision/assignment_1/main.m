% Brendan Robeson
% CS 6680
% Assignment 1

% =================================================
% Problem 1 {{{
A = imread('peppers.bmp');
figure(1);
imshow(A);
title('RGB Original Image');
disp('-----Finish Solving Problem 1-----')
pause
% }}}

% =================================================
% Problem 2 {{{
B = rgb2gray(A);
TB = transpose(B);
VB = circshift(B, [0, size(B, 2) / 2]); % circular shift by half the number of columns in B
FB = fliplr(B);

% draw B in the upper left
figure(2);
subplot(2, 2, 1);
imshow(B);
title('B');

% draw TB in the upper right
subplot(2, 2, 2);
imshow(TB);
title('TB');

% draw VB in the lower left
subplot(2, 2, 3);
imshow(VB);
title('VB');

% draw FB in the lower right
subplot(2, 2, 4);
imshow(FB);
title('FB');

disp('-----Finish Solving Problem 2-----')
pause
% }}}

% =================================================
% Problem 3 {{{
% second test case with even number of entries for median calculation
% TODO  make sure this is commented out, or deleted, before submitting
%B = [ 64    2    3   61; ...
%       9   55   54   12; ...
%      17   47   46   20; ...
%      40   26   27   37 ];

% third test case with odd number of entries for median calculation
% TODO  make sure this is commented out, or deleted, before submitting
%B = [ 64    2    3; ...
%       9   55   54; ...
%      17   47   46 ];

% Matlab results
b_minimum = min(min(B)); % faster than min(B(:))
b_maximum = max(max(B)); % faster than max(B(:))
b_mean = mean2(B);       % on par with mean(mean(B)) and mean(B(:))
b_median = median(B(:)); % only option to correctly calculate the median

% my FindInfo results
[fi_b_maximum, fi_b_minimum, fi_b_mean, fi_b_median] = FindInfo(B);

% compare and report the results
if b_minimum == fi_b_minimum
    disp(['FindInfo and Matlab agree the minimum is ' num2str(b_minimum) '.']);
else
    disp('Error in the minimum caclulation:');
    disp(['    Matlab reports ' num2str(b_minimum)]);
    disp(['    FindInfo reports ' num2str(fi_b_minimum)]);
end

if b_maximum == fi_b_maximum
    disp(['FindInfo and Matlab agree the maximum is ' num2str(b_maximum) '.']);
else
    disp('Error in the maximum caclulation:');
    disp(['    Matlab reports ' num2str(b_maximum)]);
    disp(['    FindInfo reports ' num2str(fi_b_maximum)]);
end

% note that directly comparing two floating point values is poor practice. the
% assignmnt doesn't state an acceptable "close enough" threshold. i think if the
% two values are within 1/1000 of each other, it's acceptable for this
% assignment. this applies to the median comparison, as well.
if abs(b_mean - fi_b_mean) <= 0.001
    disp(['FindInfo and Matlab agree the mean is ' num2str(b_mean) '.']);
else
    disp('Error in the mean caclulation:');
    disp(['    Matlab reports ' num2str(b_mean)]);
    disp(['    FindInfo reports ' num2str(fi_b_mean)]);
end

if abs(b_median - fi_b_median) <= 0.001
    disp(['FindInfo and Matlab agree the median is ' num2str(b_median) '.']);
else
    disp('Error in the median caclulation:');
    disp(['    Matlab reports ' num2str(b_median)]);
    disp(['    FindInfo reports ' num2str(fi_b_median)]);
end

disp('-----Finish Solving Problem 3-----')
pause
% }}}

% =================================================
% Problem 4 {{{
% normalize image B
C = double(B - b_minimum) ./ double(b_maximum - b_minimum);
figure(3);
imshow(C);
title('Normalized Grayscale Image');

% process the right and left quarters of the image with a power function
D = C;
cols = size(D, 2);
D(:, 3 * cols / 4:cols) = D(:, 3 * cols / 4:cols) .^ 1.5;
D(:, 1:cols / 4) = D(:, 1:cols / 4) .^ 0.5;
figure(4);
imshow(D);
title('Processed Grayscale Image');
imwrite(D, 'Brendan_D.jpg')
disp('-----Finish Solving Problem 4-----')
pause
% }}}

% =================================================
% Problem 5 {{{
threshold = 0.3;

% method 1
bw1 = C;
bw1(bw1 <= threshold) = 0.0;
bw1(bw1 > threshold) = 1.0;

% method 2
bw2 = zeros(size(C));
bw2(C > threshold) = 1.0;

% Matlab method
bw3 = im2bw(C, threshold);

% check my results
if isequal(bw1, bw3) && isequal(bw2, bw3)
    disp('Both of my methods worked.');
elseif isequal(bw1, bw3)
    disp('My method 1 worked, but not my method 2.');
elseif isequal(bw2, bw3)
    disp('My method 2 worked, but not my method 1.');
else
    disp('Both of my methods did not work.');
end

% display all three side by side
figure(5);
subplot(1, 3, 1);
imshow(bw1);
title('My first method');
subplot(1, 3, 2);
imshow(bw2);
title('My second method');
subplot(1, 3, 3);
imshow(bw1);
title('Matlab method');

disp('-----Finish Solving Problem 5-----')
pause
% }}}

% =================================================
% Problem 6 {{{
% test case 2
% TODO  ensure this is commented, or removed, prior to submission
%A = rand(4, 4)
%mean2(A)

BA = BlurImage(A);
BB = BlurImage(B);

figure(6);
subplot(2, 2, 1);
imshow(A);
title('Original A');
subplot(2, 2, 2);
imshow(B);
title('Original B');
subplot(2, 2, 3);
imshow(BA);
title('Blurred A');
subplot(2, 2, 4);
imshow(BB);
title('Blurred B');
disp('-----Finish Solving Problem 6-----')
pause
% }}}

% =================================================
% Problem 7 {{{
close all force
clear -all
disp('-----Finish Solving Problem 7-----')
pause
% }}}
