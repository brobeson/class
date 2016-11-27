function svm = uav_train_keypoints(training_img, filename)
    % UAV_TRAIN_KEYPOINTS() Train the SVM necessary for finding car keypoints in UAV imagery.
    %   svm = UAV_TRAIN_KEYPOINTS(training_img, filename)
    %
    %   training_img    The image used for training the SVM. This must be a
    %                   uint8 RGB image.
    %   filename        The name of the file to use for saving the keypoint
    %                   classification SVM. If the file already exists, it will
    %                   be overwritten. This should be a character array.
    %   svm             The trained SVM is returned.
    %
    %   This function will train the support vector machine (SVM) used for
    %   classifying keypoints in UAV imagery. Training the SVM is a lengthy
    %   process, so the trained SVM is saved so it can be reused. Thus, multiple
    %   images can be run through the counting process without constantly
    %   training the SVM.

    assert(nargin == 2, 'uav_trainer() requires a filename for saving the keypoint SVM');
    assert(isa(filename, 'char'), 'for uav_trainer(), filename must be a character array');

    % extract frames and descriptors {{{
    log_message('extracting keypoints. this typically takes around 30 seconds');
    [frames, descriptors] = uav_sift(training_img);
    % }}}

    % prep the training dataG. the known classes were determined by manually analyzing the image {{{
    log_message('preparing the training data');
    t = 1;
    for f = 1:size(frames, 2)
        x = frames(1, f);
        y = frames(2, f);

        % numerous non-car points: buildings, road, dirt, grass, trees...
        if 3170 < x
            training_set(:, t) = descriptors(:, f);
            classes(t) = -1;
            t = t + 1;

        % various cars
        elseif (3125 <= x) && (x <= 3165) && (2990 <= y) && (y <= 3086)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (2930 <= x) && (x <= 2969) && (2235 <= y) && (y <= 2330)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (3054 <= x) && (x <= 3093) && (1274 <= y) && (y <= 1364)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1737 <= x) && (x <= 2019) && (15 <= y) && (y <= 89)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1551 <= x) && (x <= 1659) && (y <= 97)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1269 <= x) && (x <= 1364) && (217 <= y) && (y <= 322)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1771 <= x) && (x <= 1998) && (306 <= y) && (y <= 360)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (2054 <= x) && (x <= 2093) && (292 <= y) && (y <= 360)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1434 <= x) && (x <= 1469) && (29 <= y) && (y <= 108)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1262 <= x) && (x <= 1359) && (605 <= y) && (y <= 703)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1893 <= x) && (x <= 2010) && (1071 <= y) && (y <= 1111)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;
        elseif (1503 <= x) && (x <= 1634) && (1299 <= y) && (y <= 1339)
            training_set(:, t) = descriptors(:, f);
            classes(t) = 1;
            t = t + 1;

        % no other frames are used for the SVM training
        end
    end
    % }}}

    % train and save the SVM {{{
    log_message('training the keypoint data');
    svm = fitcsvm(training_set', classes)
    save(filename, 'svm');
    % }}}
end
