classdef TestDictionaryEntry < matlab.unittest.TestCase
    % TestDictionaryEntry tests the dictionary entry class
    
    methods (Test)
        
        function testMatchNoWildCards(testCase)
            % testMatchNoWildCards test case for matches function without
            % wildcard characters
            de = DictionaryEntry('test1', {'a', 'apple'});
            testCase.verifyTrue(de.matches('a'));
            testCase.verifyTrue(de.matches('apple'));
            testCase.verifyTrue(de.matches('Apple'));
            testCase.verifyTrue(de.matches('apPle'));
            testCase.verifyFalse(de.matches('b'));
            testCase.verifyFalse(de.matches('appl'));
        end
        
        function testMatchWithWildCards(testCase)
            % testMatchNoWildCards test case for matches function with
            % wildcard characters
            de = DictionaryEntry('test1', {'a*', 'apple', 'ccc*'});
            testCase.verifyTrue(de.matches('a'));
            testCase.verifyTrue(de.matches('A'));
            testCase.verifyTrue(de.matches('apple'));
            testCase.verifyTrue(de.matches('apPle'));
            testCase.verifyFalse(de.matches('b'));
            testCase.verifyTrue(de.matches('appl'));
            testCase.verifyTrue(de.matches('apPl'));
            testCase.verifyFalse(de.matches(''));
            testCase.verifyFalse(de.matches('c'));
            testCase.verifyFalse(de.matches('cc'));
            testCase.verifyTrue(de.matches('ccc'));
            testCase.verifyTrue(de.matches('cCc'));
            testCase.verifyTrue(de.matches('cccc'));
            testCase.verifyTrue(de.matches('cCcc'));
        end
        
        function testReadFromFile(testCase)
            % testReadFromFile test to read dictionary entries from an excel file
            entries = DictionaryEntry.readFromFile('../resources/test/testDictionary.xlsx');
            testCase.verifySize(entries,[1 3]);
            testCase.verifyEqual(entries(1).name, 'fruit');
            testCase.verifyEqual(entries(2).name, 'vegetable');
            testCase.verifyEqual(entries(2).words, {'carrot'});
            testCase.verifyEqual(entries(3).words, {'train', 'car'});
            testCase.verifyFalse(entries(3).matches('trains'));
            testCase.verifyTrue(entries(3).matches('cars'));
        end
        
        function testWriteHeader(testCase)
            % testWriteHeader tests the writeHeader method
            filepath = [tempname '.xlsx'];
            cleaner = onCleanup(@() delete(filepath));
            xlw = ExcelWriter(filepath);
            
            entries(4) = DictionaryEntry;
            entries(1).name = 'fr';
            entries(2).name = 'veg';
            entries(3).name = 'veh';
            entries(4).name = 'oth';
            
            DictionaryEntry.writeHeaderToExcel(xlw, entries, filepath, 1, 1, 1);
            xlw.delete();
            
            [~,~,raw] = xlsread(filepath,1);
            
            testCase.verifyEqual(raw, {'fr', 'veg', 'veh', 'oth'});
        end
    end
    
end
