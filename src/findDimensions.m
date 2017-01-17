function findDimensions(tracklistFile, fsspecFile)

% this is one of the top-level functions

% test call:
%   findDimensions('../flowtest/singletrack.tl','../flowtest/minicrunch.fss')

% This is memory intensive: the princomp phase freezes my machine (6GB)
%  if more than about 200 features x 6 files x 2 sides x 10 minutes per file
% This is probably in the correlation-computing part of princomp,
%  so maybe the correlations could be computed piecewise 
% Anyway, for now, I fix this by downsampling to a sample every 20ms,
%  which lets me process twice as much; all's well

flist = getfeaturespec(fsspecFile);
trackspecs = gettracklist(tracklistFile);

totalMonster = makeMultiTrackMonster(trackspecs, flist);
if sum(sum(isnan(totalMonster))) > 0
  fprintf('NaN in totalMonster\n');
end


% downsample; convert from every 10ms to every 30ms to same time and space
totalMonster = totalMonster(3:3:end,:); 

tic
for col=1:length(flist)
  nmeans(col) = mean(totalMonster(:,col));
  nstds(col) = std(totalMonster(:,col));
  nmonster(:,col) = (totalMonster(:,col) - nmeans(col)) / nstds(col);
end
fprintf('  Time spent to normalize: ');
toc

cmatrix = corrcoef(totalMonster);
writeCorrelations(cmatrix, flist, './', 'correlations.txt');
fprintf('  starting Principal Components Analysis \n');


tic
[coeff, score, latent] = princomp(nmonster);  % mostly for the coeffs
[xsize ysize] = size(nmonster);
fprintf('  Time spent for princomp on a %d x %d array was : ', xsize, ysize);
toc 

rotation_provenance = ...
   sprintf('rotation generated from ''%s'', using features ''%s'', at %s ', ...
	   tracklistFile, fsspecFile, datestr(clock));

% write rotationspec.mat
save rotationspec nmeans nstds coeff latent rotation_provenance  ...
	flist fsspecFile;

fprintf('writing loadings\n');
% also write in human-readable format 
writeLoadings(coeff, flist, rotation_provenance, './'); 

end

