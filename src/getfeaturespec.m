function flist = getfeaturespec(crunchspec);
% from the crunchspec (features set specification file), 
% parse out the descriptions of what features we need
% and return that information as an array of structs

% Nigel Ward, 2014

% test with 'toyFiles/dummyCrunchSpec.fs'
% and with  'crunchspec.fs'

validFeatures = {'vo', 'ph', 'pr', 'sr', ...
		 'lp', 'hp', 'cr', 'fp', 'np', 'wp', ...
		 'tl', 'th', 'vf', 'sf', 'cd', 'cb', 'le', ...
		 'rf', 'mi', 'ju', ...
		 'go', 'gf', 'ga', 'gl', 'gr', 'gu', 'gd', ...
		 'pd', 'le'};
% vo = intensity (volume)

% vf = voicing fraction
% sf = speaking fraction 

% ph = (old) pitch height
% lp = low pitch 
% hp = high pitch 
% tl = truly-low pitch 
% th = truly-high pitch 
% cr = creaky
% pr = (old) pitch range 
% fp = flat pitch
% np = narrow pitch 
% wp = wide pitch 

% cb = cepstral blandness (articulatory reduction)
% cd = cepstral distinctiveness (articulatory precision, enunciation)
% le = lengthening

% rf = running fraction
% mi = motion initiation count
% ju = jump count 
% go = gaze on or off (boolean)
% gu = gaze up
% gd = gaze down
% gl = gaze left
% gr = gaze right
% gf = gaze face  % old
% ga = gaze awayness (distance)
% pd = peak disalignment
% le = lengthening

fprintf('reading %s\n', crunchspec);

fid = fopen(crunchspec);
fcounter = 1;
tline = fgets(fid);
while ischar(tline);
  if isempty(deblank(tline)) 
     % is an empty or whitespace-only line, so skip it 
  elseif tline(1) == '#'  
     % is a comment line, so skip it
  else
    % process the line, painfully, because strread is uncooperative 
    % fields = strsplit(tline); % only in newer matlab
    fields = strread(tline, '%s', 'delimiter', ' ');
     featurecell = fields(1);
     feat = featurecell{1}; 
     validatestring(feat, validFeatures, 'getfeaturespec', tline);
     startcell = fields(2);
     startms = str2num(startcell{1});
     endcell = fields(4);
     endms = str2num(endcell{1});
     sidecell = fields(5);
     side = sidecell{1};  % 'self' or 'inte' 
     plotcolor = 0;  % default is not to plot it 
     if length(fields) > 5
        colorcell = fields(6);
        colorstring = colorcell{1};
	if ~strncmpi('#', colorstring, 1)  % it's not a comment
          plotcolor = colorstring;    % must be 'k', 'm', 'b', 'c', 'g', 'r', etc.
        end
     end
	
     duration = endms - startms;
     if (duration < 0 || duration > 10000)
	fprintf('strange duration %d in getfeaturespec; check file format', duration);
     end

     flist(fcounter).featname = feat;
     flist(fcounter).startms = startms;
     flist(fcounter).endms = endms;
     flist(fcounter).duration = duration;
     flist(fcounter).side = side;
     flist(fcounter).plotcolor = plotcolor; 

     if (startms >= 0)
       startcode = [' +' num2str(startms)];
     else 		    
       startcode = num2str(startms);
     end 
     if (endms >= 0)
       endcode = [' +' num2str(endms)];
     else 		    
       endcode = num2str(endms);
     end 
       
     % for example se-vo-100-50 or in-vo+100+200
     abbrev = sprintf('%s %s %s %s', side(1:2), feat, startcode, endcode);
     flist(fcounter).abbrev = abbrev;

     fcounter = fcounter + 1;
  end
  % process the next line
  tline = fgetl(fid);

end
