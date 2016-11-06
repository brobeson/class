function Hist = CalNormalizedHSVHist(Im, HbinNum, SbinNum, VbinNum)
Hist = zeros(1, HbinNum * SbinNum * VbinNum, 'uint32');

% convert the RGB image to HSV
hsv = rgb2hsv(Im);

% determine the range of each bin for each channel
ranges = [ 1.0 / HbinNum, 1.0 / SbinNum, 1.0 / VbinNum ];

% calculate the bin to which each value belongs
bins = zeros(size(hsv), 'uint32');
bins(:,:,1) = hsv(:,:,1) ./ ranges(1);
bins(:,:,2) = hsv(:,:,2) ./ ranges(2);
bins(:,:,3) = hsv(:,:,3) ./ ranges(3);

% fill in the hue portion of the histogram
for h = 1:HbinNum
    Hist(h) = sum(sum(bins(:,:,1) == h));
end

% fill in the saturation portion of the histogram
for s = 1:SbinNum
    Hist(HbinNum + s) = sum(sum(bins(:,:,2) == s));
end

% fill in the value portion of the histogram
for v = 1:VbinNum
    Hist(HbinNum + SbinNum + v) = sum(sum(bins(:,:,3) == v));
end

% convert from histogram to normalized histogram
Hist = Hist ./ size(hsv, 1) * size(hsv, 2);

end
