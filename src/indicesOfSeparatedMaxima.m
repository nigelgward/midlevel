function indices = indicesOfSeparatedMaxima(vec)
  % returns locations of 10 highly-valued and well-separated points
  % Nigel Ward, UTEP, 2015-2016
  % vec is some set of values associated with every 10ms timepoint

  minInterPeakDistance = 200;   % 2 seconds spacing
  numOfExtremesPerTrack = 10;
  indices = zeros(numOfExtremesPerTrack,1);  

  minvalue = min(vec);
  for j=1:numOfExtremesPerTrack    
    [maxvalue, maxindex] = max(vec);
    indices(j) = maxindex;   
    startErase= max(maxindex - minInterPeakDistance, 1);
    endErase  = min(maxindex + minInterPeakDistance, length(vec));
    vec(startErase:endErase) = minvalue * ones(endErase-startErase+1, 1);
  end 
end
