function [frames, descriptors] = uav_sift(img)

    % TODO  make this more robust. i know my test data is uint8 RGB. this
    %       function should appropriately handle grayscale and floating point
    %       data.
    assert(ndims(img) == 3, 'at this time, uav_sift() only supports RGB images');

    % the image is needed in three color spaces: rgb, hsv, and grayscale
    %if ndims(img) == 3 % input is rgb
    %    img_rgb = img;
    %    img_hsv = 

    % normal sift is only defined for grayscale, single precision, floating point
    % data.
    %if ndims(img) == 3
    %    img = rgb2gray(img);
    %end
    %if isa(img, 'integer')
    %    img = im2double(img);
    %end
    %if isa(img, 'double')
    %    img = single(img);
    %end

    % get the basic SIFT frames (keypoints) and their descriptors
    %[frames, descriptors] = vl_sift(img);
    [frames, descriptors] = vl_sift(im2single(rgb2gray(img)));

    % expand the descriptors to make room for the color information as described
    % in [1]. then fill in the data.
    descriptors(129:152, 1) = 0;
    %for d = 1:size(descriptors, 2)
    %    % get the RGB color. the frame has fractional coordinates; for now,
    %    % round to get the pixel coordinates
    %    descriptors(129:
    %end
end
