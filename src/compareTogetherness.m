
function compareTogetheness(togetherness1, togetherness2)

% Nigel Ward, UTEP, April 2015
% preparation: 
%  nattg = togetherness(nonvals)
%  nontg = togetherness(nonvals)
% natvals and nonvals are obtained by applynormrot
% The first column of togetherness1 is the dimension name

% for each pattern (dimesionx-hi or dimensionx-lo), 
%  we estimate the degree to which the non-natives and natives differ
%  in its use, by computing the different in averages of values of
%  other dimensions 

%  Our overall objective is to find ways in which natives and \
%      non-natives differ in their prosodic behavior.
%  We have noticed that for some dimensions, the typical behavior
%    on extremes sounds somehow different for natives and non-natives.
%  People tend to use several dimensions together, at any timepoint.
%  However, the combinations of dimension vary with the context etc.
 
%  We thought that perhaps these patterns of combination would differ
%  between natives and non-natives. 
%  For example, at points low on dimension 8 perhaps natives simultaneously
%  use dimension 3 high and dimension 11 high. 
  
%  As a way to automatically find something that correlates with 
%	  this difference,  
%      we looked at times where they exhibit extreme values on that dimension, 
%	  and looked at the pattern of use across the other dimensions,
%   then compared this between natives and non-natives. 
%  This gives, for each dimension, a measure of how different the native
%    and non-native behaviors are.
  
fd = fopen('dim-diffs.txt', 'w');
  fprintf(fd, 'Differences between Natives and Non-Natives, avgs on other dims for each extreme\n');
  fprintf(fd, '%s\n', datestr(clock));
  fprintf(fd, 'dim side\n');
  for i = 1:length(togetherness1)    % for each dimension
    diffvec = abs(togetherness1(i,2:end) - togetherness2(i,2:end));
    dist1 = sum(diffvec);
    dist2 = sqrt(diffvec * diffvec');
    fprintf(fd, '%3d:  %6.2f  \n', togetherness1(i), dist1);
    fprintf(fd, '%3d:  %6.2f (sum-squared) \n', togetherness1(i), dist2);
  end
end