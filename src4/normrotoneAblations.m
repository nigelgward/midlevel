function rotated = ...
         normrotoneAblations(trackspec, featurelist, ...
		    nmeans, nstds, coeff, provenance, outdir)

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
         % now here we do the ablated versions
%         [npoints nfeatures] = size(normalizedff);
%         lastSelfFeature = 88;  % true for al_corrected.fss

%         selfZeroedFF = normalizedff;
%         selfZeroedFF(:, 1:lastSelfFeature) =  zeros(npoints, lastSelfFeature);
%         selfAblatedRotated = selfZeroedFF * coeff;

%         inteZeroedFF = normalizedff;
%         inteZeroedFF(:, lastSelfFeature+1:end) =  zeros(npoints, nfeatures - lastSelfFeature);
%         inteAblatedRotated = inteZeroedFF * coeff;

  % Write the final rotated features (aka factor values) as a .pc file, 
  trackcode = trackspec.side;     % either l or r
  aufilename = trackspec.filename;
  filecode = aufilename(1:length(aufilename) - 3);    % remove extension to g et, e.g. sw2105

  pcfile = [outdir '/' filecode  '-'  trackcode  '.pc'];
  pcheader = [provenance];
%  fprintf('writing to %s\n', pcfile);  % commented out since slow
%  writePcFileBis(pcfile, pcheader, rotated);  

  extremesDirectory = [outdir '/extremes/'];    % the directory was created in applynormrot
%  findExtremes(rotated, trackspec.side, trackspec.filename, extremesDirectory, provenance,selfAblatedRotated, inteAblatedRotated);   
  findExtremes(rotated, trackspec.side, trackspec.filename, extremesDirectory, provenance);   
  writeSummaryStats([filecode '-' trackcode], pcheader, rotated);  


