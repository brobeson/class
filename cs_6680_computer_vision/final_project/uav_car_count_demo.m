% load the truth data and extract the column of true car counts
truth_data = readtable('true_counts_small.txt', 'ReadRowNames', true);
truth_data = sortrows(truth_data, 'RowNames');
true_counts = truth_data.counts;

% run the car counter on a set of images
%image_files = { 'small_img.png' 'small_img2.png' };
image_files = { 'small_img2.png' 'small_img.png' };
[counts, run_times] = uav_car_counter(image_files);

% put the data into a table
data_table = table(counts, run_times);
data_table.Properties.RowNames = image_files;
data_table = sortrows(data_table, 'RowNames');
data_table.true_counts = true_counts;
data_table.accuracy = (data_table.counts ./ data_table.true_counts) .* 100;
%for r = 1:length(data_table.accuracy)
%    if data_table.accuracy(r) > 1
%        data_table.accuracy(r) = 1 / data_table.accuracy(r);
%    end
%end
data_table = data_table(:, [1 3 4 2]);
data_table
writetable(data_table, 'demo.txt', 'WriteRowNames', true);

