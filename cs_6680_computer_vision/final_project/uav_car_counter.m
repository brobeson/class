clear

% if the asphalt SVM has already been trained, just load it. otherwise, train it. {{{
asphalt_svm_filename = 'uav_asphalt_svm.mat';
if exist(asphalt_svm_filename, 'file') == 2
    log_message('loading the asphalt SVM');
    svm_struct = load('uav_asphalt_svm.mat');
    asphalt_svm = svm_struct.svm_struct;
    assert(isa(asphalt_svm, 'ClassificationSVM'), 'loaded SVM is not really an SVM');
else
    log_message('training the asphalt SVM');
    asphalt_svm = uav_asphalt_trainer(imread('trainer.jpg'), asphalt_svm_filename);
    log_message('done training the UAV counter');
end
% }}}

return

% if the keypoint SVM has already been trained, just load it. otherwise, train it. {{{
keypoint_svm_filename = 'uav_keypoint_svm.mat';
if exist(keypoint_svm_filename, 'file') == 2
    log_message('loading the keypoint SVM');
    svm_struct = load('uav_keypoint_svm.mat');
    keypoint_svm = svm_struct.svm_struct;
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

% extract keypoints from the test image {{{
log_message('extracting keypoints. this typically takes around 30 seconds');
[frames, descriptors] = uav_sift(img);

% draw the image with keypoints {{{
warning off all % tired of seeing warnings about the image being too large
figure(1);
imshow(img);
hold on
plot(frames(1,:), frames(2,:), 'r.');
hold off
warning on all
% }}}
% }}}

% classify the keypoints {{{
log_message('classifying the keypoints');
classes = predict(keypoint_svm, descriptors');

% only keep the points corresponding to class 1. also, at this point, the
% descriptors are no longer needed, only the frames.
log_message('discarding background keypoints');
f = 1;
for c = 1:size(classes, 1)
    if classes(c) == 1
        car_frames(1:4, f) = frames(1:4, c);
        f = f + 1;
    end
end

% draw the image with car keypoints {{{
warning off all % tired of seeing warnings about the image being too large
figure(2);
imshow(img);
hold on
plot(car_frames(1,:), car_frames(2,:), 'r.');
hold off
warning on all
% }}}
% }}}


disp('Press any key to close windows and exit.');
pause
close all
