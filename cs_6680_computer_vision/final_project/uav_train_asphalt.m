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
    % non-asphalt - dirt
    o = 1;
    for r = 451:500
        for c = 3271:3320
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % non-asphalt - grass
    for r = 1801:1850
        for c = 3901:3950
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % non-asphalt - building
    for r = 1051:1100
        for c = 1001:1051
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end
    for r = 901:950
        for c = 2251:2300
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % non-asphalt - trees
    for r = 1201:1251
        for c = 3351:3400
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % non-asphalt - cars
    for r = 2651:2700
        for c = 5251:5300
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    % non-asphalt - railroad
    for r = 1901:1950
        for c = 2701:2750
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = -1;
            o = o + 1;
        end
    end

    log_message(sprintf('%d non-asphalt observations', o));
    oo = o;

    % asphalt
    for r = 1001:1050
        for c = 1701:1750
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = 1;
            o = o + 1;
        end
    end
    for r = 1001:1050
        for c = 1901:1950
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = 1;
            o = o + 1;
        end
    end
    for r = 1201:1250
        for c = 2841:2890
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = 1;
            o = o + 1;
        end
    end
    for r = 2801:2851
        for c = 5301:5350
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = 1;
            o = o + 1;
        end
    end
    for r = 1901:1950
        for c = 3001:3050
            observations(o, 1:3) = training_img(r, c, 1:3);
            asphalt_classes(o) = 1;
            o = o + 1;
        end
    end

    log_message(sprintf('%d asphalt observations', o-oo));
    log_message(sprintf('%d total observations', o));

    % }}}

    % train and save the SVM {{{
    log_message('training the asphalt SVM');
    svm = fitcsvm(double(observations), asphalt_classes)
    save(filename, 'svm');
    % }}}
end
