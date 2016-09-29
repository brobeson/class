% Brendan Robeson
% CS 6680
% Assignment 3

function [filteredIm] = AverageFiltering(im, mask)
%   AVERAGEFILTERING    Filter an image by averaging using the supplied filter mask.
%
%       im      The input image. This should be of class uint8.
%       mask    The filter mask. This must be a square mask, with an odd number
%               of rows, and symmetric about the center.
%
%       filteredIm  The output image. This will be of class uint8

% verify the input
assert(isa(im, 'uint8') ~= 0, 'input image must be of type uint8, not %s', class(im));
assert(issquare(mask), 'the filter mask must be square');
assert(mod(size(mask, 1), 2) ~= 0, 'the filter mask must have an odd number of rows');

% verify that the mask is symmetrical
mask_size = size(mask, 1);
half_size = uint8(mask_size / 2);
for r = 1:half_size
    for c = 1:mask_size
        assert(mask(r, c) == mask(mask_size - r + 1, mask_size - c + 1), 'the filter mask must be symmetric around the center');
    end
end

% compute the amount by which to pad the image. also compute the start and end
% indices for the actual image rows and columns within the padded image
pad_amount = floor(mask_size / 2);
image_size = size(im);
r0 = 1 + pad_amount;
rN = image_size(1) + pad_amount;
c0 = r0;
cN = image_size(2) + pad_amount;

% create a padded image of 0s, then fill the center area with the source image
padded = zeros(image_size + (2 * pad_amount), class(im));
padded(r0:rN, c0:cN) = im(1:image_size(1), 1:image_size(2));

% apply the average filter, using the supplied mask
filteredIm = zeros(image_size, 'uint8');
for r = 1:image_size(1)
    % r0 is the initial row in the padded image, rN is the last row in the
    % padded image FOR APPLICATION OF THE MASK. thus,
    % rN - r0 + 1 = size(mask, 1). accessing the padded image, and destination
    % image, use the same r0: writing to filteredIm row 1 requires reading from
    % padded at rows 1 through the mask height. the same concept applies to the
    % columns.
    r0 = r;
    rN = r0 + 2 * pad_amount;
    for c = 1:image_size(2)
        c0 = c;
        cN = c0 + 2 * pad_amount;
        filteredIm(r, c) = sum(sum(mask .* padded(r0:rN, c0:cN)));
    end
end

end
