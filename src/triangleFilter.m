
% returns a filter to be convolved with a pitch-per-frame vector etc.
function filter = triangleFilter(windowDurationMs)
  durationFrames = floor(windowDurationMs / 10);
  center = floor(durationFrames / 2);
  for i = 1:durationFrames
     filter(i) = center - abs(i - center);
  end 
  filter = filter / sum(filter);   % normalize it to sum to one
end

