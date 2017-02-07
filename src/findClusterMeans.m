function [lowCenter,highCenter] = findClusterMeans(values)

% Given a set of values that are, hopefully, bimodally distributed,
%  finds the centers of the two clusters by iterative search
% Used in particular to compute the silence  mean and speech mean for 
%  a set of energy values

maxIterations = 20;
previousLowCenter = min(values);
previousHighCenter = max(values);
convergenceThreshold = (previousHighCenter - previousLowCenter)/100;
for i=1:maxIterations
   highCenter = averageOfNearValues(values, previousHighCenter, previousLowCenter);
   lowCenter =  averageOfNearValues(values, previousLowCenter,  previousHighCenter);
   
   if((abs(highCenter - previousHighCenter) < convergenceThreshold) && ...
      (abs(lowCenter -  previousLowCenter)  < convergenceThreshold) )
     return;   
   end
   previousHighCenter = highCenter;
   previousLowCenter = lowCenter;  
end
warning('findClusterMeans exceeded maxIterations without converging');
end


% test cases
%  [a b] = findClusterMeans([1 2 3 2 3 2 3 2 3 2 3 4 6 7 6 7 6 7 6 7 1 9 0 6 6 3]);
%
% [r,s] = readtracks('/home/users/nigel/21d.au')
% e = computeLogEnergy(s(:,1)', 80);
% plot(1:length(e),e);

% [silence,speech] = findClusterMeans(e)
% silence does not end up at the noice floor, but somewhat above it,
% which is probably fine.


function [subsetAverage] = averageOfNearValues(values, near_mean, far_mean)
% returns the averages of all points which are closer to the near mean
% than to the far mean

% To save time, approximate by taking a sample of 2000 values.
% Note 1000 is faster, but A. Nath found that with only 1000 samples,
% this can fail in rare cases, for example when there is a lot of music,
% since that can cause the distribution to look unimodal.
nsamples = 2000;    
if length(values) < 2000
  samples = values;
else
  samples = values(1:round(end/nsamples):end);
end
closerSamples = samples(abs(samples - near_mean) < abs(samples - far_mean));
subsetAverage = mean(closerSamples);

end
