function merged_keypoints = uav_merge_keypoints(key_points, t_distance) % {{{
    % UAV_MERGE_KEYPOINTS   merge car key points found in UAV imagery
    %   merged_keypoints = uav_merge_keypoints(key_points)
    %
    %   key_points          The set of car key_points to merge. This should be a
    %                       2D matrix. Each column is a key point. Each key
    %                       point consists of four rows: X, Y, S, and θ.
    %   t_distance          The threshold distance for merging key points.
    %                       Points closer than this distance are merged. This
    %                       value should be expressed in pixel units.
    %   merged_keypoints    The set of key points remaining after the merge
    %                       operation.
    %
    %   This function will merge key points in close proximity into a single key
    %   point. This produces one key point per car.

    assert(ndims(key_points) == 2,   'key_points must be a 2D matrix');
    assert(size(key_points, 1) == 4, 'key_points must have four rows');

    % append the m parameter to each key point, initialized to 1
    key_points(5, :) = 1;

    % create the initial NxN matrix of euclidian distances
    % the distance from key point A to key point B is the same as the distance
    % from key point B to key point A. thus, for two matrix entries, only one
    % distance need be calculated. further, the distance between point A and
    % point A need not be calculated. thus, point A, only the distance with the
    % points following A need to be calculated.
    N = size(key_points, 2);
    distances = eye(N, N) .* realmax;
    distances = zeros(N, N);
    for n1 = 1:N
        x1 = key_points(1, n1);
        y1 = key_points(2, n1);

        for n2 = (n1+1):N
            x2 = key_points(1, n2);
            y2 = key_points(2, n2);
            d = sqrt((x1 - x2)^2 + (y1 - y2)^2);

            distances(n1, n2) = d;
            distances(n2, n1) = d;
        end
    end

    % find the two key points with the smallest distance
    d_min = min(distances(:));
    if d_min < t_distance
        [rows, cols] = find(distances == d_min);
        if ~isempty(rows)
            r = rows(1)
            c = cols(1)
            p = uav_merge(key_points(:, r), key_points(:, c));
            %merged_keypoints(:, 1) = key_points(:, r);
            %merged_keypoints(:, 2) = key_points(:, c);
            %merged_keypoints(:, 3) = p;
            %return

            % remove the two merged key points, and append the new key_point
            key_points(:, r) = [];
            key_points(:, c) = [];
            key_points(:, size(key_points, 2) + 1) = p;
            %merged_keypoints = key_points;
            %return;

            % the two merged key points no longer exist, thus their distances
            % are meaningless. for both points, remove the corresponding row &
            % column from the distance matrix.
            distances(:, r) = [];
            distances(:, c) = [];
            distances(r, :) = [];
            distances(c, :) = [];

            % add a row & column for the new point
            distances(:, size(distances, 2) + 1) = zeros(size(distances, 1), 1);
            distances(size(distances, 1) + 1, :) = zeros(1, size(distances, 2));

            % for each other point, calculate the distance to the new point, and
            % fill both locations in the matrix
            x1 = p(1);
            y1 = p(2);
            for k = 1:size(key_points, 2) - 1
                x2 = key_points(1, k);
                y2 = key_points(2, k);
                d = sqrt((x1 - x2)^2 + (y1 - y2)^2);
                distances(k, size(distances, 2)) = d;
                distances(size(distances, 1), k) = d;
            end
            merged_keypoints = distances;
            return
        end
    end

    merged_keypoints = p;
end % }}}

function p = uav_merge(p1, p2) % {{{
    % UAV_MERGE     merge two car key points into one key point
    %   p = UAV_MERGE(p1, p2)
    %
    %   p1,p2   The two key points to merge. Each should be a 5x1 matrix with
    %           the form [x; y; s; θ; m].
    %   p       The result of merging p1 and p2.
    %
    %   Two points are merged by performing a weighted average, using the
    %   points' m values as the weights:
    %               p1(n)*p1(5) + p2(n)*p2(5)
    %       p(n) = ---------------------------
    %                     p1(5) + p2(5)
    %   The weights are combined by adding them, then incrementing:
    %       p(5) = p1(5) + p2(5) + 1

    assert(size(p1, 1) == 5, 'p1 must have five rows');
    assert(size(p1, 2) == 1, 'p1 must have one column');
    assert(size(p2, 1) == 5, 'p2 must have five rows');
    assert(size(p2, 2) == 1, 'p2 must have one column');

    p = zeros(5, 1);
    p(1:4) = (p1(1:4) .* p1(5) + p2(1:4) .* p2(5)) ./ (p1(5) + p2(5));
    p(5) = p1(5) + p2(5) + 1;
end % }}}

function d = uav_distance(p1, p2) % {{{
    % UAV_DISTANCE      calculate the distance between two key points
    %   d = UAV_DISTANCE(p1, p2)
    %
    %   p1,p2   The two key points for which to calculate the distance. Each
    %           should be a column vector with at least two rows. The first row
    %           should be the X coordinate, and the second row should be the Y
    %           coordinate.
    %   d       The Euclidian distance between the two points.

    assert(size(p1, 1) >= 2, 'p1 must have at least two rows');
    assert(size(p1, 2) == 1, 'p1 must have one column');
    assert(size(p2, 1) >= 2, 'p2 must have at least two rows');
    assert(size(p2, 2) == 1, 'p2 must have one column');

    d = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2);
end % }}}
