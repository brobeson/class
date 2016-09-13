% Brendan Robeson
% CS 6680
% Assignment 2

food = imread('Food.jpg');

% Problem 1 {{{
% these calls to Scaling should all throw an error. thus, if the display
% statement following the call is executed, the test failed. if the display
% statement in the catch block is executed, the test passed.
printf('Running tests for problem 1...\n');
try
    printf('    Testing not enough values in range... ');
    Scaling(food, 10);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing two many columns in range... ');
    Scaling(food, [10 100 255]);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing too many rows in range... ');
    Scaling(food, [10; 255]);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing maximum < minimum... ');
    Scaling(food, [100 40]);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing a negative minimum... ');
    Scaling(food, [-5 255]);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing a negative maximum... ');
    Scaling(food, [-5 -1]);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing a minimum out of bounds... ');
    Scaling(food, [256 300]);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing a maximum out of bounds... ');
    Scaling(food, [5 256]);
    printf('failed\n');
catch
    printf('passed\n');
end

try
    printf('    Testing if inputIm is not uint8... ');
    Scaling(ones(2, 2), [5 256]);
    printf('failed\n');
catch
    printf('passed\n');
end

% these calls to Scaling should not throw an error. thus, if the display
% statement following the call is executed, the test passed. if the display
% statement in the catch block is executed, the test failed.
try
    printf('    Testing if inputIm is uint8... ');
    Scaling(rand(2, 2, 'uint8'), [5 255]);
    printf('passed\n');
catch
    printf('failed\n');
end

try
    printf('    Testing valid values of range minimum... ');
    for m = [0:255]
        Scaling(food, [m 255]);
    end
    printf('passed\n');
catch
    printf('failed\n');
end

try
    printf('    Testing valid values of range maximum... ');
    for m = [0:255]
        Scaling(food, [0, 255]);
    end
    printf('passed\n');
catch
    printf('failed\n');
end

% verify the actual operations
try
    printf('    Testing operation... \n');
    input_1 = uint8([  1  2  3  4;
                       5  6  7  8;
                       9 10 11 12;
                      13 14 15 16 ])
    printf('        cutting in half...\n');
    Scaling(input_1, [0 8])
    printf('        cutting in half and shifting up by 4...\n');
    Scaling(input_1, [4 12])
catch problem
    printf('something failed horribly\n');
    display(problem.message);
end


%disp('-----Finish Solving Problem 1-----')
%pause
% }}}

