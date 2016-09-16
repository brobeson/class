% Brendan Robeson
% CS 6680
% Assignment 2

food = imread('Food.jpg');

% Problem 1 {{{
[scaled_food, scale_function] = Scaling(food, [0, 255]);
r = [min(min(food)):max(max(food))];
figure;
plot(r, scale_function);
axis([0 255 0 255]);
xlabel('Original image intensity, i');
ylabel('ScaledIm image intensity, f(i)');
title('Linear Scaling of an Image');

disp('-----Finish Solving Problem 1-----')
pause
% }}}

% Problem 2 {{{
matScaledFood = imadjust(food);
%matScaledFood = imadjust(food, [0; 255]) .* 255;
%matScaledFood = imadjust(food, [min(min(food)); max(max(food))], [0; 255]);
%class(matScaledFood)
%min(min(matScaledFood))
%max(max(matScaledFood))
figure;
subplot(1, 2, 1);
imshow(scaled_food);
title('My scaled food');

subplot(1, 2, 2);
imshow(matScaledFood);
title('Matlab scaled food');

disp('-----Finish Solving Problem 2-----')
pause
% }}}

% Problem 3 {{{
[histogram, norm_histogram] = CalHist(scaled_food, true);
i = [0:255];
figure;
bar(i, histogram, 1.0);
%axis([0 255]);
xlabel('Intensity, i');
ylabel('Occurances count');
title('Histogram of an Image');

disp('-----Finish Solving Problem 3-----')
pause
%}}}

clear -all
close all force

