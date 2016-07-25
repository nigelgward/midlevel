function rotated = ...
         normrotoneAblations(trackspec, featurelist, ...
		    nmeans, nstds, coeff, provenance, extremesdir, pcfilesdir)

  % Nigel Ward, UTEP, April 2015
  % based on normrotone, modified to support the experiments in gaze prediction
  % and in prosody/action prediction using fewer features.
  fprintf('applying norm+rot+ablations to %s channel features for "%s" ... \n', ...
	   trackspec.side, trackspec.filename);

  [ignore, ff] = makeTrackMonster(trackspec, featurelist);
  normalizedff = [];  

  %normalize using rotationspec nmeans and nstds
  for col=1:length(featurelist)
     normalizedff(:,col) = (ff(:,col) - nmeans(col)) / nstds(col);
  end

  % now we have a normalized monster, and have created or looked up the rotation
  % so we actually do the rotation
  
  [fy, fx] = size(normalizedff);
  [cy, cx] = size(coeff);
  if (fx ~= cy)
     fprintf('features in normalizedff ~= features in coeff: %d ~=%d', fx, cy);
	     fprintf('probably coeff in rotationspec is based on another .fss file\n');
  end

  rotated = normalizedff * coeff;

  runfast = false;
  if runfast 
     return
  end

  % Write the final rotated features (aka factor values) as a .pc file, 
  trackcode = trackspec.side;     % either l or r
  aufilename = trackspec.filename;
  filecode = aufilename(1:length(aufilename) - 3);    % remove extension to g et, e.g. sw2105

  pcfile = [pcfilesdir filecode  '-'  trackcode  '.pc'];
  pcheader = [provenance];
%  fprintf('writing to %s\n', pcfile);  % commented out since slow
%  writePcFileBis(pcfile, pcheader, rotated);  

  findExtremes(rotated, trackspec.side, trackspec.filename, ...
	       extremesdir, provenance);   
%  writeSummaryStats([filecode '-' trackcode], pcheader, rotated);  


