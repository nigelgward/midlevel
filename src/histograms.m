function histograms (refvals, l2vals)

% create a histogram for each dimension, to compare
% the learners' (l2) distribution to the natives' distribution
% reference values are blue, l2 values are orange

% refvals and l2vals are the output of applynormrot

for dim= 1:21

  hold off
  h1 = histogram(refvals(:,dim), 'BinWidth', 0.20, 'Normalization', 'probability',     'BinLimits', [-10 10]);
  hold on
  h2 = histogram(l2vals(:,dim), 'BinWidth', 0.20, 'Normalization', 'probability', 'BinLimits', [-10 10]);
  title(sprintf(' Dimension %d', dim)); 
  input ignore    % wait for the user to strike a key, then display next figure
end

