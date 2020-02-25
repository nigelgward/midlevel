%% for small-scale testing
%% more commonly, trackspecs will be read from a file, with gettrackspec.m

function trackspec = makeTrackspec(side, filename, directory)
  trackspec.side = side;
  trackspec.filename = filename;
  trackspec.directory = directory;
  trackspec.path = [directory filename];
end
