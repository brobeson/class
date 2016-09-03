function [maxValue, minValue, meanValue, medianValue] = FindInfo(oriIm)
% FINDINFO  Calculate the minimum, maximum, mean, and median intensities of an image.
%   [maxValue, minValue, meanValue, medianValue] = FINDINFO(oriIm)

% sort the values into a single column. this will be immensely useful for
% everything else. size() will return the number of rows, and 1 column. the
% column isn't needed, thus store it in a trash variable
sorted_list = sort(oriIm(:));
[len, trash] = size(sorted_list);

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
