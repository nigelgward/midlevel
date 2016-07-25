function writeExtremesToFile(outfile, vec, provenance); 

  if (exist(outfile, 'file' ) == 2)
    fid = fopen(outfile, 'at');
  else
    fid = fopen(outfile, 'w');
  end

  ntimepoints = length(vec);
  nseconds = ntimepoints/100;
  timestamps = 0.01:0.01:nseconds;     % 0.01 second (10-millisecond) timestamps

  fprintf(fid, 'in %s, times of high misalignment: \n', provenance);
  maxIndices = indicesOfSeparatedMaxima(vec);
  for i = 1:length(maxIndices);
    index = maxIndices(i);
    actualValue = vec(index);
    time = timestamps(index);
    fprintf(fid, '  at %6.2fs, value is %.5f (at %2d:%05.2f) \n', ...
	    time, actualValue, floor(time/60), mod(time,60) );
    end
  fclose(fid);
end 
