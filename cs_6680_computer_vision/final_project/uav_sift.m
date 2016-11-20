function [frames, descriptors] = uav_sift(img)

    % TODO  make this more robust. i know my test data is uint8 RGB. this
    %       function should appropriately handle grayscale and floating point
    %       data.
    assert(ndims(img) == 3,   'at this time, uav_sift() only supports RGB images');
    assert(isa(img, 'uint8'), 'at this time, uav_sift() only supports uint8 image data');

    % get the basic SIFT frames (keypoints) and their descriptors
    %[frames, descriptors] = vl_sift(img);
    [frames, descriptors] = vl_sift(im2single(rgb2gray(img)));

    % HSV information will be appended to the basic descriptor, so convert the
    % image. also, hue is typically described on [0,1] or [1,360], neither of
    % which can be represented by a uint8. so convert the entire descriptor to
    % single.
    img_hsv = rgb2hsv(img);
    descriptors = single(descriptors);

    % cascaded image dilations & erosions
    img_d1 = imdilate(img,    strel('disk', 3));
    img_d2 = imdilate(img_d1, strel('disk', 4));
    img_d3 = imdilate(img_d2, strel('disk', 5));
    img_e1 = imerode(img,    strel('disk', 3));
    img_e2 = imerode(img_e1, strel('disk', 4));
    img_e3 = imerode(img_e2, strel('disk', 5));

    % expand the descriptors to make room for the color information as described
    % in [1]. then fill in the data.
    descriptors(129:152, 1) = 0;
    for d = 1:size(descriptors, 2)
        % get the RGB color. the frame has fractional coordinates; for now,
        % round to get the pixel coordinates
        x = round(frames(1, d));
        y = round(frames(2, d));
        descriptors(129:131, d) = img(y, x, :);

        % get the HSV of the 
        descriptors(132:134, d) = img_hsv(y, x, :);

        % the 3 dilations
        descriptors(135:137, d) = img_d1(y, x, :);
        descriptors(138:140, d) = img_d2(y, x, :);
        descriptors(141:143, d) = img_d3(y, x, :);

        % the 3 erosions
        descriptors(144:146, d) = img_e1(y, x, :);
        descriptors(147:149, d) = img_e2(y, x, :);
        descriptors(150:152, d) = img_e3(y, x, :);
    end
end
