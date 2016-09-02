function [maxValue, minValue, meanValue, medianValue] = FindInfo(oriIm)
% sort the values into a single column. this will be immensely useful for
% everything else.
sorted_list = sort(oriIm(:));
[len, trash] = size(sorted_list);

% min, max, and mean are straight forward
minValue = sorted_list(1);
maxValue = sorted_list(len);
meanValue = sum(sorted_list) / len;

% calculating the median varies if there are an even or odd number of elements
if mod(len, 2) == 0 % even
    medianValue = (sorted_list(len / 2) + sorted_list(len / 2 + 1)) / 2;
else
    medianValue = sorted_list(len / 2 + 1);
end
end
