dict = '../resources/pilot/MoralFoundationDictionary.xlsx';
% results = 'ResultsSmall.xlsx';

% results = 'ResultsMed.xlsx';

results = 'F:\Documents\Dropbox\CoDeS Project - Dominic Stolerman\work\Phase2\NP Docs\All_Non_HR_Results.xlsx';
% results = 'F:\Results.xlsx';

pth = 'F:\Documents\Dropbox\CoDeS Project - Dominic Stolerman\work\Phase2\NP Docs\Non-HR';
files = dir(fullfile(pth, '*.TXT'));

articles = {files.name};

% articles = {'small_Guardian_HR.TXT', 'small_Guardian.TXT', ...
%     'small_Independent_HR.TXT', 'small_Independent.TXT', ...
%     'small_Telegraph_HR.TXT', 'small_Telegraph.TXT', ...
%     'small_Mail_HR.TXT', 'small_Mail.TXT'};

% articles = {'med_Guardian_HR.TXT', 'med_Guardian.TXT', ...
%     'med_Independent_HR.TXT', 'med_Independent.TXT', ...
%     'med_Telegraph_HR.TXT', 'med_Telegraph.TXT', ...
%     'med_Mail_HR.TXT', 'med_Mail.TXT'};

for index = 1:length(articles)
   a = articles{index};
   disp(['analyzing file ' a]); 
   AnalyzeArticlesFromFile(dict, fullfile(pth, a), results, a(1:end-4));
end
