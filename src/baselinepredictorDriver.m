function baselinepredictorDriver(tlfile, featuresetSpec, ndims)
%% Saiful Abu and Nigel Ward, UTEP, May 2015

%% tests the ability of the linear regression model's ability of reconstruction
%% of partially obscured data, e.g. prediction of future features
%% from past only features 

%% To test
%%   1. cd isg/speech/watergirl/dimensions/
%%   2. reconstructionDriver('../justone.tl', 'dresden.fss');

load rotationspec   % get nmeans, nstds, and coeff, written by findDimensions.m
featurelist = getfeaturespec(featuresetSpec);
% clear statistics file, since we'll be appending to it; ok if this fails
% system('rm summary-stats.txt');   

tracklist = gettracklist(tlfile);

for filenum = 1:length(tracklist)
  trackspec = tracklist{filenum};
  fprintf('reconstructing  %s of %s ,\n using features %s %s at %s \n ', ...
      trackspec.side,  trackspec.filename, ...
      featuresetSpec, datestr(clock));
  baselinepredict(trackspec, featurelist, nmeans, nstds);
  end
end
