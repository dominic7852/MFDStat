% RunAllTests runs all test classes in the working directory
%    results are printed to the command window

%% Tidy up
clc; 
close all;
% use clear global and variables instead of clear all to prevent unecessary
% recompilation and increase performance, for details see
% https://uk.mathworks.com/help/matlab/ref/clear.html
clear global;
clear variables;

%% Set up TestSuite
import matlab.unittest.TestSuite;
% all tests are included in the current folder
suiteFolder = TestSuite.fromFolder(pwd);

%% run the tests
run(suiteFolder)