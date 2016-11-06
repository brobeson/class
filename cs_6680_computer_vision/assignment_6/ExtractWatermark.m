function watermark = ExtractWatermark(img, beta)
[C, S] = wavedec2(img, 3, 'db9');

% extract the approximation coefficients
H = reshape(C(1:S(1) * S(1, 2)), S(1), S(1, 2));

beta_5  = 0.5  * beta;
watermark = reshape(beta_5 < mod(H, beta), 1, S(1) * S(1, 2));
end
