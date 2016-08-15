classdef DictionaryEntry < handle
    %DICTIONARYENTRY an entry in the dictionary
    %   Each dictionary entry contains a name and multiple words that are
    %   related to the name.
    
    properties
        name % the string name of this entry
    end
    
    % the private property internalWords and dependent property words both are
    % required because the set method for words need to keep startsWith
    % consistent with the words property. See the following for details: 
    % https://uk.mathworks.com/help/matlab/matlab_oop/avoiding-property-initialization-order-dependency.html
    
    properties (Dependent)
        words % cell array of words in the entry
    end
    
    properties (Access=private)
        internalWordsFull % storedWords
        internalWordsPrefix
    end
    
    methods
        function obj = DictionaryEntry(name, words)
            % DictionaryEntry constructor for the class
            % supports 0 arguments, or the name and words can be supplied
            if  nargin > 0
                obj.name = name;
                obj.words = words;
            end
        end
        
        function value = get.words(entry)
            % get.words getter for words property
            %    just return the value of the internalWords property
            value = [entry.internalWordsFull, entry.internalWordsPrefix];
        end
        
        function set.words(entry, words)
            % set.words setter for words property
            %    set the internal words property and calculate the value of
            %    startsWith for each word. If a word ends in a * character
            %    startsWith is set to true for the word and the * is
            %    removed from the word, otherwise startsWith is set to false
            
            %entry - this dictionary entry object
            %words - cell array of words for the dictionary entry
            %w - the current dictionary word in the loop
            %index - the loop counter
            
            
            iFull = 1;
            iPrefix = 1;
            for index = 1:length(words)
                w = words{index};
                if(w(end) == '*')
                    entry.internalWordsPrefix{iPrefix} = w(1:end-1);
                    iPrefix = iPrefix+1;
                else
                    entry.internalWordsFull{iFull} = w;
                    iFull = iFull+1;
                end
            end
        end

        function b = oldMatches(entry, word)
            %matches tests if the word suplied matches this entry
            %   includes support for dictionary words that end with an
            %   asterisk character
            %   returns boolean if a match is found or not
            
            %entry - this dictionary entry object
            %b - the boolean result
            %w - the current dictionary word in the loop
            %index - the loop counter
            %word - the word being tested
            
            for index = 1:length(entry.internalWords)
                w = entry.internalWords{index};
                if(entry.startsWith(index))
                    % case insensitive test if the word starts with the dictionary entry
                    len = length(w);
                    b = length(word) >= len && strncmpi(w, word, len);
                else
                    % case insensitive comparison of word to entry
                    b = strcmpi(w, word);
                end
                
                % if it matches return immediatley - there is no need to
                % check remaining words
                if(b)
                    return
                end
            end
        end
        
        function b = matches(entry, word)
            %matches tests if the word suplied matches this entry
            
            %entry - this dictionary entry object
            %b - the boolean result
            %w - the current dictionary word in the loop
            %index - the loop counter
            %word - the word being tested
            
            b = ~isempty(find(strcmpi(entry.internalWordsFull,word), 1));
            
            if(b || isempty(entry.internalWordsPrefix))
                return
            end
            
            inLength = length(word);
            for index = 1:length(entry.internalWordsPrefix)
                w = entry.internalWordsPrefix{index};
                % case insensitive test if the word starts with the dictionary entry
                len = length(w);
                b = inLength >= len && strncmpi(w, word, len);
                
                % if it matches return immediatley
                if(b)
                    return
                end
            end
        end
        
    end
    
    methods(Static)
        function entries = readFromFile(filePath)
            % readFromFile reads dictionary from the Excel file supplied
            %    returns an array of dictionary entry objects
            %
            %    expects an excel file that contains a column for each
            %    entry, with the first row being the entry name and all
            %    subsequent rows containing the words for the entry
            
            %txt - the contents of the excel file
            %numEntries - the number of dictionary entries
            %index - the loop counter
            %col - the current column from the excel
            %entries - the entries created
            
            [~,txt,~] = xlsread(filePath, 1);
            
            numEntries = size(txt,2);
            entries(numEntries) = DictionaryEntry;
            for index = 1:numEntries
                col = txt(:,index);
                
                % remove any empty values
                col(cellfun('isempty',col)) = [];
                
                % store the data in the dictionary entry
                entries(index).name = col{1}; % first row is the name
                entries(index).words = col(2:end)'; % remaining rows are values, rotate to a row
            end
        end
        
        function writeHeaderToExcel(xlWriter, entries, filePath, sheet, row, col)
           %  writeHeaderToExcel writes a header for the supplied entries
           %     entries - array of dictionary entries
           %     filePath - path to excel file
           %     sheet - the sheet in excel to write to
           %     row - the row in excel to write to
           %     col - the first column n excel to write to, one column per entry will be used
           
           %header - text to write to excel
           %index - the loop counter
           %range - excel range

           header = cell(1, length(entries));
           for index = 1:length(entries)
               header{index} = entries(index).name;
           end
           
           % calculate range to write to in Excel format
           range = xlRange(col,row,col+length(header)-1,row);
           % write the header to excel
           xlWriter.xlswrite(filePath, header, sheet, range);
        end 
    end
    
end

