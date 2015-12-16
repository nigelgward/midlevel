function writeSummaryStats(filename, header, matrix)

%% Used to find dimensions where a person is different from most. 
%% Could add an unmatched-pairs t-test to see significance.

%% To test this, run minitest using applynormrot.m, as described there.
%% Then look at the values for the various dimensions for the various tracks, 
%%  as output by this code to summary-stats.txt, 
%%  and see if they match up with common sense.  
%% For example, if one track has a high value on the first dimension,
%%   that track had better exhibit a lot of speech.
%% Results of inspection of minitest/loadings.txt:
%%   dimension 1: low = speaking little, high = speaking lots
%%   dimension 2: hi = spurts of speaking loud and fast for a second or two
%%   dimension 3: hi = wide pitch range in narrow windows
%% For validation, I  examined averages for minitest and difftest, 
%%   and then listened to the audio  to see whether the speakers 
%%   actually behave the way these stats would indicate.
%%   They invariably did. 

fd = fopen('summary-stats.txt', 'a');

fprintf(fd, '\nSummary statistics for track %s ', filename);
fprintf(fd, header);
fprintf(fd, '\n');

meanval = [];
meanabsval = [];
[height, width] = size(matrix);
dimensionsToWrite = min(50, width);

fprintf(fd, '\n              means:');
for col = 1:dimensionsToWrite
	meanval(col) = mean(matrix(:,col));
	fprintf(fd, ' %5.2f', meanval(col));
end

fprintf(fd, '\n  mean absolute vals:');
for col = 1:dimensionsToWrite       
	meanabsval(col) = mean(abs(matrix(:,col)));
	fprintf(fd, ' %5.2f', meanabsval(col));
end
fprintf(fd, '\n  rms values:');
for col = 1:dimensionsToWrite       
	rmsval(col) = rms(matrix(:,col));
	fprintf(fd, ' %5.2f', rmsval(col));
end

%fprintf('mean values are');
%disp(meanval);
%fprintf('mean absolute values are');
%disp(meanabsval);
%fprintf('rms values are');
%disp(rmsval);

