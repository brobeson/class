function [N, run_times] = uav_car_counter(img_files) % {{{
    % UAV_CAR_COUNTER   count the number of cars in an imagery set
    %   [N, run_times] = UAV_CAR_COUNTER(img_files)
    %
    %   img_files   The list of file names for the images to run through the car
    %               counting algorithm. This should be a cell array of character
    %               arrays.
    %   N           A vector of car counts. Each element is the car count for
    %               the corresponding element in img_files.
    %   run_times   A vector of run times. Each element is the total run time
    %               for the corresponding element in img_files. The run times
    %               are measured in seconds.
    %
    %   This function will run each image in img_files through the UAV car
    %   counting algorithm. It will return various data about the algorithm
    %   execution.

    % if the asphalt SVM has already been trained, just load it. otherwise, train it. {{{
    asphalt_svm_filename = 'uav_asphalt_svm.mat';
    if exist(asphalt_svm_filename, 'file') == 2
        svm_struct = load('uav_asphalt_svm.mat');
        asphalt_svm = svm_struct.svm;
        assert(isa(asphalt_svm, 'ClassificationSVM'), 'loaded SVM is not really an SVM');
    else
        asphalt_svm = uav_asphalt_trainer(imread('trainer.jpg'), asphalt_svm_filename);
    end
    % }}}

    % if the keypoint SVM has already been trained, just load it. otherwise, train it. {{{
    keypoint_svm_filename = 'uav_keypoint_svm.mat';
    if exist(keypoint_svm_filename, 'file') == 2
        svm_struct = load('uav_keypoint_svm.mat');
        keypoint_svm = svm_struct.svm;
        assert(isa(keypoint_svm, 'ClassificationSVM'), 'loaded SVM is not really an SVM');
    else
        keypoint_svm = uav_trainer(imread('trainer.jpg'), keypoint_svm_filename);
    end
    % }}}

    % form the output variables
    run_times = zeros(length(img_files), 1);
    N = zeros(length(img_files), 1);

    % load the image to count {{{
    for f = 1:length(img_files)
        [N(f), run_times(f)] = uav_count_cars(imread(char(img_files(f))), asphalt_svm, keypoint_svm, 0);
    end

    % }}}
end
% }}}

function [n, t] = uav_count_cars(img, asphalt_svm, keypoint_svm, verbose) % {{{
    fig = 1; % semi-auto incrementing figure number
    tic
    % extract the asphalt segments {{{
    if verbose ~= 0
        log_message('extracting asphalt');
    end

    % the SE radii are adapted from the paper. the numerators are in cm, and the
    % divisors are the image resolution. thus, the radii are in pixels, based on
    % real world distances.
    asphalt = uav_find_asphalt(img, asphalt_svm, ceil(30 / 4), ceil(300 / 4));

    % draw the asphalt mask {{{
    if verbose ~= 0
        warning off all % tired of seeing warnings about the image being too large
        figure(1);
        subplot(2, 2, 1);
        imshow(asphalt);

        masked_img = img;
        for r=1:size(masked_img, 1)
            for c=1:size(masked_img, 2)
                if asphalt(r,c) == 0
                    masked_img(r,c,:) = 0;
                end
            end
        end
        %img(:, :, 1) = img(:, :, 1) & asphalt;
        %img(:, :, 2) = img(:, :, 2) & asphalt;
        %img(:, :, 3) = img(:, :, 3) & asphalt;
        subplot(2, 2, 2);
        imshow(masked_img);

        masked_img = img;
        for r=1:size(masked_img, 1)
            for c=1:size(masked_img, 2)
                if asphalt(r,c) == 1
                    masked_img(r,c,:) = 0;
                end
            end
        end
        subplot(2, 2, 4);
        imshow(masked_img);
        warning on all
    end
    % }}}
    % }}}

    % extract key points from the test image {{{
    if verbose ~= 0
        log_message('extracting key points. this typically takes around 30 seconds');
    end
    [frames, descriptors] = uav_sift(img);

    % draw the image with key points {{{
    if verbose ~= 0
        warning off all % tired of seeing warnings about the image being too large
        figure(fig);
        fig = fig + 1;
        imshow(img);
        hold on
        plot(frames(1,:), frames(2,:), 'r.');
        hold off
        warning on all
    end
    % }}}
    % }}}

    % classify the key points {{{
    if verbose ~= 0
        log_message('classifying the key points');
    end
    classes = predict(keypoint_svm, descriptors');

    % only keep the points corresponding to class 1. also, at this point, the
    % descriptors are no longer needed, only the frames.
    if verbose ~= 0
        log_message('discarding background key points');
    end
    f = 1;
    for c = 1:size(classes, 1)
        if classes(c) == 1
            car_frames(1:4, f) = frames(1:4, c);
            f = f + 1;
        end
    end

    % draw the image with car key points {{{
    if verbose ~= 0
        warning off all % tired of seeing warnings about the image being too large
        figure(fig);
        fig = fig + 1;
        imshow(img);
        hold on
        plot(car_frames(1,:), car_frames(2,:), 'r.');
        hold off
        warning on all
    end
    % }}}
    % }}}

    % remove key points which are not in asphalt {{{
    if verbose ~= 0
        log_message('removing key points from non-asphalt areas');
    end
    ff = 1;
    for f = 1:size(car_frames, 2)
        x = round(car_frames(1, f));
        y = round(car_frames(2, f));

        if (asphalt(y, x) == 1)
            asphalt_car_frames(:, ff) = car_frames(:, f);
            ff = ff + 1;
        end
    end

    % draw the image with asphalt car key points {{{
    if verbose ~= 0
        warning off all % tired of seeing warnings about the image being too large
        figure(fig);
        fig = fig + 1;
        imshow(img);
        hold on
        plot(asphalt_car_frames(1,:), asphalt_car_frames(2,:), 'r.');
        hold off
        warning on all
    end
    % }}}
    % }}}

    % merge the key points {{{
    if verbose ~= 0
        log_message('merging key points');
    end

    % this is for 4cm/pixel imagery. assuming the average car is 360 cm long, use
    % 360/4 == 90 pixels for the threshold distance.
    [asphalt_car_frames, n] = uav_merge_keypoints(asphalt_car_frames, 90);

    % draw the image with merged asphalt car key points {{{
    if verbose ~= 0
        warning off all % tired of seeing warnings about the image being too large
        figure(fig);
        fig = fig + 1;
        imshow(img);
        hold on
        plot(asphalt_car_frames(1,:), asphalt_car_frames(2,:), 'r.');
        hold off
        warning on all
    end
    % }}}
    % }}}
    t = toc;
end
% }}}
