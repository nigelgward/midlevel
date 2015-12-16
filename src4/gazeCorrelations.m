function gazeCorrelations()

% Nigel Ward, University of Texas at El Paso, May 2015

% intended to be run from the directory isg/speech/gaze/singapore
% addpath('../../ppca/src4')
% addpath('../../ppca/voicebox')
% gazeCorrelations()

fssfile = '../../ppca/src4/eyemouth.fss';  
%fssfile = 'gazefive.fss';
featurelist = getfeaturespec(fssfile);
%trackfile = 'twotracks.tl';
trackfile = 'twelvetracks.tl';
tracklist = gettracklist(trackfile);

trainingData = makeMultiTrackMonster(tracklist, featurelist);
fprintf('overall gaze-on percentage: %.3f\n', ...
	sum(trainingData(:,1) /length(trainingData(:,1))));

for col=1:length(featurelist)
  nmeans(col) = mean(trainingData(:,col));
  nstds(col) = std(trainingData(:,col));
  normedData(:,col) = (trainingData(:,col) - nmeans(col)) / nstds(col);
end
[r,p] = corrcoef(trainingData);
significance = (p / (length(featurelist) - 1)) < 0.05;
fid = fopen('gz-corr.txt', 'w');
fprintf('\nCorrelations for %s using features %s\n', trackfile, fssfile);
for i=1:length(featurelist)
  fprintf(' %5.2f     %d %s\n', ...
	  r(1,i), significance(1,i), featurelist(i).abbrev );
end


