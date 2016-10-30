% Brendan Robeson
% CS 6680
% Assignment 5

function [labelIm, num] = FindComponentLabels(im, se)
    labelIm = zeros(size(im), 'uint8');
    num = 0;

    % loop while there are still components in the input image. each iteration
    % of the loop will remove a component from the image, working toward an
    % empty image.
    while sum(im(:)) ~= 0
        Xk_1 = zeros(size(im), 'logical');
        Xk = Xk_1;
        idx = find(im, 1);
        Xk(idx(1)) = 1;
        while ~isequal(Xk, Xk_1)
            Xk_1 = Xk;
            Xk = imdilate(Xk_1, se) & im;
        end

        % only increment the count, and apply a label, if a component was found
        if (any(Xk(:)))
            num = num + 1;
            labelIm = labelIm + uint8(Xk .* num);

            % remove the found component from the input image. we don't want to
            % find it again
            im = ~Xk & im;
        end
    end
end
