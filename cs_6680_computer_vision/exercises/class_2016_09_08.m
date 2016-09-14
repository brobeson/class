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
% negative:    s(r) = L - 1 - r for r on [0, L - 1]
% log:         s(r) = r^0.2     for r on [0, 1]
% nth root:    s(r) = sqrt(r)   for r on [0, 1]
% identity:    s(r) = r         for r on [0, L - 1]
% nth power:   s(r) = r^2       for r on [0, 1]
% inverse log: s(r) = r^5       for r on [0, 1]
%
% for kicks, using perlin's bias function: s(b, r) = r^[ln(b) / ln(0.5)]
% log:         s(b = 0.87, r)
% nth root:    s(b = 0.70711, r)
% nth power:   s(b = 0.25, r)
% inverse log: s(b = 0.031250, r)
%
% n = ln(b) / ln(0.5)
% ln(b) = n * ln(0.5)
% b = e^[n * ln(0.5)]

% define the X range. the power functions only work on [0, 1], so that's the
% range used.
r0 = 0.0;
rN = 1.0;
steps = 100; % divide the range into 100 steps to get smooth curves
r = [r0: (rN - r0) / steps: rN];

% the six curves detailed above
s_negative = 1.0 - r;
s_log = r .^ 0.2;
s_nth_root = r .^ 0.5;
s_identity = r;
s_nth_power = r .^ 2;
s_inverse_log = r .^ 5;
s_bias_log = r .^ (log(0.87) / log(0.5));
s_bias_nth_root = r .^ (log(0.705) / log(0.5));
s_bias_nth_power = r .^ (log(0.25) / log(0.5));
s_bias_inverse_log = r .^ (log(0.03) / log(0.5));

% draw the curves
figure
plot(r, s_negative,
     r, s_log,
     r, s_nth_root,
     r, s_identity,
     r, s_nth_power,
     r, s_inverse_log,
     r, s_bias_log,
     r, s_bias_nth_root,
     r, s_bias_nth_power,
     r, s_bias_inverse_log);
xlabel('Input gray level, r');
ylabel('Output gray level, s(r)');
title('Intensity Transformations');
legend('s(r) = L - r',
       's(r) = r^{0.2}',
       's(r) = r^{0.5}',
       's(r) = r',
       's(r) = r^2',
       's(r) = r^5',
       'b = 0.87',
       'b = 0.71',
       'b = 0.25',
       'b = 0.03');
axis square;
ax = gca;
set(ax, 'XTick', [r0: 0.1: rN]);
set(ax, 'YTick', [r0: 0.1: rN]);
%ax.XTick = [r0:0.1:rN];
%ax.YTick = [r0:0.1:rN];

% draw the same lines visible in the notes
line([r0 rN], [0.5 0.5]);
line([r0 rN], [0.75 0.75]);
line([0.5 0.5], [0 1]);
line([0.25 0.25], [0 1]);

pause

%}}}

clear -all
close all force
