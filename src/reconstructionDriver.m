function reconstructionDriver(tlfile, featuresetSpec, ndims)
%% Nigel Ward, UTEP, March 2015

%% tests the ability of the dimensions to enable reconstruction
%% of partially obscured data, e.g. prediction of future features
%% from past only features 

%% To test
%%   1. cd isg/speech/watergirl/dimensions/ (or c:/nigel/watergirl/dimensions)
%%   2. reconstructionDriver('justone.tl', 'dresden.fss', 3);

load rotationspec   % get nmeans, nstds, and coeff, written by findDimensions.m
featurelist = getfeaturespec(featuresetSpec);
% clear statistics file, since we'll be appending to it; ok if this fails
% system('rm summary-stats.txt');   

tracklist = gettracklist(tlfile);

for filenum = 1:length(tracklist)
  trackspec = tracklist{filenum};
  fprintf('reconstructing  %s of %s ,\n using features %s and\n rotation %s at %s \n ', ...
      trackspec.side,  trackspec.filename, ...
      featuresetSpec, rotation_provenance, datestr(clock));
  reconstruct(trackspec, featurelist, nmeans, nstds, coeff, ndims);
  end
end
