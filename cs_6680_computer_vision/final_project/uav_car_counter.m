clear
% training image
img = imread('trainer.jpg');

svm_filename = 'uav_keypoint_svm.mat';

% if the keypoint SVM has already been trained, just load it
if exist(svm_filename, 'file') == 2
    log_message('loading the keypoint SVM...');
    svm = load('uav_keypoint_svm.mat');
    svm = svm.svm;
    assert(isa(svm, 'ClassificationSVM'), 'loaded SVM is not really an SVM');
    log_message('done training the UAV counter');
else
    log_message('begin training the UAV counter');
    svm = uav_trainer(img, svm_filename);
    log_message('done training the UAV counter');
end


%warning off all % tired of seeing warnings about the image being too large
%figure;
%imshow(img);
%hold on
%%plot(frames(1,:), frames(2,:), 'r.');
%hold off
%warning on all
