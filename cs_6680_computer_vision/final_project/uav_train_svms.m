% UAV_TRAIN_SVMS    Helper script to train both the asphalt and key point SVMs.
%
%   The asphalt SVM is saved to 'uav_asphalt_svm.mat'. The key point SVM is
%   saved to 'uav_keypoint_svm.mat'.

img = imread('trainer.jpg');
uav_asphalt_trainer(img, 'uav_asphalt_svm.mat');
uav_train_keypoints(img, 'uav_keypoint_svm.mat');
