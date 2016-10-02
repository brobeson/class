% Brendan Robeson
% CS 6680
% Assignment 3

function edgeHist = CalEdgeHist(im, bin)
%   CALEDGEHIST     Calculate a histogram of edge direction for an image.
%
%       im      The input image. This should be of class uint8.
%       bin     The number of bins for the histogram.
%
%       edgeHist    The resulting histogram. The bins are evenly spaced in the
%                   range [0, 360] degrees.

% verify the input
assert(isa(im, 'uint8') ~= 0, 'input image must be of type uint8, not %s', class(im));
assert(isscalar(bin), 'the number of bins must be a scalar');
assert(0 < bin, 'the number of bins must be positive');

% calculate the X and Y gradients
normalized_image = im2double(im);
Gx = [ -1 -2 -1;
        0  0  0;
        1  2  1 ];
Gy = Gx';
Fx = imfilter(normalized_image, Gx, 'replicate');
Fy = imfilter(normalized_image, Gy, 'replicate');

% create the histogram
edgeHist = zeros(1, bin, 'uint32');
bin_size = 360 / bin;
for r = 1:size(im, 1)
    for c = 1:size(im, 2)
        theta = atan2d(Fx(r,c), Fy(r,c));

        % transform angles on [-180, 0] to [180, 360].
        if (theta <= 0)
            theta = 360 + theta;
        end

        % increment the histogram
        b = uint8(ceil(theta / bin_size));
        edgeHist(b) = edgeHist(b) + 1;
    end
end
end
