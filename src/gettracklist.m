function trackspecs = gettracklist(tlfile)
  %% Returns a cell array of trackspecs, where
  %%    each trackspec has: channel (left or right), filename, path, directory
  %% if tlfile is a directory, the trackspecs cover both left and right of every file there
  %% otherwise reads the listing of  audio files and channels from tlfile 

  %% Nigel Ward, UTEP, 2014-2020

  if isfolder(tlfile)
    trackspecs = createTrackspecs(tlfile);    % get all .au or .wav files in the directory
    return
  end


  fprintf('reading tracklist %s\n', tlfile);
  
  trackspecs = []; 
  trackindex = 1;
  directoryseen = false;
  
  fid = fopen(tlfile);
  if fid == -1
    fprintf('  Failed to open tracklist file %s!!\n', tlfile);
  end
  
  tline = fgets(fid);
  
  while ischar(tline)
    tline = deblank(tline);
    if isempty(tline)
      %% is an empty or whitespace-only line, so skip it 
    elseif tline(1) == '#'  
      %% is a comment line, so skip it
    elseif  directoryseen
      %% else process the line
      %       fields = strsplit(tline);
      fields = strread(tline, '%s', 'delimiter', ' ');
      sidecell = fields(1);
      trackspecs{trackindex}.side = sidecell{1};  % 'l' or 'r' 
      filenamecell = fields(2);
      trackspecs{trackindex}.filename = filenamecell{1};
      trackspecs{trackindex}.path = [directory filenamecell{1}];
      trackspecs{trackindex}.directory = directory;
      if length(fields) > 2
	spritecell = fields(3);
        trackspecs{trackindex}.sprite = spritecell{1}; % 'W' or 'F'
      end
      trackindex = trackindex + 1;
    else
      directory = tline;
      directoryseen = true;
    end
    %% process the next line
    tline = fgetl(fid);
  end
  fclose(fid);
end
