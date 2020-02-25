%INPUTS
%timestruct: a struct array containing details of interesting times for each interaction session
            %each struct in the array contains a field called 'length' which holds the total time for each session 
%fieldname: the name of the field in the struct which contains the interesting times


% OUTPUT
%combinedtimes: a list containing all the interesting times as if they belong to one whole session

function combinedtimes = combinetimes(timestruct, fieldname)

    combinedtimes = [];
    prevendpoint = 0;  
    
    for i=1:size(timestruct, 2)
        interestingtimes = getfield(timestruct(i), fieldname);
        for j=1:size(interestingtimes, 1)
            combinedtimes = [combinedtimes;prevendpoint + interestingtimes(j)];
        end
        prevendpoint = prevendpoint + timestruct(i).length;
    end
    
end


%Hi Nigel,
%
% I created a short MATLAB function to combine the times of interesting
% frames over every session into one long list. Basically I think the
% best method is to first create a struct array. Using my function
% should convert the information in the struct array appropriately.
%
% To use it, you would have to modify seekpredictors.m and replace:
% interestingFrames = floor(times);
%
% with
% interestingFrames = combinetimes(times, field)
%
% with 'times' being the struct array (rather than a list of times for
% only one game) and 'field' being the name of the field containing
% interesting frame times.
%
% How you create the struct array is up to you and I guess depends on
% the application. You need the information of the interesting frame
% times and the length of each session.
%
% If you have any questions or find any problems with the code please let me know.