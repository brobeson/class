function [blurredIm] = BlurImage(oriIm)
% BLURIMAGE Blur an image by setting 4x4 pixel blocks to the average of the
% block.
%   [blurredIm] = BlurImage(oriIm)

% interesting...
% i experimented with blockproc(), and it was significantly slower than these
% loops

blurredIm = oriIm;
[rows cols] = size(blurredIm);
for r = 1:4:rows
    for c = 1:4:cols
        blurredIm(r:r + 3, c:c + 3) = mean(blurredIm(r:r + 3, c:c + 3)(:));
    end
end
end
