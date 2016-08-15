classdef WordStatsCounter < handle
    %WORDSTATSCOUNTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dictionary % the dictionary to use for testing
        xlWriter; 
        articleWords = 0; % total words seen so far for the article
        articleCounts; % array of counts of matching words, for each entry in the dictionary, for the article
        allWords = 0; % total words seen so far for all articles
        allCounts; % counts (as articleCounts) but for all articles
    end
    
    methods
        function obj = WordStatsCounter(dictionary, xlWriter)
            % WordStatsCounter constructor for class
            obj.dictionary = dictionary;
            obj.xlWriter = xlWriter;
            obj.articleCounts = zeros(1, length(obj.dictionary));
            obj.allCounts = zeros(1, length(obj.dictionary));
        end
        
        function addWords(obj, words)
            % addWords add the words supplied to the counter
            %    words is a cell array of words to be added
            
            %obj - the current object
            %words - words to be added
            %word - current word
            %i - loop counter
            %j - loop counter
            
            obj.articleWords = obj.articleWords + length(words);
            obj.allWords = obj.allWords  + length(words);
            
            % iterate over all words added
            for i = 1:length(words)
                word = words{i};
                % iterate over the dictionary entries
                for j = 1:length(obj.dictionary);
                    
                    %if the word matches the dictionary entry add one to
                    %the counter for this entry
                    if(obj.dictionary(j).matches(word))
                        obj.articleCounts(j) =  obj.articleCounts(j) + 1;
                        obj.allCounts(j) =  obj.allCounts(j) + 1;
                    end
                end
            end
        end
        
        function writeArticleResultsToExcel(obj, filename, sheet, row, column)
            % writeResultsToExcel writes the current stored counts to Excel
            %    writes to the row, starting from the specified column
            %    first column is the total number of words
            %    subsequent columns are the number of words for each
            %    dictionary entry, in order.
            
            %obj - the current object
            %filename - path to file
            %sheet - sheet in Excel
            %row - index for row in Excel
            %column - index for column in Excel
            %range - range in excel to write to
            
            % write the total words added
            range = xlRange(column,row,column,row);
            obj.xlWriter.xlswrite(filename, obj.articleWords, sheet, range);
            
            % write the count of matched words for each dictionary entry.
            range = xlRange(column+1,row,column+length(obj.articleCounts),row);
            obj.xlWriter.xlswrite(filename, obj.articleCounts, sheet, range);
        end
        
        function writeSummaryResultsToExcel(obj, filename, sheet, row, column)
            % writeResultsToExcel writes the current stored counts to Excel
            %    writes to the row, starting from the specified column
            %    first column is the total number of words
            %    subsequent columns are the number of words for each
            %    dictionary entry, in order.
            
            %range - range in excel to write to
            
            % write the total words added
            range = xlRange(column,row,column,row);
            obj.xlWriter.xlswrite(filename, obj.allWords, sheet, range);
            
            % write the count of matched words for each dictionary entry.
            range = xlRange(column+1,row,column+length(obj.allCounts),row);
            obj.xlWriter.xlswrite(filename, obj.allCounts, sheet, range);
        end
        
        function nextArticle(obj)
            % reset resets the counter to the initial (0) state
            obj.articleWords = 0;
            obj.articleCounts = zeros(1, length(obj.dictionary));
        end
    end
    
end

