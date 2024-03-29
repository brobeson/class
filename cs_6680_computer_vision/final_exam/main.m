% problem 1.3 {{{
original_img = imread('Wirebond.tif');
figure(1);
subplot(1, 3, 1);
imshow(original_img);

%img = imopen(original_img, strel('square', 3));
%img = imopen(img, strel('square', 5));
img = imopen(original_img, strel('disk', 8));
%img = imopen(img, strel('rectangle', [10 5]));

%img = imerode(img, strel('rectangle', [10 5]));

subplot(1, 3, 2);
imshow(img);


subplot(1, 3, 3);
imshow(abs(original_img - img));
% }}}

return

% problem 3.1 {{{
x = [ 0 0 5 5 4 1 ];
y = [ 0 1 4 5 5 0 ];

figure;
plot(x, y, '.r');
% }}}

return

% problem 1.1 {{{
A = zeros(12, 17, 'logical');
A(3:5, 3:8) = 1;
A(3:4, 11:15) = 1;
A(5, 11:13) = 1;
A(6, 6:13) = 1;
A(7:9, 4:8) = 1;
A(7:8, 11:13) = 1;
A(9, 11:15) = 1;
se = strel('square', 3);
B = imdilate(imdilate(imdilate(A, se), se), se)
% }}}
