function findDimensions(tracklistFile, fsspecFile)

% this is one of the top-level functions

% test calls:
%   findDimensions('../minitest/singletrack.tl','../minitest/minicrunch.fss')
%   findDimensions('../minitest/minitracklist.tl','../minitest/minicrunch.fss')

flist = getfeaturespec(fsspecFile);
trackspecs = gettracklist(tracklistFile);

totalMonster = makeMultiTrackMonster(trackspecs, flist);
   
tic
for col=1:length(flist)
  nmeans(col) = mean(totalMonster(:,col));
  nstds(col) = std(totalMonster(:,col));
  nmonster(:,col) = (totalMonster(:,col) - nmeans(col)) / nstds(col);
end
fprintf('  Time spent to normalize: ');
toc

cmatrix = corrcoef(totalMonster);
writeCorrelations(cmatrix, flist, './', 'post-norm-corr.txt');
fprintf('  starting Principal Components Analysis ');

tic
[coeff, score, latent] = princomp(nmonster);  % mostly just want the coeffs
[xsize ysize] = size(nmonster);
fprintf('  Time spent for princomp on a %d x %d array was : ', xsize, ysize);
toc 

rotation_provenance = ...
   sprintf('rotation generated from ''%s'', using features ''%s'', at %s ', ...
	   tracklistFile, fsspecFile, datestr(clock));

% write rotationspec.mat
save rotationspec nmeans nstds coeff latent rotation_provenance, flist, fsspecFile;

% also write in human-readable format 
writeLoadings(coeff, flist, rotation_provenance, './'); 

end

