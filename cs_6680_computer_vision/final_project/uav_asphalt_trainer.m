function svm = uav_train_asphalt(training_img, filename)
    % UAV_TRAIN_ASPHALT() Train the SVM necessary for finding asphalt in UAV imagery.
    %   svm = UAV_TRAIN_ASPHALT(training_img, filename)
    %
    %   training_img    The image used for training the SVM. This should be an
    %                   RGB image.
    %   filename        The name of the file to use for saving the asphalt
    %                   classification SVM. If the file already exists, it will
    %                   be overwritten. This should be a character array.
    %   svm             The trained SVM is returned.
    %
    %   This function will train the asphalt classification support vector
    %   machine (SVM) used for counting cars in UAV imagery. Training the SVM is
    %   a lengthy process, so the trained SVM is saved so it can be reused.
    %   Thus, multiple images can be run through the counting process without
    %   constantly training an SVM.

    assert(nargin == 2, 'uav_trainer() requires a filename for saving the asphalt SVM');
    assert(isa(filename,  'char'), 'for uav_trainer(), filename must be a character array');

    % prep the asphalt training data {{{
    % non-asphalt - dirt & grass
    o = 1;
    for r = 2800:3000
        for c = 1090:1290
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % non-asphalt - building
    for r = 2990:3200
        for c = 4990:5190
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % non-asphalt - trees
    for r = 800:1000
        for c = 3600:3800
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % asphalt
    for r = 1400:1700
        for c = 2800:3200
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = 1;
            o = o + 1;
        end
    end

    % }}}

    % train and save the SVM {{{
    log_message('training the asphalt SVM');
    svm = fitcsvm(double(observations), asphalt_classes)
    save(filename, 'svm');
    % }}}
end
