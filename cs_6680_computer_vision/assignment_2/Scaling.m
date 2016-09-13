% Brendan Robeson
% CS 6680
% Assignment 2

function [scaledIm, transFunc] = Scaling(inputIm, range)
% SCALING   Linearly scale a grayscale image.
%   [scaledIm, transFunc] = Scaling(inputIm, range)     Scales inputIm to range.
%
%   inputIm is the image to be rescaled. inputIm must be a grayscale image with
%   intensity values that are unsigned bytes, that is, in the range [0, 255].
%
%   range is a 2-component vector with the form [new_minimu new_maximum].
%
%   scaledIm is the result of scaling inputIm to the given range. It will be the
%   same size as inputIm and intensity values of the same data type.
%
%   transFunc TODO

% verify the input
assert(size(range, 1) == 1, 'range must have exactly one row, not %u.', size(range, 1));
assert(size(range, 2) == 2, 'range must have exactly two columns, not %u.', size(range, 2));
assert(range(1) <= range(2), 'range maximum (%u) must be greater than or equal to the minimum (%u).', range(2), range(1));
assert(0 <= range(1), 'range minimum (%u) must be non-negative.', range(1));
assert(0 <= range(2), 'range maximum (%u) must be non-negative.', range(2));
assert(range(1) <= 255, 'range minimum (%u) must be less than or equal to 255.', range(1));
assert(range(2) <= 255, 'range maximum (%u) must be less than or equal to 255.', range(2));
assert(isa(inputIm, 'uint8') != 0, 'input image must be of type uint8, not %s', class(inputIm));

% set up the transformation function
%n = max(max(inputIm)) - min(min(inputIm)) + 1;
%transFunc = zeros(n, 'uint8');

inputMax = max(max(inputIm));
inputMin = min(min(inputIm));

assert(inputMin != inputMax, 'input image has all the same values, resulting in division by 0');

inputRange = double(inputMax - inputMin);
outputRange = double(range(2) - range(1));
scaledIm = (inputIm - inputMin) .* (outputRange / inputRange) + range(1);

end

