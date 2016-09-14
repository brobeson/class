% Brendan Robeson
% CS 6680
% Assignment 2

food = imread('Food.jpg');

% Problem 1 {{{
[scaled_image scale_function] = Scaling(food, [0, 255]);
r = [min(min(food)):max(max(food))];
figure 1;
plot(r, scale_function);
axis([0 255 0 255]);
xlabel('Original image intensity, i');
ylabel('ScaledIm image intensity, f(i)');
title('Linear Scaling of an Image');

disp('-----Finish Solving Problem 1-----')
pause
% }}}

clear -all
close all force

