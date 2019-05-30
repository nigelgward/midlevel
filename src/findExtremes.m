function findExtremes(rotated, side, trackname, outdir, provenance)
% We often want to examine places which are very high or very low on some dimension.
% For each dimension this function finds such places and writes information to a file 
%
% rotated: 2D matrix containing dimensional values for each timepoint
% side: current side of track (l or r)
% trackname: current track name
% outdir: directory where the extremes-listing files will be written

% Paola Gallardo, UTEP, March 2015, modified by Nigel Ward, April 2015

[ntimepoints, ndimensions] = size(rotated);
nseconds = ntimepoints/100;
timestamps = 0.01:0.01:nseconds;     % 0.01 second (10-millisecond) timestamps
%Read only first 25 dimensions (or ndimensions if dimensions < 50)
dimensionsToWrite = min(25, ndimensions) ;
stddevs = std(rotated(:,1:dimensionsToWrite));  % per-track, not global, but okay

for dim=1:dimensionsToWrite
  filename = sprintf('dim%.2d.txt', dim);
  pathname = [outdir filename];   % outdir should already have been created
    if (exist(pathname, 'file' ) == 2)
      fid = fopen(pathname,'at');
    else
      fid = fopen(pathname,'w');
    end

    dimSlice = rotated(:,dim);
    maxIndices = indicesOfSeparatedMaxima(dimSlice);
    minIndices = indicesOfSeparatedMaxima(-1 * dimSlice);
 
    fprintf(fid, '%s\n', provenance);
    fprintf(fid, 'Low\n');
    writeExtrema(fid, minIndices, dim, ...
	   rotated, stddevs, timestamps, trackname, side);
    fprintf(fid, 'High\n');
    writeExtrema(fid, maxIndices, dim, ...
	   rotated, stddevs, timestamps, trackname, side);
    fclose(fid);
end  
end


% this could possibly be replaced with writeExtremesToFiles
function  writeExtrema(fid, indices, dim, rotated, stddevs, timestamps, trackname, side)
    numOfExtremesPerTrack = 10;
    for i = 1:numOfExtremesPerTrack;
     index = indices(i);
     actualValue = rotated(index, dim);
     time = timestamps(index);

     lineToWrite = sprintf('  %2d %.1f at %5.1f (%2d:%04.1f) in %s on %s ', ...
			   dim, actualValue, time, floor(time/60), mod(time,60),  ...
			   trackname, side);
     fprintf(fid, lineToWrite);
     writeSalientDims(fid, rotated(index,:), stddevs);
     fprintf(fid, '\n');
    end
end


%% if the current dimension value is not on this list, but other
%% dimensions are then this timepoint is a better example of something
%% else, than it is of this dimension
qfunction writeSalientDims(fid, values, stddevs)
  displayThreshold = 2.5;
  ndims = min(15, size(stddevs, 2));
  values = values(1:ndims);
  stddevs = stddevs(1:ndims);
  infoString = ' bigdims: ';
  salientIndices = abs(values) > displayThreshold * stddevs;
  
  for dim = 1:ndims
    if salientIndices(dim) 
      infoString = strcat(infoString, ' ', sprintf(' dim%2d %.1f ', dim, values(dim)));
    end
  end
  fprintf(fid, infoString);
end



