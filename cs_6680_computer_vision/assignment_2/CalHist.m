% Brendan Robeson
% CS 6680
% Assignment 2

function [histogram norm_histogram] = CalHist(img, normalized)
    % verify the input and expected output
    assert(isa(img, 'uint8') != 0, 'input image must be of type uint8, not %s', class(img));
    assert(nargout <= 2, 'CalHist cannot output more than two arguments.');
    if (nargin >= 2)
        if (nargout == 2)
            warning('With two output arguments, the input argument normalized is ignored.');
        else
            assert(islogical(normalized), 'normalized must be true or false');
        end
    end

    histogram(1:256) = 0;
    for i = [0:255]
        histogram(i + 1) = sum(sum(img == i));
    end

    if (nargout ~= 2) && (nargin == 2) && normalized
        [rows cols] = size(img);
        histogram = double(histogram) ./ (rows * cols);
    else if nargout == 2
        [rows cols] = size(img);
        norm_histogram = double(histogram) ./ (rows * cols);
    end
end

