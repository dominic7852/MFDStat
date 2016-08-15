function AnalyzeArticlesFromFile( dictFilePath, artFilePath, resultsFilePath, resultsSheet )
%ANALYZEARTICLES analyze the articles and save results to Excel
%   Analyzes the frequency of the dictionary words in all the articles in
%   the article file and saves the results to the results file
%   dictFilePath - path to the dictionary Excel file
%   artFilePath - path to the article file
%   resultsFilePath - path to the results Excel file
%   resultsSheet - the sheet to write the results to

%entries - the dictionary entries
%artFileName - the name of the article file
%wsc - the WordStatsCounter
%reader - the TextFileReader
%index - loop counter
%excelRow - current row to write to in excel results file
%range - excel format range

% initialize the dictionary
entries = DictionaryEntry.readFromFile(dictFilePath);

xlWriter = ExcelWriter(resultsFilePath);

% write the header row to the results as: File, Article, Total Words, <dictionaryEntry>*
xlWriter.xlswrite(resultsFilePath, {'File', 'Article', 'Total Words'}, resultsSheet, 'A1:C1');
DictionaryEntry.writeHeaderToExcel(xlWriter, entries, resultsFilePath, resultsSheet, 1, 4);

% find the filename of the article file
[~,artFileName,~] = fileparts(artFilePath);

% initialize the word counter
wsc = WordStatsCounter(entries, xlWriter);

% open the file containing multiple articles
reader = FileReader(artFilePath);

% use article to keep track of the current article number being read
index = 0;

%% iterate over all articles in the file
while(reader.nextArticle())
    % update article number
    index = index + 1;
    
    % the row in the results file to write to,
    excelRow = index+1;
    
    % write the first 2 cols, with article details to the results file
    range = xlRange(1, excelRow, 2, excelRow);
    xlWriter.xlswrite(resultsFilePath, {artFileName, index}, resultsSheet, range);
    
    % iterate until the article is fully processed
    % this is efficient - only one line of the article is read and
    % processed at a time, no matter how long the file is
    words = reader.nextWords();
    while(~isempty(words))
        % process the words from the line
        wsc.addWords(words);
        words = reader.nextWords();
    end
    
    % write the results for the article to the results file
    wsc.writeArticleResultsToExcel(resultsFilePath, resultsSheet, excelRow, 3);
    
    % reset the counter, ready for the next article
    wsc.nextArticle();
end

%% write the summary results
excelRow = excelRow+1;

range = xlRange(1, excelRow, 2, excelRow);
xlWriter.xlswrite(resultsFilePath, {'Totals', index}, resultsSheet, range);

wsc.writeSummaryResultsToExcel(resultsFilePath, resultsSheet, excelRow, 3);

xlWriter.delete();

%% file reader closes the file using the destructor after the function ends
% as it is no longer reachable, no need to explicitly close. This also
% applies if there are any error conditions.
end

