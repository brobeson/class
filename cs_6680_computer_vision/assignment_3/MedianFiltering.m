% Brendan Robeson
% CS 6680
% Assignment 3

function [filteredIm] = MedianFiltering(im, mask)
%   AVERAGEFILTERING    Filter an image by averaging using the supplied filter mask.
%
%       im      The input image. This should be of class uint8.
%       mask    The filter mask. This must be a square mask, with an odd number
%               of rows, and symmetric about the center.
%
%       filteredIm  The output image. This will be of class uint8

% verify the input
assert(isa(im, 'uint8') ~= 0, 'input image must be of type uint8, not %s', class(im));
assert(size(mask, 1) == size(mask, 2), 'the filter mask must be square');
assert(mod(size(mask, 1), 2) ~= 0, 'the filter mask must have an odd number of rows');

% compute the amount by which to pad the image. also compute the start and end
% indices for the actual image rows and columns within the padded image
mask_size = size(mask, 1);
pad_amount = floor(mask_size / 2);
image_size = size(im);
r0 = 1 + pad_amount;
rN = image_size(1) + pad_amount;
c0 = r0;
cN = image_size(2) + pad_amount;

% create a padded image of 0s, then fill the center area with the source image
padded = zeros(image_size + (2 * pad_amount), class(im));
padded(r0:rN, c0:cN) = im(1:image_size(1), 1:image_size(2));

% allocate a vector to hold the image values selected via the mask. we know that
% the vector will have a number of elements equal to the sum of the mask values.
% for example, the weighted mask [ 1 2 1; 2 4 2; 1 2 1] will extract 16 pixels
% from the image
vector_size = sum(mask(:));
vec = zeros(1, vector_size);

% apply the average filter, using the supplied mask
filteredIm = zeros(image_size, 'uint8');
for r = 1:image_size(1)
    for c = 1:image_size(2)
        submatrix = padded(r:r + mask_size - 1, c:c + mask_size - 1);
        v = submatrix(:);
        filteredIm(r, c) = median(repelem(v, mask(:))');
    end
end

end
