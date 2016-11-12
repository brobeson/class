function watermark = ExtractWatermark(img, beta)
[C, S] = wavedec2(img, 3, 'db9');

% extract the approximation coefficients
H = reshape(C(1:S(1) * S(1, 2)), S(1), S(1, 2));

watermark = zeros(1, S(1) * S(1,2), 'logical');
half_beta = 0.5 * beta;
b = 1;
for r = 1:S(1)
    for c = 1:S(1,2)
        watermark(b) = half_beta < mod(H(r,c), beta);
        b = b + 1;
    end
end

end
