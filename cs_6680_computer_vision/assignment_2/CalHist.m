% Brendan Robeson
% CS 6680
% Assignment 2

function histogram = CalHist(img)
% verify the input
assert(isa(img, 'uint8') != 0, 'input image must be of type uint8, not %s', class(img));

histogram(1:256) = 0;
for i = [0:255]
    histogram(i + 1) = sum(sum(img == i));
end
end
