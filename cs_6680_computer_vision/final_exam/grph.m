x = [ 0 0; 0 1; 1 0; 4 5; 5 5; 5 4];
m = zeros(2,2);
m(1) = (x(1) + x(2) + x(3)) / 3;
m(2) = (x(4) + x(5) + x(6)) / 3;
m(3) = (x(7) + x(8) + x(9)) / 3;
m(4) = (x(10) + x(11) + x(12)) / 3;

fn = [ m(1) m(3) -0.5*(m(1)*m(1) + m(3)*m(3));
       m(2) m(4) -0.5*(m(2)*m(2) + m(4)*m(4)) ];

x1 = [0:0.1:5];
x2 = (-21.67 + 4.33 * x1) / -4.33;

figure;
plot(x(:,1), x(:,2), 'ob');
hold on
plot(m(:,2), m(:,2), 'or');
plot(x1, x2);
hold off
