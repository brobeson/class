% Brendan Robeson
% CS 6680
% Assignment 2

clc
food = imread('Food.jpg');
new_range = [0 255];

% to use fprintf to standard output
std_out = 1;

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
output_range = [double(new_range(1)); double(new_range(2))] ./ 255.0;
input_range = [double(min(min(food))); double(max(max(food)))] ./ 255.0;
matScaledFood = imadjust(food, input_range, output_range);

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

%% Problem 4 {{{
tic
[equalizedFood, transformation] = HistEqualization(food);
my_time = toc;
fprintf(std_out, 'HistEqualization(food) took %f seconds\n', my_time);

disp('-----Finish Solving Problem 4-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
%}}}

%% Problem 5 {{{
tic
[mat_equalizedFood, mat_transformation] = histeq(food);
mat_time = toc;
fprintf(std_out, '[J, T] = histeq(food) took %f seconds\n', mat_time);

% compare the run time of histeq() to HistEqualization()
if (mat_time < my_time)
    fprintf(std_out, 'histeq() ran %f seconds faster than HistEqualization().\n', my_time - mat_time);
elseif (my_time < mat_time)
    fprintf(std_out, 'HistEqualization() ran %f seconds faster than histeq().\n', mat_time - my_time);
else
    disp('HistEqualization() and histeq() ran in equal time.');
end

% compare the transformation functions
disp('HistEqualization() returns a look up table mapping the original intensity to an output intensity.');
disp('histeq() returns the cumulative normalized histogram (CNH). However, we can see from the graphs');
disp('that both functions are similar. Completing the operation with histeq()''s CNH will produce a look');
disp('up table similar to mine.');
%if (isequal(mat_transformation, transformation))
%    disp('HistEqualization() and histeq() found identical transformation functions');
%else
%    disp('HistEqualization() and histeq() found different transformation functions');
%end

disp('Reading histeq(), I learned how MathWorks analyzes the propertiess of the input parameters');
disp('to determine which version of the function the user requested. For example, histeq()');
disp('checks the number fo columns in the second parameter to determine if the user invoked');
disp('histeq(img, histgram) or histeq(img, color_map). This seems pretty handy to know, given');
disp('that function overloading is not possible.');

figure(4);
subplot(1, 2, 1);
imshow(equalizedFood);
title('My equalized food');

subplot(1, 2, 2);
imshow(mat_equalizedFood);
title('Matlabs equalized food');

figure(5);
subplot(1, 2, 1);
bar(0:length(transformation) - 1, transformation, 1.0);
xlabel('Original intensity');
ylabel('Transformed intensity');
title('My transformation function');

subplot(1, 2, 2);
bar(0:length(mat_transformation) - 1, mat_transformation, 1.0);
xlabel('Original intensity');
ylabel('Transformed intensity');
title('Matlabs transformation function');

disp('-----Finish Solving Problem 5-----')
drawnow; % work around Matlab R2016a bug that can cause 'pause' to hang
pause
%}}}

clear -all
close all force

