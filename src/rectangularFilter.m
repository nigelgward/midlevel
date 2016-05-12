function filter = rectangularFilter(windowDurationMs)
  durationFrames = floor(windowDurationMs / 10);
  filter = ones(durationFrames, 1) / durationFrames;
end
