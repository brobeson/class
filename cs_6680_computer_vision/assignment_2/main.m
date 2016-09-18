% Brendan Robeson
% CS 6680
% Assignment 2

clc
%pause off
food = imread('Food.jpg');
new_range = [0 255];

%% Problem 1 {{{
[scaled_food, scale_function] = Scaling(food, new_range);

% plot the scale_function as a function of the intensties in 'food'
figure(1);
plot(min(min(food)):max(max(food)), scale_function);
axis([0 255 0 255]);
xlabel('Original image intensity, i');
ylabel('ScaledIm image intensity, f(i)');
title('Linear Scaling of an Image');

disp('-----Finish Solving Problem 1-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Problem 2 {{{
r_out = [double(new_range(1)); double(new_range(2))] ./ 255.0;
r_in = [double(min(min(food))); double(max(max(food)))] ./ 255.0;
matScaledFood = imadjust(food, r_in, r_out);

figure(2);
subplot(1, 2, 1);
imshow(scaled_food);
title('My scaled food');

subplot(1, 2, 2);
imshow(matScaledFood);
title('Matlab scaled food');

disp('-----Finish Solving Problem 2-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
% }}}

%% Problem 3 {{{
[histogram, norm_histogram] = CalHist(scaled_food);
mat_norm_histogram = CalHist(matScaledFood, true);
i = 0:255;
figure(3);
subplot(1, 2, 1);
bar(i, norm_histogram, 1.0);
xlabel('Intensity');
ylabel('Occurance proportion');
title('Histogram of my scaled food');
xlim([-1 256]); % set X axis limits to show the counts for i=0 and i=255

subplot(1, 2, 2);
bar(i, mat_norm_histogram, 1.0);
xlabel('Intensity');
ylabel('Occurance proportion');
title('Histogram of Matlab scaled food');
xlim([-1 256]); % set X axis limits to show the counts for i=0 and i=255

disp('-----Finish Solving Problem 3-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
%}}}

%pause on

%% Problem 4 {{{
tic
[equalizedFood, transformation] = HistEqualization(food);
time = toc;
printf('HistEqualization(food) took %f seconds\n', time);

disp('-----Finish Solving Problem 4-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
%}}}

%% Problem 5 {{{
tic
[mat_equalizedFood, mat_transformation] = histeq(food);
mat_time = toc;
printf('[J, T] = histeq(food) took %f seconds\n', mat_time);

% compare the run time of histeq() to HistEqualization()
if (mat_time < my_time)
    printf('histeq() ran %f seconds faster than HistEqualization().\n', my_time - mat_time);
elseif (my_time < mat_time)
    printf('HistEqualization() ran %f seconds faster than histeq().\n', my_time - mat_time);
else
    disp('HistEqualization() and histeq() ran in equal time.');
end

% compare the transformation functions
if (isequal(mat_transformation, transformation))
    disp('HistEqualization() and histeq() found identical transformation functions');
else
    disp('HistEqualization() and histeq() found different transformation functions');
end

% todo lessons learned after reading the implementation of histeq()

figure(4);
subplot(1, 2, 1);
imshow(equalizedFood);
title('My equalized food');

subplot(1, 2, 2);
imshow(mat_equalizedFood);
title('Matlabs equalized food');

figure(5);
subplot(1, 2, 1);
bar(-1:size(transformation), transformation, 1.0);
xlabel('Original intensity');
ylabel('Transformed intensity');
title('My transformation function');

subplot(1, 2, 2);
bar(-1:size(mat_transformation), mat_transformation, 1.0);
xlabel('Original intensity');
ylabel('Transformed intensity');
title('Matlabs transformation function');

disp('-----Finish Solving Problem 5-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
%}}}

clear -all
close all force

