function [merged_keypoints, n] = uav_merge_keypoints(key_points, t_distance) % {{{
    % UAV_MERGE_KEYPOINTS   merge car key points found in UAV imagery
    %   merged_keypoints      = UAV_MERGE_KEYPOINTS(key_points, t_distance)
    %   [merged_keypoints, n] = UAV_MERGE_KEYPOINTS(key_points, t_distance)
    %
    %   key_points          The set of car key_points to merge. This should be a
    %                       2D matrix. Each column is a key point. Each key
    %                       point consists of four rows: X, Y, S, and θ.
    %   t_distance          The threshold distance for merging key points.
    %                       Points closer than this distance are merged. This
    %                       value should be expressed in pixel units.
    %   merged_keypoints    The set of key points remaining after the merge
    %                       operation.
    %   n                   The number of key points after the merging operation
    %                       is complete.
    %
    %   This function will merge key points in close proximity into a single key
    %   point. This produces one key point per car. Note that any original key
    %   points which do not get merged are considered classification outliers;
    %   they have no other key points in close proximity. Such key points are
    %   excluded from the returned merged_keypoints.

    assert(ndims(key_points) == 2,   'key_points must be a 2D matrix');
    assert(size(key_points, 1) == 4, 'key_points must have four rows');

    % append the m parameter to each key point, initialized to 1
    key_points(5, :) = 1;

    % set a value to tombstone certain distances
    tombstone = realmax;

    % create the initial NxN matrix of euclidian distances
    % the distance from key point A to key point B is the same as the distance
    % from key point B to key point A. thus, for two matrix entries, only one
    % distance need be calculated. further, the distance between point A and
    % point A need not be calculated. thus, point A, only the distance with the
    % points following A need to be calculated.
    N = size(key_points, 2);
    distances = eye(N, N) .* tombstone;
    for n1 = 1:N
        for n2 = (n1+1):N
            d = uav_distance(key_points(:, n1), key_points(:, n2));
            distances(n1, n2) = d;
            distances(n2, n1) = d;
        end
    end

    % find the minimum distance, used to merge those two points
    d_min = min(distances(:));
    while d_min < t_distance
        % determine two points with the minimum distance, and merge the points
        [rows, cols] = find(distances == d_min);
        i = min([rows(1) cols(1)]);
        j = max([rows(1) cols(1)]);
        p = uav_merge(key_points(:, i), key_points(:, j));

        % replace key point i with the new key point, then remove key point j
        key_points(:, i) = p;
        key_points(:, j) = [];

        % key point j no longer exists, thus its distances are meaningless.
        % remove the corresponding row & colun from the distance matrix.
        distances(:, j) = [];
        distances(j, :) = [];

        % for each other point, calculate the distance to the new point i, and
        % fill both locations in the matrix
        for k = 1:i-1
            d = uav_distance(p, key_points(:, k));
            distances(k, i) = d;
            distances(i, k) = d;
        end
        for k = i+1:size(key_points, 2)
            d = uav_distance(p, key_points(:, k));
            distances(k, i) = d;
            distances(i, k) = d;
        end
        distances(i,i) = tombstone; % tombstone the distance from i to itself

        % find the new minimum distance
        d_min = min(distances(:));
    end

    % get the columns which have m == 1. then remove all those columns
    to_delete = find(key_points(5, :) == 1);
    key_points(:, to_delete) = [];
    merged_keypoints = key_points;

    % add the output count if requested
    if nargout == 2
        n = size(merged_keypoints, 2);
    end
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
