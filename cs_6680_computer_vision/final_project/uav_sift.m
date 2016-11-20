function [frames, descriptors] = uav_sift(img)
    % uav_sift  Perform a SIFT [1] operation on an image, suitable for UAV imagery.
    %   [frames, descriptors] = uav_sift(img)
    %
    %   img         The image for which to calculate SIFT information. The image
    %               must be an RGB image of class uint8.
    %   frames      The SIFT frames [1]. This is a matrix of class double, with
    %               four rows, and one column for each frame.
    %   descriptors The SIFT frame descriptors [1]. These are enhanced with
    %               color information as described in [2]. The descriptors are a
    %               matrix of class double, with 152 rows, and one column for
    %               each frame. Each descriptor contains standard SIFT
    %               information, and the additional color information as
    %               described in [2].
    %
    %   This function will calculate the normal SIFT information (frames and
    %   descriptors). Each frame is a four component column in the matrix
    %   'frames'. Each frame descriptor is a 152 component column in the matrix
    %   'descriptors'. This function requires that the VLFeat toolbox is
    %   installed; see http://www.vlfeat.org/.
    %
    %   [1] D. Lowe, "Distinctive image features form scale-invariant
    %       keypoints," Int. J. Comput. Vis., vol. 60, no. 2, pp. 91–110, 2004.
    %   [2] T. Moranduzzo and F. Melgani, "Automatic Car Counting Method for
    %       Unmanned Aerial Vehicle Images," in IEEE Transactions on Geoscience
    %       and Remote Sensing, vol. 52, no. 3, pp. 1635-1647, March 2014. doi:
    %       10.1109/TGRS.2013.2253108

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
    % double.
    img_hsv = rgb2hsv(img);
    descriptors = double(descriptors);

    % cascaded image dilations & erosions
    se_1 = strel('disk', 3);
    se_2 = strel('disk', 4);
    se_3 = strel('disk', 5);
    dilated_1 = imdilate(img,       se_1);
    dilated_2 = imdilate(dilated_1, se_2);
    dilated_3 = imdilate(dilated_2, se_3);
    eroded_1  = imerode (img,       se_1);
    eroded_2  = imerode (eroded_1,  se_2);
    eroded_3  = imerode (eroded_2,  se_3);

    % expand the descriptors to make room for the color information as described
    % in [2]. then fill in the data.
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
        descriptors(135:137, d) = dilated_1(y, x, :);
        descriptors(138:140, d) = dilated_2(y, x, :);
        descriptors(141:143, d) = dilated_3(y, x, :);

        % the 3 erosions
        descriptors(144:146, d) = eroded_1(y, x, :);
        descriptors(147:149, d) = eroded_2(y, x, :);
        descriptors(150:152, d) = eroded_3(y, x, :);
    end
end
