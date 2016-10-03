% Brendan Robeson
% CS 6680
% Assignment 3

function output_image = Destreak(image)
    normalized = im2double(image);
    negated = 1.0 - normalized;
    med = medfilt2(negated, [7 7]);
    diff = negated - med;
    %med2 = medfilt2(diff, [5 5]);
    %diff2 = diff - med2;
    output_image = 1.0 - diff;

    figure;
    rows = 2;
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
    %subplot(rows, cols, 5);
    %imshow(med2);
    %title('2nd median image');
    %subplot(rows, cols, 6);
    %imshow(diff2);
    %title('2nd difference image');
    subplot(rows, cols, 6);
    imshow(output_image);
    title('Output image');
end
