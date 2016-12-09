function [d1, d2, c] = cluster(c1, c2, p)
    d1 = distance(c1, p);
    d2 = distance(c2, p);

    if d1 <= d2
        c = 1;
    else
        c = 2;
    end
end
