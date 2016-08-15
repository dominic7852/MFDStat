function [ range ] = xlRange( col1, row1, col2, row2 )
%XLRANGE creates an Excel style cell range from the supplied indicies
%   Creates an Excel range from the numeric arguments 
%   e.g. xlRange(2,3,4,7) > B3:D7
%range - the Excel range string (e.g. B3:D7)
range = [xlcolumnletter(col1),num2str(row1),':',xlcolumnletter(col2),num2str(row2)];
end

function colLetter = xlcolumnletter(colNumber)
% xlcolumnletter converts a column number to an Excel column letter.
% only works up to column Z
%atoz - stores letters A-Z from function char
%letters - letters A-Z as a cell array
%colLetter - the letter for the column index

%  A-Z letters
atoz = char(65:90)';

% convert to cell array
letters = cellstr(atoz);

% Return requested column
colLetter = letters{colNumber};
end