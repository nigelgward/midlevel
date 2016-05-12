function [subsetAverage] = averageOfNearValues(values, near_mean, far_mean)
% returns the averages of all points which are closer to the near mean
% than to the far mean

% to save time, approximate by taking a sample of 1000 values 
nsamples = 1000;
if length(values) < 1000
  samples = values;
else
  samples = values(1:round(end/nsamples):end);
end
closerSamples = samples(abs(samples - near_mean) < abs(samples - far_mean));
subsetAverage = mean(closerSamples);

end

% tested as part of the test of findClusterMeans 