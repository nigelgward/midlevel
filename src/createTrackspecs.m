
function trackspecs = createTrackspecs(directory)
  %% Returns a cell array of trackspecs, where
  %%   each trackspec has: channel (left or right), filename, path, directory
  %% does this for both left and right tracks for all audio files in the directory,
  %% if .au files exist, use them, otherwise use the .wav files 

  %% Nigel Ward, UTEP, 2020, with corrections by Jonathan E. Avila

  fprintf('assembling tracklist for  %s\n', directory);
  
  trackspecs = []; 
  
  files = dir([directory '*.au']);
  if length(files) == 0
    files = dir([directory '*.wav']);
  end
    if length(files) == 0
    files = dir([directory '/*.au']);
  end  if length(files) == 0
    files = dir([directory '/*.wav']);
  end
  if length(files) == 0
    error('no .wav or .au files found ... wrong directory perhaps?');
    exit();
  end

  for i=1:length(files)
    filename = files(i).name;
    trackspecs = createOne('l', filename, directory, trackspecs);
    %% comment out the next line if the conversations are not symmetric
    %% for example, when the children are in the left tracks, and the adult in the right
    trackspecs = createOne('r', filename, directory, trackspecs);
  end
end


function trackspecs = createOne(side, file, dir, trackspecs);
  trackspecs{1+length(trackspecs)}.side = side;
  trackspecs{length(trackspecs)}.filename = file;
  trackspecs{length(trackspecs)}.directory = [dir '/'];
  trackspecs{length(trackspecs)}.path = [dir '/' file];
  return
end


  
  
  
