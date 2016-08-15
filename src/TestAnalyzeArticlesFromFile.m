classdef TestAnalyzeArticlesFromFile < matlab.unittest.TestCase
    %TestAnalyzeArticlesFromFile integration tests for TestAnalyzeArticlesFromFile
    
    methods (Test)
        function testAnalyze(testCase)
            dictFile = '../resources/test/testDictionary.xlsx';
            artFile = '../resources/test/miniLexisFile2.txt';
            resFile = [tempname '.xlsx'];
            cleaner = onCleanup(@() delete(resFile));
            
            AnalyzeArticlesFromFile(dictFile, artFile, resFile, 1);
            
            [num, txt, raw] = xlsread(resFile, 1);
            
            testCase.verifyEqual(size(raw), [6 6]);
            
            % header row
            testCase.verifyEqual(txt(1,:), {'File', 'Article', 'Total Words', 'fruit', 'vegetable', 'vehicle'});
            %check filename is included
            testCase.verifyEqual(txt(2,1), {'miniLexisFile2'});
            %check last row has Totals header
            testCase.verifyEqual(txt(6,1), {'Totals'});

            
            % check stats calculated for articles
            % art 1, 17 words, 4 fruit, 3 veg, 3 vehicle
            testCase.verifyEqual(num(1, :), [1 17 4 3 3]);
            
            % art 2, 6 words, 0 fruit, 0 veg, 0 vehicle
            testCase.verifyEqual(num(2, :), [2 6 0 0 3]);
            
            % art 3, 0 words, 0 fruit, 0 veg, 0 vehicle
            testCase.verifyEqual(num(3, :), [3 0 0 0 0]);

            % art 4, 36 words, 0 fruit, 0 veg, 0 vehicle
            testCase.verifyEqual(num(4, :), [4 36 0 0 0]);
            
            % summary row: art 4, 36 words, 0 fruit, 0 veg, 0 vehicle
            testCase.verifyEqual(num(5, :), [4 59 4 3 6]);
        end
    end
end

