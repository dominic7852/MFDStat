classdef TestWordStatsCounter < matlab.unittest.TestCase
    %TESTWORDSTATSCOUNTER tests for the WordStatsCounter class
    
    methods (Test)
        function testCounter(testCase)
            % testCounter tests the counter keeps count correctly
            
            d(1) = DictionaryEntry('a', {'a', 'aa'});
            d(2) = DictionaryEntry('b', {'b', 'bb'});
            
            tmpFile = [tempname '.xlsx'];
            cleaner = onCleanup(@() delete(tmpFile));
            xlWriter = ExcelWriter(tmpFile);
            
            wc = WordStatsCounter(d, xlWriter);
            
            testCase.verifyEqual(wc.articleWords, 0);
            testCase.verifyEqual(wc.articleCounts, [0 0]);
            testCase.verifyEqual(wc.allWords, 0);
            testCase.verifyEqual(wc.allCounts, [0 0]);
            
            wc.addWords({'a', 'b', 'c', 'aa', 'cc'});
            testCase.verifyEqual(wc.articleWords, 5);
            testCase.verifyEqual(wc.articleCounts, [2, 1]);
            testCase.verifyEqual(wc.allWords, 5);
            testCase.verifyEqual(wc.allCounts, [2 1]);
            
            wc.addWords({'d', 'aa'});
            testCase.verifyEqual(wc.articleWords, 7);
            testCase.verifyEqual(wc.articleCounts, [3, 1]);
            testCase.verifyEqual(wc.allWords, 7);
            testCase.verifyEqual(wc.allCounts, [3 1]);
            
            xlWriter.delete();
        end
        
        function testCounterWithWildCard(testCase)
            % testCounter tests the counter keeps count correctly
            
            d(1) = DictionaryEntry('a', {'car*', 'train'});
            
            tmpFile = [tempname '.xlsx'];
            cleaner = onCleanup(@() delete(tmpFile));
            xlWriter = ExcelWriter(tmpFile);
            wc = WordStatsCounter(d, xlWriter);
            
            testCase.verifyEqual(wc.articleWords, 0);
            testCase.verifyEqual(wc.articleCounts, 0);
            
            wc.addWords({'car', 'train', 'plane'});
            testCase.verifyEqual(wc.articleWords, 3);
            testCase.verifyEqual(wc.articleCounts, 2);
            wc.addWords({'cars', 'trains', 'planes'});
            testCase.verifyEqual(wc.articleWords, 6);
            testCase.verifyEqual(wc.articleCounts, 3);
            
            xlWriter.delete();
        end
        
        function testReset(testCase)
            % testReset test that the reset method resets the counter
            % correctly
            
            d(1) = DictionaryEntry('a', {'a', 'aa'});
            d(2) = DictionaryEntry('b', {'b', 'bb'});
            
            tmpFile = [tempname '.xlsx'];
            cleaner = onCleanup(@() delete(tmpFile));
            xlWriter = ExcelWriter(tmpFile);
            wc = WordStatsCounter(d, xlWriter);
            
            wc.addWords({'a', 'b', 'c', 'aa', 'cc'});
            testCase.verifyEqual(wc.articleWords, 5);
            testCase.verifyEqual(wc.articleCounts, [2, 1]);
            
            wc.nextArticle();
            wc.addWords({'d', 'aa'});
            testCase.verifyEqual(wc.articleWords, 2);
            testCase.verifyEqual(wc.articleCounts, [1, 0]);
            
            testCase.verifyEqual(wc.allWords, 7);
            testCase.verifyEqual(wc.allCounts, [3 1]);
            
            xlWriter.delete();
        end
        
        function testWriteResults(testCase)
            % testWriteResults tests that the results are written to an
            % Excel file correctly.
            
            d(1) = DictionaryEntry('a', {'a', 'aa'});
            d(2) = DictionaryEntry('b', {'b', 'bb'});
            
            tmpFile = [tempname '.xlsx'];
            cleaner = onCleanup(@() delete(tmpFile));
            xlWriter = ExcelWriter(tmpFile);
            
            wc = WordStatsCounter(d, xlWriter);
            wc.addWords({'a', 'b', 'c', 'aa', 'cc'});
            wc.writeArticleResultsToExcel(tmpFile, 1, 1, 1);
            
            wc.nextArticle();
            wc.addWords({'d', 'aa'});
            wc.writeArticleResultsToExcel(tmpFile, 1, 2, 1);
            wc.writeSummaryResultsToExcel(tmpFile, 1, 3, 1);
            
            xlWriter.delete();
            
            [~,~,n] = xlsread(tmpFile, 1);
            testCase.assertEqual(n, num2cell([5, 2, 1; 2, 1, 0; 7, 3, 1]));
        end
    end
end

