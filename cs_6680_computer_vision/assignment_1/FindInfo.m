% Brendan Robeson
% CS 6680
% Assignment 1

function [maxValue, minValue, meanValue, medianValue] = FindInfo(oriIm)
% FINDINFO  Calculate the minimum, maximum, mean, and median intensities of an image.
%   [maxValue, minValue, meanValue, medianValue] = FINDINFO(oriIm)

[rows, cols] = size(oriIm);
minValue = oriIm(1, 1);
maxValue = oriIm(1, 1);
total = double(oriIm(1, 1));
for r = 2:rows
    for c = 2:cols
        if oriIm(r, c) < minValue
            minValue = oriIm(r, c);
        elseif maxValue < oriIm(r, c)
            maxValue = oriIm(r, c);
        end
        total = total + double(oriIm(r, c));
    end
end
meanValue = total / double(rows * cols);

% sort the values into a single column
sorted_list = sort(oriIm(:));
len = size(sorted_list, 1);

% min, max, and mean are straight forward
minValue = sorted_list(1);
maxValue = sorted_list(len);
meanValue = sum(sorted_list) / len;

% calculating the median varies if there are an even or odd number of elements
if mod(len, 2) == 0 % even
    medianValue = (sorted_list(len / 2) + sorted_list(len / 2 + 1)) / 2;
else % odd
    medianValue = sorted_list((len + 1) / 2);
end
end
