load mandrill
[r,c] = size(X);
figure('Units', 'Pixels', 'Position', [100 100 c r]);
image(X);
axis image off;
set(gca, 'Position', [0 0 1 1]);
colormap(map)
