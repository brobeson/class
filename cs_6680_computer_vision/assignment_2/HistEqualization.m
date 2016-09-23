% Brendan Robeson
% CS 6680
% Assignment 2

function [enhancedIm, transFunc] = HistEqualization(inputIm)
% HISTEQUALIZATION  Perform histogram equalization on an image.
%   [enhancedIm, transFunc] = HistEqualization(inputIm)
%
%   inputIm is the original image, on which histogram equalization is performed.
%
%   enhancedIm is the resulting image after histogram equalization.
%
%   transFunc is the transformation function from inputIm to enhanceIm. This is
%   a look up table. A table index is an original intensity value on [0, 255],
%   and the table value is the corresponding output intensity value, also on [0,
%   255].

    % verify the input and expected output
    assert(isa(inputIm, 'uint8') ~= 0, 'input image must be of type uint8, not %s', class(inputIm));

    % calculate the cumulative normalized histogram. fetch the normalized
    % histogram from the function written for problem 3, the step through it
    % accumulating.
    norm_histogram = CalHist(inputIm, true);

    for i = 2:length(norm_histogram)
        norm_histogram(i) = norm_histogram(i) + norm_histogram(i - 1);
    end

    % calculate the transformation function
    transFunc = uint8(norm_histogram .* 255.0);

    % enhance the image
    [rows, cols] = size(inputIm);
    enhancedIm = zeros(rows, cols, 'uint8');
    for i = 1:rows * cols
        enhancedIm(i) = transFunc(inputIm(i) + 1);
    end
end
