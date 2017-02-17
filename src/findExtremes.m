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
%Read only first 50 dimensions (or ndimensions if dimensions < 50)
dimensionsToWrite = min(50, ndimensions) ;

%set up working-copy matrices to find local max and min values in rotated

for dim=1:dimensionsToWrite
  filename = sprintf('dim%.2d.txt', dim);
  pathname = [outdir filename];   % outdir should already have been created
    if (exist(pathname, 'file' ) == 2)
      fid = fopen(pathname,'at');
    else
      fid = fopen(pathname,'w');
    end

    dimslice = rotated(:,dim);
    dimsliceForMax = dimslice;
    dimsliceForMin = -1 * dimslice;
      
    maxIndices = indicesOfSeparatedMaxima(dimsliceForMax);
    minIndices = indicesOfSeparatedMaxima(dimsliceForMin);
 
    fprintf(fid, '%s\n', provenance);
    fprintf(fid, 'Low\n');
    writeExtrema(fid, minIndices, dim, ...
	   rotated, timestamps, trackname, side);
    fprintf(fid, 'High\n');
    writeExtrema(fid, maxIndices, dim, ...
	   rotated, timestamps, trackname, side);
    fclose(fid);
end  
end


% this could possibly be replaced with writeExtremesToFiles
function  writeExtrema(fid, indices, dim, rotated, timestamps, trackname, side)
    numOfExtremesPerTrack = 10;
    for i = 1:numOfExtremesPerTrack;
     index = indices(i);
     actualValue = rotated(index, dim);
     time = timestamps(index);

     lineToWrite = sprintf('   %d %.2f at %6.2f (%2d:%05.2f) in %s on %s\n', ...
			   dim, actualValue, time, floor(time/60), mod(time,60),  ...
			   trackname, side);
     fprintf(fid, lineToWrite);
    end
end



