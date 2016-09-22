% Brendan Robeson
% CS 6680
% Assignment 2

function [histogram, norm_histogram] = CalHist(img, normalized)
    % verify the input and expected output
    assert(isa(img, 'uint8') ~= 0, 'input image must be of type uint8, not %s', class(img));
    assert(nargout <= 2, 'CalHist cannot output more than two arguments.');
    if (nargin >= 2)
        if (nargout == 2)
            warning('With two output arguments, the input argument normalized is ignored.');
        else
            assert(islogical(normalized), 'normalized must be true or false');
        end
    end

    % default class for histogram is double
    histogram = zeros(1, 256);

    % loop through the image. increment the histogram bin corresponding to the
    % intensity. remember that intensity is on [0, 255], but Matlab requires
    % indexing on [1, 256]. so add 1 to the histogram index.
    lngth = size(img, 1) * size(img, 2);
    for i = 1:lngth
        histogram(img(i) + 1) = histogram(img(i) + 1) + 1;
    end

    % this algorithm wins in Octave, but loses in Matlab
    %for i = [0:255]
    %    histogram(i + 1) = sum(sum(img == i));
    %end

    % if the user requested ONLY the normalized histogram, give it to them.
    % otherwise, if the user requested both the histogram and the normalized
    % histogram, give them both.
    if (nargout ~= 2) && (nargin == 2) && normalized
        histogram = histogram ./ lngth;
    elseif nargout == 2
        norm_histogram = histogram ./ lngth;
    end
end

