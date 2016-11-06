function QueryImages(figure_number, source_image, source_histogram, image_db, histogram_db)

assert(isa(image_db, 'cell'), 'image_db must be a cell array containing images');
assert(isa(histogram_db, 'cell'), 'histogram_db must be a cell array containing histograms');

% calculate the number of pixels in the source image, and convert the normalized
% histogram to a histogram.
num_h = size(source_image, 1) * size(source_image, 2);
h = source_histogram .* num_h;

d = zeros(size(histogram_db));
for c = 1:size(histogram_db, 2)
    % calculate the number of pixels in the current DB image, and convert the normalized
    % histogram to a histogram.
    num_g = size(image_db{c}, 1) * size(image_db{c}, 2);
    g = histogram_db{c}  .* num_g;

    % sum the minimum values of the histogram bins
    for bin = 1:size(h, 2)
        d(c) = d(c) +  min([h(bin), g(bin)]);
    end

    % scale by the inverse of the smaller pixel count
    d(c) = d(c) / min([num_h, num_g]);
end

% determine the ranking for each calculated d. the number of entries equal to or
% greater than the current entry is the rank
ranks = zeros(size(d));
for i = 1:size(d, 2)
    ranks(i) = sum(d >= d(i));
end

figure(figure_number);
subplot(2, 3, 1);
imshow(source_image);
title('Source image');

subplot(2, 3, 2);
imshow(image_db{1});
title(sprintf('rank %d (similarity = %.3f)', ranks(1), d(1)));

subplot(2, 3, 3);
imshow(image_db{2});
title(sprintf('rank %d (similarity = %.3f)', ranks(2), d(2)));

subplot(2, 3, 5);
imshow(image_db{3});
title(sprintf('rank %d (similarity = %.3f)', ranks(3), d(3)));

subplot(2, 3, 6);
imshow(image_db{4});
title(sprintf('rank %d (similarity = %.3f)', ranks(4), d(4)));

end
