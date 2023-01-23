function percentiles = percentilizePitch(pitchPoints, maxPitch)

%% create a percentile vector to use as proxy for pitch values
%%  instead of each Hz value, use its percentile in the overall distribution
%%  thus this nonlinearly rescales the input
%% NaNs are preserved
%% accepts either a row vector or a column vector; returns a column vector
%
%% Nigel Ward and Paola Gallardo, UTEP, February 2014

%% the input pitchPoints ranges from 50 to about 515
%%  (even tho we ask the pitch tracker to compute only up to 500)
%% we map any points above 500 to NaN

rounded = round(pitchPoints);

% first we build up a histogram of the distribution
counts = zeros(1,maxPitch);  
for i = 1:length(rounded)
   pitch = rounded(i);
   if pitch <= maxPitch
     % it's in range and not a NaN
     counts(pitch) = counts(pitch) + 1;
   end
end


%% compute counts of pitches that are less than the specifized Hz value
cummulativeSum = cumsum(counts);
%% compute fraction of all pitches that are less than the specifized Hz value
mapping = cummulativeSum / cummulativeSum(maxPitch);

percentiles = zeros(length(rounded),1);
for i = 1:length(rounded)
   pitch = rounded(i);
   if pitch <= maxPitch
      percentiles(i) = mapping(pitch);
   else
      percentiles(i) = NaN;
   end
end

%% test case:
%%  percentilizePitch([1 2 3 1 1 1 3 1 5 14 2 3 NaN 5 6 3 5 7 1], 15)
