function rotated = ...
         normrotone(trackspec, featurelist, multimodalFlag, ...
		    nmeans, nstds, coeff, provenance, outdir)
% Nigel Ward, UTEP, April 2015

  fprintf('applying norm+rot to %s channel features for "%s" ... \n', ...
	   trackspec.side, trackspec.filename);

  ff = makeTrackMonster(trackspec, featurelist, multimodalFlag);
  normalizedff = [];  

  %normalize using rotationspec nmeans and nstds
  for col=1:length(featurelist)
     normalizedff(:,col) = (ff(:,col) - nmeans(col)) / nstds(col);
  end

  % now we have a normalized monster, and have created or looked up the rotation
  % so we actually do the rotation
  rotated = normalizedff * coeff;


  % Write the final rotated features (aka factor values) as a .pc file, 
  trackcode = trackspec.side;     % either l or r
  aufilename = trackspec.filename;
  filecode = aufilename(1:length(aufilename) - 3);    % remove extension to g et, e.g. sw2105

  pcfile = [outdir  filecode  '-'  trackcode  '.pc'];
  pcheader = [provenance];
  fprintf('writing to %s\n', pcfile);
  writePcFileBis(pcfile, pcheader, rotated);  

  extremesDirectory = [outdir 'extremes/'];    % the directory was created in applynormrot
  findExtremes(rotated, trackspec.side, trackspec.filename, extremesDirectory, provenance);   
  writeSummaryStats([filecode '-' trackcode], pcheader, rotated);  