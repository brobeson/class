clear
log_message('begin training the UAV counter');

% training image
img = imread('trainer.jpg');

% extract frames and descriptors
log_message('extracting keypoints. this typically takes around 30 seconds...');
[frames, descriptors] = uav_sift(img);
log_message('done extracting keypoints.');

% prep the training data. the known classes were determined by manually
% analyzing the image
log_message('preparing the training data...');
t = 1;
for f = 1:size(frames, 2)
    x = frames(1, f);
    y = frames(2, f);

    % numerous non-car points: buildings, road, dirt, grass, trees...
    if 3170 < x
        training_set(:, t) = descriptors(:, f);
        classes(t) = -1;
        t = t + 1;

    % various cars
    elseif (3125 <= x) && (x <= 3165) && (2990 <= y) && (y <= 3086)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (2930 <= x) && (x <= 2969) && (2235 <= y) && (y <= 2330)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (3054 <= x) && (x <= 3093) && (1274 <= y) && (y <= 1364)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1737 <= x) && (x <= 2019) && (15 <= y) && (y <= 89)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1551 <= x) && (x <= 1659) && (y <= 97)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1269 <= x) && (x <= 1364) && (217 <= y) && (y <= 322)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1771 <= x) && (x <= 1998) && (306 <= y) && (y <= 360)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (2054 <= x) && (x <= 2093) && (292 <= y) && (y <= 360)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1434 <= x) && (x <= 1469) && (29 <= y) && (y <= 108)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1262 <= x) && (x <= 1359) && (605 <= y) && (y <= 703)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1893 <= x) && (x <= 2010) && (1071 <= y) && (y <= 1111)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;
    elseif (1503 <= x) && (x <= 1634) && (1299 <= y) && (y <= 1339)
        training_set(:, t) = descriptors(:, f);
        classes(t) = 1;
        t = t + 1;

    % all other frames are not used for the SVM training
    end
end
log_message('done preparing the training data.');

%warning off all % tired of seeing warnings about the image being too large
%figure;
%imshow(img);
%hold on
%%plot(frames(1,:), frames(2,:), 'r.');
%hold off
%warning on all
