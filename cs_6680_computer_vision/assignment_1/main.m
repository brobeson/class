% Brendan Robeson
% CS 6680
% Assignment 1

% =================================================
% Problem 1
A = imread('peppers.bmp');
figure(1);
imshow(A);
title('RGB Original Image');
disp('-----Finish Solving Problem 1-----')
pause

% =================================================
% Problem 2
B = rgb2gray(A);

% second test case
% TODO  make sure this is commented out, or deleted, before submitting
%B = [64  2  3 61; ...
%      9 55 54 12; ...
%     17 47 46 20; ...
%     40 26 27 37];

% TODO  this is wrong. it works for the 4x4 test matrix, the explicit dimensions
%       make it fail for the image.
VB = [B(:, 3:4) B(:, 1:2)];
TB = transpose(B);
FB = fliplr(B);
figure(2);

% draw B in the upper left
subplot(2, 2, 1);
imshow(B);
title('B');

% TODO  is this the best method to switch axes?
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

% =================================================
% Problem 3
% Matlab results
b_minimum = min(min(B));
b_maximum = max(max(B));
b_mean = mean(mean(B));
b_median = median(median(B));

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

if b_mean == fi_b_mean
    disp(['FindInfo and Matlab agree the mean is ' num2str(b_mean) '.']);
else
    disp('Error in the mean caclulation:');
    disp(['    Matlab reports ' num2str(b_mean)]);
    disp(['    FindInfo reports ' num2str(fi_b_mean)]);
end

if b_median == fi_b_median
    disp(['FindInfo and Matlab agree the median is ' num2str(b_median) '.']);
else
    disp('Error in the median caclulation:');
    disp(['    Matlab reports ' num2str(b_median)]);
    disp(['    FindInfo reports ' num2str(fi_b_median)]);
end

disp('-----Finish Solving Problem 3-----')
pause

% =================================================
% Problem 4
%disp('-----Finish Solving Problem 4-----')
%pause

% =================================================
% Problem 5
%disp('-----Finish Solving Problem 5-----')
%pause

% =================================================
% Problem 6
%disp('-----Finish Solving Problem 6-----')
%pause

% =================================================
% Problem 7
%disp('-----Finish Solving Problem 7-----')
%pause
