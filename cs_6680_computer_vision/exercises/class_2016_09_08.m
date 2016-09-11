% Brendan Robeson
% CS 6680
% In class exercises

% These exercies were assigned on 2016 September 08 in class. Professor Qi wants
% us to be prepared to present solutions in class on 2016 September 13.

clear -all
close all force

%% Problem 1 {{{
% What does imshow(A, [ ]) do? What are the acceptable data types for variable A?
%
% imshow(A, []) will stretch A to fill the gamut of its data type. If A has
% intensity values that are unsigned bytes, the image will be remapped from
% [min, max] to [0, 255]. If A has floating point intensity values, the image
% will be remapped from [min, max] to [0, 1].
%
% A can be a 2D or 3D image. That is, a grayscale or RGB image. The data can be
% floating point, on [0, 1]. Or they can be unsigned byte, on [0, 255].

% load an image, and convert it to grayscale for 
original = rgb2gray(imread('peppers.bmp'));

% cut the intensity in half as a starting point
halved = original ./ 2;

% convert to floating point representation
fp = im2double(halved);

figure;
subplot(2, 2, 1);
imshow(original);
title('Original');

subplot(2, 2, 2);
imshow(halved);
title('Halved');

subplot(2, 2, 3);
imshow(halved, []);
title('Unsigned Byte []');

subplot(2, 2, 4);
imshow(fp, []);
title('Floating Point []');

pause
%}}}

%% Problem 2 {{{
% Write down mathematical formulas for all the 6 solid black curves on slide #9
% of class lecture Ch3.1.DIPBasicSpatial.pdf.
%
% The curves are: negative, log, nth root, identity, nth power, and inverse log
%
% negative:    f(l) = L - 1 - l for l on [0, L - 1]
% log:         f(l) = l^0.2     for l on [0, 1]
% nth root:    f(l) = sqrt(l)   for l on [0, 1]
% identity:    f(l) = l         for l on [0, L - 1]
% nth power:   f(l) = l^2       for l on [0, 1]
% inverse log: f(l) = l^5       for l on [0, 1]

% define the X range. the power functions only work on [0, 1], so that's the
% range used.
x0 = 0.0;
xN = 1.0;
steps = 100; % divide the range into 100 steps to get smooth curves
x = [x0: (xN - x0) / steps: xN];

% the six curves detailed above
y_negative = 1.0 - x;
y_log = x .^ 0.2;
y_nth_root = x .^ 0.5;
y_identity = x;
y_nth_power = x .^ 2;
y_inverse_log = x .^ 5;

% draw the curves
figure
y = 0.75;
plot(x, y_negative,
     x, y_log,
     x, y_nth_root,
     x, y_identity,
     x, y_nth_power,
     x, y_inverse_log);
xlabel('Input gray level, r');
ylabel('Output gray level, s');
title('Intensity Transformations');
legend('s(r) = L - r',
       's(r) = x^{0.2}',
       's(r) = x^{0.5}',
       's(r) = r',
       's(r) = x^2',
       's(r) = x^5');
axis square;
ax = gca;
set(ax, 'XTick', [x0: 0.1: xN]);
set(ax, 'YTick', [x0: 0.1: xN]);
%ax.XTick = [x0:0.1:xN];
%ax.YTick = [x0:0.1:xN];

% draw the same lines visible in the notes
line([x0 xN], [0.5 0.5]);
line([x0 xN], [0.75 0.75]);
line([0.5 0.5], [0 1]);
line([0.25 0.25], [0 1]);

pause

%}}}

clear -all
close all force
