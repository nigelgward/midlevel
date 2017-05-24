function vals = computeFeature()
   % a driver for makeTrackMonster.m, used for small-scale testing, 
   % Nigel Ward, May 2017, UTEP

%    trackspec = makeTrackspec('l', '1110Kbnd8pmFireUpdateRoosterRockFire.au', 'h:/nigel/tmp/');
%    featureList(1) = makeFeatureSpec('le', -800, -400, 'self', 0);
%    featureList(1) = makeFeatureSpec('vr', -800, -400, 'self', 0);
    trackspec = makeTrackspec('l', 'utep21.au', 'h:/nigel/comparisons/en-social/');
    featureList(1) = makeFeatureSpec('cr', -100, +100, 'self', 0);
    featureList(2) = makeFeatureSpec('cr', -500, +500, 'self', 0);
    featureList(3) = makeFeatureSpec('cr', -100, +100, 'inte', 0);
    featureList(4) = makeFeatureSpec('cr', -500, +500, 'inte', 0);

    [~, vecset] = makeTrackMonster(trackspec, featureList);
    % vals = vecset(:,1);
    writeExtremesToFile('highlyCreaky200.txt', vecset(:,1), vecset(:,1), ...
			'times of 200ms high creak', 'en-social/utep21.au left');
    writeExtremesToFile('highlyCreaky1000.txt', vecset(:,2), vecset(:,2), ...
			'times of 1s high creak', 'en-social/utep21.au left');

        writeExtremesToFile('highlyCreaky200.txt', vecset(:,3), vecset(:,3), ...
			'times of 200ms high creak', 'en-social/utep21.au right');
    writeExtremesToFile('highlyCreaky1000.txt', vecset(:,4), vecset(:,4), ...
			'times of 1s high creak', 'en-social/utep21.au right');


end
