clear
fig = 1; % semi-auto incrementing figure number

% if the asphalt SVM has already been trained, just load it. otherwise, train it. {{{
asphalt_svm_filename = 'uav_asphalt_svm.mat';
if exist(asphalt_svm_filename, 'file') == 2
    log_message('loading the asphalt SVM');
    svm_struct = load('uav_asphalt_svm.mat');
    asphalt_svm = svm_struct.asphalt_svm;
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

% load the asphalt mask {{{
log_message('warning', 'loading hand-made asphalt mask');
asphalt = imread('mask.png');
asphalt = logical(asphalt(:, :, 1));

% draw the mask
warning off all % tired of seeing warnings about the image being too large
figure(fig);
fig = fig + 1;
imshow(asphalt);
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

log_message('done counting cars');
fprintf(1, 'Press any key to close windows and exit.\n\n');
pause
close all
