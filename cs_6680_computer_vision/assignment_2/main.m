% Brendan Robeson
% CS 6680
% Assignment 2

food = imread('Food.jpg');

% Problem 1 {{{
[scaledIm trans] = Scaling(food, [0, 255]);

figure;
imshow(scaledIm);

disp('-----Finish Solving Problem 1-----')
pause

clear
close
% }}}

