function asphalt = uav_find_asphalt(img, svm, erode_se_radius, dilate_se_radius)
    % UAV_FIND_ASPHALT  extract asphalt segments from a UAV image
    %   asphalt = UAV_FIND_ASPHALT(img, svm, erode_se_radius, dilate_se_radius)
    %
    %   img                 The UAV image for which to find the asphalt segments.
    %                       This should be a uint8 RGB image.
    %   svm                 The trained asphalt SVM. See uav_train_asphalt().
    %   erode_se_radius     The radius of the disk structuring element to use
    %                       for the erosion step of generating the asphalt mask.
    %   dilate_se_radius    The radius of the disk structuring element to use
    %                       for the dilation step of generating the asphalt mask.
    %   asphalt             A binary image with the same number of rows and
    %                       columns as img. Asphalt areas are 1, all other areas
    %                       are 0.

    assert(nargin == 4,       'four input arguments are required');
    assert(isa(img, 'uint8'), 'img must be of class uint8');
    assert(ndims(img) == 3,   'img must be RGB');
    assert(isa(svm, 'ClassificationSVM'), 'svm must be a ClassificationSVM');

    % reshape the image so that each pixel is an observation... in a matrix.
    % this is required for the call to predict().
    observations = double(reshape(img, size(img, 1) * size(img, 2), 3));

    % run the observations through the SVM. then convert all classes of -1 to 0
    % and cast the classes to a logical array.
    classes = predict(svm, observations);
    classes(classes == -1) = 0;
    classes = logical(classes);

    % reshape the classes back to match the image dimensions
    asphalt = reshape(classes, size(img, 1), size(img, 2));

    % not sure why, but asphalt areas are turning up 0, while background areas
    % turn up 1. so... reverse it
    asphalt = 1 - asphalt;

    % erode the asphalt, then dilate it... a lot!
    asphalt = imdilate(imerode(asphalt, strel('disk', erode_se_radius)),
                       strel('disk', dilate_se_radius));
end
