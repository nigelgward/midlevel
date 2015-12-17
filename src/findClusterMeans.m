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