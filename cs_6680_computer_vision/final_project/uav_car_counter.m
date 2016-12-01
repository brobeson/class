clear
fig = 1; % semi-auto incrementing figure number

% if the asphalt SVM has already been trained, just load it. otherwise, train it. {{{
asphalt_svm_filename = 'uav_asphalt_svm.mat';
if exist(asphalt_svm_filename, 'file') == 2
    log_message('loading the asphalt SVM');
    svm_struct = load('uav_asphalt_svm.mat');
    asphalt_svm = svm_struct.svm;
    assert(isa(asphalt_svm, 'ClassificationSVM'), 'loaded SVM is not really an SVM');
else
    log_message('training the asphalt SVM');
    asphalt_svm = uav_asphalt_trainer(imread('trainer.jpg'), asphalt_svm_filename);
    log_message('done training the UAV counter');
end
% }}}

% if the keypoint SVM has already been trained, just load it. otherwise, train it. {{{
keypoint_svm_filename = 'uav_keypoint_svm.mat';
if exist(keypoint_svm_filename, 'file') == 2
    log_message('loading the keypoint SVM');
    svm_struct = load('uav_keypoint_svm.mat');
    keypoint_svm = svm_struct.svm;
    assert(isa(keypoint_svm, 'ClassificationSVM'), 'loaded SVM is not really an SVM');
else
    log_message('begin training the UAV counter');
    keypoint_svm = uav_trainer(imread('trainer.jpg'), keypoint_svm_filename);
    log_message('done training the UAV counter');
end
% }}}

% load the image to count {{{
log_message('loading test image');
img = imread('test.jpg');
% }}}

% extract the asphalt segments {{{
log_message('extracting asphalt');

% the SE radii are adapted from the paper. the numerators are in cm, and the
% divisors are the image resolution. thus, the radii are in pixels, based on
% real world distances.
asphalt = uav_find_asphalt(img, asphalt_svm, ceil(30 / 4), ceil(300 / 4));

% draw the asphalt mask {{{
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
% }}}
% }}}

% extract key points from the test image {{{
log_message('extracting key points. this typically takes around 30 seconds');
[frames, descriptors] = uav_sift(img);

% draw the image with key points {{{
warning off all % tired of seeing warnings about the image being too large
figure(fig);
fig = fig + 1;
imshow(img);
hold on
plot(frames(1,:), frames(2,:), 'r.');
hold off
warning on all
% }}}
% }}}

% classify the key points {{{
log_message('classifying the key points');
classes = predict(keypoint_svm, descriptors');

% only keep the points corresponding to class 1. also, at this point, the
% descriptors are no longer needed, only the frames.
log_message('discarding background key points');
f = 1;
for c = 1:size(classes, 1)
    if classes(c) == 1
        car_frames(1:4, f) = frames(1:4, c);
        f = f + 1;
    end
end

% draw the image with car key points {{{
warning off all % tired of seeing warnings about the image being too large
figure(fig);
fig = fig + 1;
imshow(img);
hold on
plot(car_frames(1,:), car_frames(2,:), 'r.');
hold off
warning on all
% }}}
% }}}

% remove key points which are not in asphalt {{{
log_message('removing key points from non-asphalt areas');
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
warning off all % tired of seeing warnings about the image being too large
figure(fig);
fig = fig + 1;
imshow(img);
hold on
plot(asphalt_car_frames(1,:), asphalt_car_frames(2,:), 'r.');
hold off
warning on all
% }}}
% }}}

% merge the key points {{{
log_message('merging key points');

% this is for 4cm/pixel imagery. assuming the average car is 360 cm long, use
% 360/4 == 90 pixels for the threshold distance.
[asphalt_car_frames, n] = uav_merge_keypoints(asphalt_car_frames, 90);

% draw the image with merged asphalt car key points {{{
warning off all % tired of seeing warnings about the image being too large
figure(fig);
fig = fig + 1;
imshow(img);
hold on
plot(asphalt_car_frames(1,:), asphalt_car_frames(2,:), 'r.');
hold off
warning on all
% }}}
% }}}

log_message('done counting cars');
fprintf(1, 'Press any key to close windows and exit.\n\n');
pause
close all
