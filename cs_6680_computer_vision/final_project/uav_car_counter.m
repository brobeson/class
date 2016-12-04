function [N, run_times] = uav_car_counter(img_files, svm_files, varargin) % {{{
    % UAV_CAR_COUNTER   count the number of cars in an imagery set
    %   [N, run_times] = UAV_CAR_COUNTER(img_files, svm_files)
    %
    %   img_files   The list of file names for the images to run through the car
    %               counting algorithm. This should be a cell array of character
    %               arrays.
    %   svm_files   The list of .mat files from which to load the SVMs. This
    %               should be a cell array of character arrays. The first
    %               element should be the asphalt SVM file; the second should be
    %               the key point classification SVM file.
    %   N           A vector of car counts. Each element is the car count for
    %               the corresponding element in img_files.
    %   run_times   A matrix of run times. Each row is a set of run times for
    %               the corresponding element in img_files. Each column
    %               corresponds to the following major steps:
    %                   Asphalt segmentation
    %                   Key point extraction
    %                   Key point classification
    %                   Key point reduction
    %                   Key point merging
    %                   Total run time
    %               The run times are measured in seconds.
    %
    %   UAV_CAR_COUNTER() accepts the following options:
    %       intermediate_figures    uint32
    %           If present, the value should be in the range [1,N] where N is
    %           the length of img_files. This will generate intermediate figures
    %           for each major step of the process, for the corresponding file.
    %           If the value is outside the range, a warning is issued, no
    %           figures are generated, and the process procedes.
    %
    %   This function will run each image in img_files through the UAV car
    %   counting algorithm. It will return various data about the algorithm
    %   execution.

    assert(nargin >= 2, 'two input arguments are required');
    assert(length(img_files) > 0, 'img_files must have at least one element');
    assert(length(svm_files) >= 2, 'svm_files must have at least two elements');
    assert(length(varargin) == 0 || length(varargin) == 2, 'varargin must be 0 or 2 arguments');

    % figure out if the user requested intermediate figures to be generated
    if length(varargin) == 2
        if strcmp(varargin{1}, 'intermediate_figures')
            int_figures = varargin{2};
            if int_figures == 0 || length(img_files) < int_figures
                warning('%d is outside the range of [1,%d] to specify intermediate figures; no figures will be generated', int_figures, length(img_files));
            end
        else
            error('%s is not a valid option', varargin{1});
        end
    else
        int_figures = 0;
    end

    % load the asphalt SVM
    svm_struct = load(char(svm_files(1)));
    asphalt_svm = svm_struct.svm;
    assert(isa(asphalt_svm, 'ClassificationSVM'), 'loaded asphalt SVM is not really an SVM');

    % load the key point classification SVM
    svm_struct = load(char(svm_files(2)));
    keypoint_svm = svm_struct.svm;
    assert(isa(keypoint_svm, 'ClassificationSVM'), 'loaded key point SVM is not really an SVM');

    % form the output variables
    run_times = zeros(length(img_files), 6);
    N = zeros(length(img_files), 1);

    % load the image to count
    for f = 1:length(img_files)
        gen_figures = (f == int_figures);
        [N(f), run_times(f, :)] = uav_count_cars(imread(char(img_files(f))), asphalt_svm, keypoint_svm, gen_figures);
    end
end
% }}}

function [n, t] = uav_count_cars(img, asphalt_svm, keypoint_svm, intermediate_figures) % {{{
    fig = 1; % semi-auto incrementing figure number
    t = zeros(1, 6);
    t_start = tic;

    % extract the asphalt segments {{{
    % the SE radii are adapted from the paper. the numerators are in cm, and the
    % divisors are the image resolution. thus, the radii are in pixels, based on
    % real world distances.
    asphalt = uav_find_asphalt(img, asphalt_svm, ceil(30 / 4), ceil(300 / 4));
    t(1) = toc(t_start);
    % }}}

    % extract key points from the test image {{{
    t_intermediate = tic;
    [frames, descriptors] = uav_sift(img);
    t(2) = toc(t_intermediate);
    % }}}

    % classify the key points {{{
    t_intermediate = tic;
    classes = predict(keypoint_svm, descriptors');

    % only keep the points corresponding to class 1. also, at this point, the
    % descriptors are no longer needed, only the frames.
    f = 1;
    for c = 1:size(classes, 1)
        if classes(c) == 1
            car_frames(1:4, f) = frames(1:4, c);
            f = f + 1;
        end
    end
    t(3) = toc(t_intermediate);
    % }}}

    % remove key points which are not in asphalt {{{
    t_intermediate = tic;
    ff = 1;
    for f = 1:size(car_frames, 2)
        x = round(car_frames(1, f));
        y = round(car_frames(2, f));

        if (asphalt(y, x) == 1)
            asphalt_car_frames(:, ff) = car_frames(:, f);
            ff = ff + 1;
        end
    end
    t(4) = toc(t_intermediate);
    % }}}

    % merge the key points {{{
    % this is for 4cm/pixel imagery. assuming the average car is 360 cm long, use
    % 360/4 == 90 pixels for the threshold distance.
    t_intermediate = tic;
    [asphalt_car_frames, n] = uav_merge_keypoints(asphalt_car_frames, 90);
    t(5) = toc(t_intermediate);
    % }}}

    t(6) = toc(t_start);

    if intermediate_figures % {{{
        warning off all % tired of seeing warnings about the image being too large

        % draw the asphalt mask {{{
        figure(1);
        subplot(1, 3, 1);
        imshow(asphalt);
        title('Asphalt mask');

        masked_img = img;
        for r=1:size(masked_img, 1)
            for c=1:size(masked_img, 2)
                if asphalt(r,c) == 0
                    masked_img(r,c,:) = 0;
                end
            end
        end
        subplot(1, 3, 2);
        imshow(masked_img);
        title('Asphalt segments');

        masked_img = img;
        for r=1:size(masked_img, 1)
            for c=1:size(masked_img, 2)
                if asphalt(r,c) == 1
                    masked_img(r,c,:) = 0;
                end
            end
        end
        subplot(1, 3, 3);
        imshow(masked_img);
        title('Asphalt segments');
        % }}}

        % draw the image with key points {{{
        figure(2);
        imshow(img);
        title('Extracted key points');
        hold on
        plot(frames(1,:), frames(2,:), 'r.');
        hold off
        % }}}

        % draw the image with car key points {{{
        figure(3);
        imshow(img);
        title('Classified key points');
        hold on
        plot(car_frames(1,:), car_frames(2,:), 'r.');
        hold off
        % }}}

        % draw the image with asphalt car key points {{{
        figure(4);
        imshow(img);
        title('Classified key points on asphalt');
        hold on
        plot(asphalt_car_frames(1,:), asphalt_car_frames(2,:), 'r.');
        hold off
        % }}}

        % draw the image with merged asphalt car key points {{{
        figure(5);
        imshow(img);
        title('Merged key points');
        hold on
        plot(asphalt_car_frames(1,:), asphalt_car_frames(2,:), 'r.');
        hold off
        % }}}

        warning on all
    end % }}}
end
% }}}
