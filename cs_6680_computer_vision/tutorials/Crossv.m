function vans = Crossv(ra, rb)
% r = [x y x] row vector
% ra and rb must be row vectors with three elements
% cross product of ra and rb
vx = ra(2) * rb(3) - ra(3) * rb(2);
vy = ra(3) * rb(1) - ra(1) * rb(3);
vz = ra(1) * rb(2) - ra(2) * rb(1);
vans = [vx vy vz];
