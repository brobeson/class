function Hist = CalNormalizedHSVHist(Im, HbinNum, SbinNum, VbinNum)
Hist = zeros(1, HbinNum * SbinNum * VbinNum, 'double');

% convert the RGB image to HSV
hsv = rgb2hsv(Im);

% determine the range of each bin for each channel
ranges = [ 1.0 / HbinNum, 1.0 / SbinNum, 1.0 / VbinNum ];

% calculate the bin to which each value belongs
bins = zeros(size(hsv), 'uint32');
bins(:,:,1) = uint32(ceil(hsv(:,:,1) ./ ranges(1)));
bins(:,:,2) = uint32(ceil(hsv(:,:,2) ./ ranges(2)));
bins(:,:,3) = uint32(ceil(hsv(:,:,3) ./ ranges(3)));

bin = 1;
for h = 1:HbinNum
    hue = bins(:,:,1) == h;
    for s = 1:SbinNum
        saturation = bins(:,:,2) == s;
        for v = 1:VbinNum
            value = bins(:,:,3) == v;
            permutation = value & saturation & hue;
            Hist(bin) = sum(sum(permutation));
            bin = bin + 1;
        end
    end
end

% convert from histogram to normalized histogram
Hist = Hist ./ (size(hsv, 1) * size(hsv, 2));

end
