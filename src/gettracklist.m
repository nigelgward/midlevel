function trackspecs = gettracklist(file)
% From the file, gets information on which audio to process.
% Returns a cell array of trackspecs, 
%  where each trackspec is a channel spec, a path, etc.

% Nigel Ward, UTEP, 2014-2015

fprintf('reading tracklist %s\n', file);

trackspecs = []; 
trackindex = 1;
directoryseen = false;

fid = fopen(file);
if fid == -1
  fprintf('  Failed to open feature file %s!!\n', file);
end

tline = fgets(fid);

while ischar(tline)
%  disp(tline);
  tline = deblank(tline);
  if isempty(tline)
        % is an empty or whitespace-only line, so skip it 
  elseif tline(1) == '#'  
        % is a comment line, so skip it
  elseif  directoryseen
	% else process the line
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
  % process the next line
  tline = fgetl(fid);
end
fclose(fid);
