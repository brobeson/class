% Brendan Robeson
% CS 6680
% Assignment 2

food = imread('Food.jpg');

% Problem 1 {{{
[scaled_food scale_function] = Scaling(food, [0, 255]);
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

% Problem 2 {{{
%matScaledFood = imadjust(food, [0; 255]) .* 255;
matScaledFood = imadjust(food, [min(min(food)); max(max(food))], [0; 255]);
%class(matScaledFood)
%min(min(matScaledFood))
%max(max(matScaledFood))
figure 2;
subplot(1, 2, 1);
imshow(scaled_food);
title('My scaled food');

subplot(1, 2, 2);
imshow(matScaledFood);
title('Matlab scaled food');

disp('-----Finish Solving Problem 2-----')
pause
% }}}

clear -all
close all force

