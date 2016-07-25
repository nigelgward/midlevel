function indices = indicesOfSeparatedMaxima(vec)
  % returns locations of 10 highly-valued and well-separated points
  % Nigel Ward, UTEP, 2015-2016
  % vec is some set of values associated with every 10ms timepoint
  minInterPeakDistance = 200;   % 2 seconds spacing
  numOfExtremesPerTrack = 10;
  indices = ones(numOfExtremesPerTrack,1);

  for j=1:numOfExtremesPerTrack    
    [maxvalue, maxindex] = max(vec);
    if maxvalue > 0 
       indices(j) = maxindex;   % else leave it at one, as a flag for failure
    end 
    startErase= max(maxindex - minInterPeakDistance, 1);
    endErase  = min(maxindex + minInterPeakDistance, length(vec));
    vec(startErase:endErase) = zeros(endErase-startErase+1, 1);
  end 
end

