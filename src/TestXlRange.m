classdef TestXlRange < matlab.unittest.TestCase
    %TestXlRange tests for the xlRange function
    
    methods (Test)
        function testRange(testCase)
            range = xlRange(1,1,1,1);
            testCase.verifyEqual(range, 'A1:A1');
            
            range = xlRange(2,3,4,7);
            testCase.verifyEqual(range, 'B3:D7');
            
            range = xlRange(10,11,25,26);
            testCase.verifyEqual(range, 'J11:Y26');
        end
    end
end

