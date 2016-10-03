% Brendan Robeson
% CS 6680
% Assignment 3

function output_image = Destreak(image)
    normalized = im2double(image);
    negated = 1.0 - normalized;
    med = medfilt2(negated, [7 7]);
    diff = negated - med;
    avg = imfilter(diff, [1 2 1; 2 4 2; 1 2 1]);
    m = min(avg(:));
    M = max(avg(:));
    avg = (avg - m) / (M - m);
    thresholded = double(avg > 0.5 * max(avg(:)));
    output_image = 1.0 - thresholded;

    figure;
    rows = 3;
    cols = 3;
    subplot(rows, cols, 1);
    imshow(image);
    title('Original image');
    subplot(rows, cols, 2);
    imshow(negated);
    title('Negated image');
    subplot(rows, cols, 3);
    imshow(med);
    title('Median image');
    subplot(rows, cols, 4);
    imshow(diff);
    title('Difference image');
    subplot(rows, cols, 5);
    imshow(avg);
    title('Average');
    subplot(rows, cols, 6);
    imshow(thresholded);
    title('Thresholded image');
    subplot(rows, cols, 8);
    imshow(output_image);
    title('Output image');
end
