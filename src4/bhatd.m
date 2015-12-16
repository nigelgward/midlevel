function coef = bhatD(distribution1, distribution2)
% compute the Bhattacharyya distance between two distributions
% Nigel Ward, UTEP, February 2015
   coef = -log(sum(sqrt(distribution1 .* distribution2)));