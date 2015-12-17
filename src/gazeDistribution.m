function binCounts = gazeDistribution()

% create a histogram of gaze angle

featurelist = getfeaturespec('gf0.fss');
trackfile = 'twelvetracks.tl';
%trackfile = 'twotracks.tl';
tracklist = gettracklist(trackfile);
featurevals = makeMultiTrackMonster(tracklist, featurelist); 
gazeDistance = featurevals(:,1);
for i = 1:25
   binstart = (i - 1) * 0.1;
   binend = i * 0.1;
   binCenters(i) = (binend + binstart) / 2;
   bincontents = gazeDistance(gazeDistance >= binstart & gazeDistance < binend);
   binCounts(i) = length(bincontents);
end
clf
plot(binCenters, binCounts);