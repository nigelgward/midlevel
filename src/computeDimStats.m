function computeDimStats(travals, swivals, natvals, nonvals)

% Nigel Ward, June 2015
% the inputs are the massive sets of PC values, for all 176 dimensions
% for each of 4 sets: training data, switchboard, natives, non-natives

% the output is a latex-formatted table of 16 rows and 7 columns: 
%   dimension number 
%   switchboard mean and std devs, 
%   native means and std devs
%   non-native means and std devs

% for sanity, could check that mean(travals) is all zeros

trameans = mean(travals);   trastds = std(travals); 
natmeans = mean(natvals);   natstds = std(natvals);
nonmeans = mean(nonvals);   nonstds = std(nonvals); 
swimeans = mean(swivals);   swistds = std(swivals);

% normalize:
%   means are divided by training set stddev, so they are in units of standard dev
%   std devs are similarly divided
natmeans = natmeans ./  trastds;
nonmeans = nonmeans ./  trastds;
swimeans = swimeans ./  trastds;

natstds = natstds ./  trastds;
nonstds = nonstds ./  trastds;
swistds = swistds ./  trastds;

  fprintf('     switchboard       natives       non-natives\n');
  fprintf('dim  means stds       means stds      means stds \n');
for i = 1:30
  fprintf('%2d   %5.2f %5.2f      %5.2f %5.2f      %5.2f %5.2f \n', ...
	  i, swimeans(i), swistds(i), natmeans(i), natstds(i), nonmeans(i), nonstds(i));
end


end



