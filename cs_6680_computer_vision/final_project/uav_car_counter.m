clear

% if the keypoint SVM has already been trained, just load it. otherwise, train it. {{{
svm_filename = 'uav_keypoint_svm.mat';
if exist(svm_filename, 'file') == 2
    log_message('loading the keypoint SVM');
    svm = load('uav_keypoint_svm.mat');
    svm = svm.svm;
    assert(isa(svm, 'ClassificationSVM'), 'loaded SVM is not really an SVM');
else
    log_message('begin training the UAV counter');
    svm = uav_trainer(imread('trainer.jpg'), svm_filename);
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
classes = predict(svm, descriptors');

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
