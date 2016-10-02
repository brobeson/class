% Brendan Robeson
% CS 6680
% Assignment 3

function output_image = Destreak(image)
normalized = im2double(image);
negated = 1.0 - normalized;
thresholded = double(negated > 0.7 * max(negated(:)));
output_image = 1.0 - thresholded;

figure
rows = 2;
cols = 3;
subplot(rows, cols, 1)
imshow(image);
title('Original image');
subplot(rows, cols, 2)
imshow(negated);
title('Negated image');
subplot(rows, cols, 3)
imshow(thresholded);
title('Thresholded image');
subplot(rows, cols, 4)
imshow(output_image);
title('Output image');
subplot(rows, cols, 5)
imshow(output_image - normalized);
title('Diff');
end
