disp('Problem I.1 - create the row vector <3 11 5 5 11>');
A = [3 11 5 5 11]

disp('Problem I.2 - create the column vector <3 10 4 5 11>');
B = [3; 10; 4; 5; 11]

disp('Problem I.3 - create the row vector <1 4 7 ... 52 55> with 19 elements');
C = [1:3:55]

disp('Problem I.4 - find the length of the vector created in I.3');
length(C)

disp('Problem I.5 - find the sum of the vector created in I.3');
sum(C)

disp('Problem I.6 - replace all instances of the largest value in A with 20');
disp('              increment all instances of the second largest value in A by 5');
disp('              the new vector should be <3 20 10 10 20>');
maximum = max(A);
A(A == maximum) = 20;
maximum = max(A(A < maximum));
A(A == maximum) = maximum + 5

% repeat problem I.6 with a different vector
A = [1 4 4 10 10 4 10 1 0 2];
maximum = max(A);
A(A == maximum) = 20;
maximum = max(A(A < maximum));
A(A == maximum) = maximum + 5

disp('Problem II.1 - create a 10 x 10 zero matrix');
A = zeros(10, 10)

disp('Problem II.2 - create a 10 x 10 matrix filled with 1');
B = ones(10, 10)

disp('Problem II.3 - create a 10 x 10 matrix filled with 9');
% elapsed time for this method is 0.0001... seconds
%tic
C = zeros(10, 10);
C(C == 0) = 9
%toc

% elapsed time for this method is 0.0002... seconds
%tic
%for i = 1 : 100
%    C(i) = 9;
%end
%toc
%C

disp('Problem II.4 - create a 10 x 10 matrix with each row filled');
disp('               with the 0-based row index.');
D = zeros(10, 10);
% the first row is already filled with 0, so start with the 2nd row
for i = 2 : 10
    D(i, :) = i - 1;
end
D

disp('Problem II.5 - remove the 2nd row of problem II.4');
E = [D(1, :); D(3:10, :)]

disp('Problem II.6 - replace the 2nd of problem II.5 with 11s,');
disp('               and the 4th column with 12s.');
E(2, :) = 11;
E(:, 4) = 12
