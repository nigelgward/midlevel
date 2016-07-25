function [flist, multimodalFlag] = getfeaturespec(crunchspec);
% from the crunchspec (features set specification file), 
% parse out the descriptions of what features we need
% and return that information as an array of structs

% Nigel Ward, 2014

% test with 'toyFiles/dummyCrunchSpec.fs'
% and with  'crunchspec.fs'

validFeatures = {'vo', 'ph', 'pr', 'sr', ...
		 'lp', 'hp', 'cr', 'fp', 'np', 'tp', 'wp', ...
		 'tl', 'th', ...
		 'rf', 'mi', 'ju'};
% vo = volume
% ph = (old) pitch height
% lp = low pitch 
% hp = high pitch 
% tl = truly-low pitch
% th = truly-high pitch 
% cr = creaky
% pr = (old) pitch range 
% fp = flat pitch
% np = narrow pitch 
% tp = typical pitch range
% wp = wide pitch 
% rf = running fraction
% mi = motion initiation count
% ju = jump count 

fprintf('reading %s\n', crunchspec);

multimodalFlag = false;
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
     feat = tline(1:2);
     validatestring(feat, validFeatures);
     if ismember(feat, ['rf', 'mi', 'ju'])
	multimodalFlag = true;
     end

     startms = str2num(tline(4:8));
     endms = str2num(tline(13:17));
     side = tline(19:22);

     duration = endms - startms;
     if (duration <= 0 || duration > 10000)
	duration
	printf('strange duration in getfeaturespec; check file format');
     end

     flist(fcounter).featname = feat;
     flist(fcounter).startms = startms;
     flist(fcounter).endms = endms;
     flist(fcounter).duration = duration;
     flist(fcounter).side = side;

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
