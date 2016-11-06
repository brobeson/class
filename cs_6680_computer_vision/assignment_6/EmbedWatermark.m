function [marked_image, watermark] = EmbedWatermark(img, beta)
[C, S] = wavedec2(img, 3, 'db9');

% save the current random engine state, then reset the engine to default. this
% ensures the subsequent call to randi() always produces the same result. then
% restore the original engine state, in case the user needs it for subsequent
% operations.
original_engine = rng;
rng('default');
b = logical(randi([0, 1], [1, S(1) * S(1, 2)]));
rng(original_engine);

% extract the approximation coefficients
H = reshape(C(1:S(1) * S(1, 2)), S(1), S(1, 2));

% prep some values that need to be initialized prior to looping, or which remain
% constant for all iterations.
k = 1;
H_mod_beta = mod(H, beta);
beta_25 = 0.25 * beta;
beta_75 = 0.75 * beta;
beta_5  = 0.5  * beta;

% given: beta 𝛽,
%        approximation coefficients H,
% for each approximation coefficient H(i,j)...
%             / H(i,j) - H(i,j)%𝛽 + 0.75𝛽                     b(k)=1 and H(i,j)%𝛽 ≥ 0.25𝛽
%   H(i,j) = /  H(i,j) - 0.25𝛽 - [H(i,j) - 0.25𝛽]%𝛽 + 0.75𝛽   b(k)=1 and H(i,j)%𝛽 < 0.25𝛽
%            \  H(i,j) - H(i,j)%𝛽 + 0.25𝛽                     b(k)=0 and H(i,j)%𝛽 ≤ 0.75𝛽
%             \ H(i,j) + 0.5𝛽 - [H(i,j) - 0.5𝛽]%𝛽 + 0.25𝛽     b(k)=0 and H(i,j)%𝛽 > 0.75𝛽
for i = 1:S(1)
    for j = 1:S(1, 2)
        if b(k) == 1
            if H_mod_beta(i,j) < beta_25
                H(i,j) = (H(i,j) - beta_25) - mod(H(i,j) - beta_25, beta) + beta_75;
            else
                H(i,j) = H(i,j) - H_mod_beta(i,j) + beta_75;
            end
        else
            if beta_75 < H_mod_beta(i,j)
                H(i,j) = H(i,j) + beta_5 - mod(H(i,j) - beta_5, beta) + beta_25;
            else
                H(i,j) = H(i,j) - H_mod_beta(i,j) + beta_25;
            end
        end
        k = k + 1;
    end
end

C(1:S(1) * S(1, 2)) = H(:);
marked_image = uint8(waverec2(C, S, 'db9'));
watermark = logical(b);
end
