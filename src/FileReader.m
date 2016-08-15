classdef FileReader < handle
    %FILEREADER Reads and tokenizes text files of newspaper atricles
    %   The newspaper articles are in the format output from LexisNexis
    %   An article starts on the line after one that begins "LENGTH: "
    %   An article ends on the line before one that begins "LOAD-DATE: "
    
    properties (Access = private)
        fid % handle to the open file
    end
    
    methods
        function obj = FileReader(filePath)
            %% FileReader constructor - initialize the reader with the file at the path supplied
            obj.fid = fopen(filePath);
        end
        
        function b = nextArticle(r)
            %% nextArticle find the next article
            %    returns true if another article was found, or false if no
            %    more articles in the file
            
            %line - the current line from the file
            %b - boolean - is there another article?
            
            % read a line from the file
            line = fgetl(r.fid);
            
            % if line is not a char then the end of the file has been reached
            while(ischar(line))
                
                % the last header line before an article starts with LENGTH: 
                % If we find this then the next line is the contents of an
                % article so return true
                if(strncmp('LENGTH: ', line, 8))
                    b = true;
                    return;
                end
                line = fgetl(r.fid);
            end
            b = false;
        end
        
        function words = nextWords(r)
            %% nextWords reads some more words from the file
            %     returns a cell array of words or an empty cell array if
            %     the end of the article has been reached
            
            %line - the current line from the file
            %cleanLine - cleaned up line
            %words - cell array of words in the line
            
            % read a content line from the file, if line is not a char then
            % there are no more lines in the current article in the file
            line = r.readContentLine();
            while(ischar(line))
                % replace all space and punctuation chars with a space
                cleanLine = regexprep(line,'\W+',' ');
                
                % split the line into a cell array of words
                words = strsplit(cleanLine, ' ');
                
                % remove any empty words
                words(cellfun('isempty',words)) = [];
                
                % if there are some words return them, otherwise move onto
                % the next line in the article content.
                if(~isempty(words))
                    return
                end
                line = r.readContentLine();
            end
        end
        
        function delete(r)
            fclose(r.fid);
        end
    end
    
    methods (Access = private)
        % private methods - for internal use in this class only
        
        function line = readContentLine(r)
            %% readContentLine reads a line of article content
            %     returns the line read or a numeric value if there is no
            %     more content in the article
            
            %line - the current line from the file
            
            % read a line from the file, a non-char value indicates the end
            % of the file has been reached
            line = fgetl(r.fid);
            if(ischar(line))
                
                % check if this is the end of an article, if so return -1
                % (a non-char value)
                % the first footer line below an article starts LOAD-DATE: 
                if(strncmp('LOAD-DATE: ', line, 11))
                    line = -1;
                    return;
                end
            end
        end
    end
    
end

