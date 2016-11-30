clear all
clc;

fprintf('running key point merge unit test\n');

% test 1 - all three points should merge into one
key_points_1 = [ 1 2 3;
                 1 1 1;
                 0 0 0;
                 0 0 0 ];
expected_merged_1 = [ 1.875; 1; 0; 0; 5 ];
merged_1 = uav_merge_keypoints(key_points_1, 3);
if isequal(merged_1, expected_merged_1)
    fprintf(1, 'for test 1, merge results are correct\n');
else
    error('for test 1, merge results are incorrect\n');
end

% test 2 - four points should merge into two, and one outlier should be removed
key_points_2 = [ 1 2 9 10 20;
                 1 1 1  1  1;
                 0 0 0  0  0;
                 0 0 0  0  0 ];
expected_merged_2 = [ 1.5  9.5;
                      1    1;
                      0    0;
                      0    0;
                      3    3 ];
merged_2 = uav_merge_keypoints(key_points_2, 3);
if isequal(merged_2, expected_merged_2)
    fprintf(1, 'for test 2, merge results are correct\n');
else
    error('for test 2, merge results are incorrect\n');
end
