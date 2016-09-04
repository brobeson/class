function [blurredIm] = BlurImage(oriIm)
% BLURIMAGE Blur an image by setting 4x4 pixel blocks to the average of the
% block.
%   [blurredIm] = BlurImage(oriIm)

% implementation 1
blurredIm = oriIm;
[rows cols] = size(blurredIm);
for r = 1:4:rows
    for c = 1:4:cols
        blurredIm(r:r + 3, c:c + 3) = mean(blurredIm(r:r + 3, c:c + 3)(:));
    end
end

% implementation 2
% this does not work on octave, try matlab
fun = @(block_struct) uint8(mean2(block_struct.data) * ones(size(block_struct.data)));
blurredIm = blockproc(oriIm, [4 4], fun);
end
