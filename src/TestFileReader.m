classdef TestFileReader < matlab.unittest.TestCase
    %TESTFILEREADER tests for the FileReader class
    
    
    methods (Test)
        function testArticleFind(testCase)
            % testArticleFind tests the detection of the start of articles
            r = FileReader('../resources/test/miniLexisFile.txt');
            articles = 0;
            while(r.nextArticle())
                articles = articles + 1;
            end
            testCase.verifyEqual(articles, 3);
        end
        
        function testWordsExtract(testCase)
            % testWordsExtract tests extraction of words from an article
            % tests articles across multiple lines and empty articles
            r = FileReader('../resources/test/miniLexisFile.txt');
            r.nextArticle();
            allwords = TestFileReader.readAllWords(r);
            testCase.verifyEqual(allwords, {'David', 'unfinished', 'already', 'performed', 'a', 'service'});
            
            r.nextArticle();
            allwords = TestFileReader.readAllWords(r);
            testCase.verifyEqual(allwords{1}, 'The');
            testCase.verifyEqual(allwords{end}, 'Abdullah');
            
            r.nextArticle();
            allwords = TestFileReader.readAllWords(r);
            testCase.verifyEmpty(allwords);
        end
        
        function testPuctuation(testCase)
            % testWordsExtract tests wierd punctuation cases
            r = FileReader('../resources/test/miniLexisFileWithPunctuation.txt');
            r.nextArticle();
            allwords = TestFileReader.readAllWords(r);
            testCase.verifyEqual(allwords, {'abc', 'd', 'e', 'f', 'ghi', 'jk', 'lm'});
        end
    end
    
    methods (Static, Access = private)
        function allwords = readAllWords( r)
            words = r.nextWords();
            allwords = {};
            while(~isempty(words))
                allwords = [allwords words];
                words = r.nextWords();
            end
        end
    end
end

