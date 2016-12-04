clc
clear all
close all

% load the truth data and extract the column of true car counts
truth_data = readtable('true_counts_small.txt', 'ReadRowNames', true);
truth_data = sortrows(truth_data, 'RowNames');
true_counts = truth_data.counts;

% run the car counter on a set of images
image_files = { 'small_img.png' 'small_img2.png' };
svm_files = { 'uav_asphalt_svm.mat' 'uav_keypoint_svm.mat' };
[counts, run_times] = uav_car_counter(image_files, svm_files, 'intermediate_figures', 1);

% separate the run times into distinct variables. not sure why, but assigning a
% matrix to the table doesn't work right.
asphalt_time   = [ run_times(:, 1) ...
                   round(run_times(:, 1) ./ run_times(:, 6) .* 100) ];
key_point_time = [ run_times(:, 2) ...
                   round(run_times(:, 2) ./ run_times(:, 6) .* 100) ];
classify_time  = [ run_times(:, 3) ...
                   round(run_times(:, 3) ./ run_times(:, 6) .* 100) ];
removal_time   = [ run_times(:, 4) ...
                   round(run_times(:, 4) ./ run_times(:, 6) .* 100) ];
merge_time     = [ run_times(:, 5) ...
                   round(run_times(:, 5) ./ run_times(:, 6) .* 100) ];
total_time     = run_times(:, 6);

% put the data into a table
count_table = table(counts);
count_table.Properties.RowNames = image_files;
count_table = sortrows(count_table, 'RowNames');
count_table.true_counts = true_counts;
count_table.accuracy = (count_table.counts ./ count_table.true_counts) .* 100;
count_table
writetable(count_table, 'demo_counts.txt', 'WriteRowNames', true);

times_table = table(asphalt_time, key_point_time, classify_time, removal_time, merge_time, total_time);
times_table.Properties.RowNames = image_files;
times_table.Properties.VariableUnits = { 'seconds %' 'seconds %' 'seconds %' 'seconds %' 'seconds %' 'seconds' };
times_table = sortrows(times_table, 'RowNames');
times_table
writetable(times_table, 'demo_times.txt', 'WriteRowNames', true);
