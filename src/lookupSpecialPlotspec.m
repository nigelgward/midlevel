function ps = lookupSpecialPlotspec(dim, side, defaultPlotspec)
%% this function is used to customize the behavior of diagram-dimensions
%% soon to be obsolete, replaced by figsForBook.m

%% Nigel Ward,  UTEP, Jan 2018

                 % for ch-revisited ...
		 % {3, 1, 'svo', 'sph'},...


  %% for some dimension-sides, we want a plot showing only some features
  specials = {{1, -1, 'svo', 'sph', 'spr', 'sap', 'ivo'}, ...
	      {2, -1, 'svo', 'ivo'}, ...
	      {2,  1, 'svo', 'sph', 'spr', 'ivo', 'iph', 'ipr'}, ...
	      {4, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'spd'...
	       'ivo', 'iph', 'ipr', 'ile', 'icr', 'iap', 'ipd'}, ...
	      {5, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', ...
	       'ivo', 'iph', 'ipr', 'ile', 'icr', 'iap'}, ...
	      {5,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'spd', 'sap'}, ...
	      {6,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo'}, ...
	      {6, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap'}, ...
	      {7, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'spd', 'sap'}, ...
	      {7,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'spd', 'sap'}, ...
	      {8, -1, 'svo', 'sph', 'spr', 'sle'}, ...
	      {8,  1, 'svo', 'sph', 'spr', 'sle', 'scr'}, ...
	      {9, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo', ...
	       'iph', 'ipr', 'ile', 'icr', 'iap'}, ...
	      {10, -1, 'svo', 'sph', 'spr', 'spd'},...
	      {10,  1, 'svo', 'sph', 'spr', 'sle'},...
	      {11,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap'}, ... 
	      {11,  -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo', 'iph', ...
	       'ipr', 'ile', 'icr', 'iap'}, ...
	      {12, -1, 'svo', 'sth', 'stl', 'swp', 'snp', 'sle', 'scr', 'sen', 'sre', ...
	       'ivo', 'ith', 'itl', 'iwp', 'inp', 'ile', 'icr', 'ien', 'ire'}, ...
	      {14,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap'}, ...
	      {3, 1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo', ...
	       'iph', 'ipr', 'ile', 'icr', 'iap'}, ...

	     };

%	      {3,  1, 'svo', 'sph', 'ivo', 'iph'}, ...  % for ch-revisited
%	      {12, -1, 'sph'}, ...
%             {12, -1, 'sph'}, ...

  
  % for the intensity-only plot
%  specials = {{1, 1, 'svo', 'ivo'}, ...
%	      {2, 1, 'svo', 'ivo'}, ...
%	      {3, 1, 'svo', 'ivo'}, ...
%	      {4, 1, 'svo', 'ivo'}, ...
%	      {5, 1, 'svo', 'ivo'}, ...
%	      {6, 1, 'svo', 'ivo'}, ...
%	      {7, 1, 'svo', 'ivo'}, ...
%	      {30, 1, 'svo', 'ivo'}, ...
%	      {31, 1, 'svo', 'ivo'}, ...
%	      {32, 1, 'svo', 'ivo'}, ...
%	     };

  for i = 1:length(specials)
    special = specials{i};
    if (special{1} == dim && special{2} == side)
      %%fprintf('found special plotspec for %d %d\n', dim, side);
      ps = expandToPlotspec(special(3:end));
      %%display(ps)
      return
    end
  end
  ps = defaultPlotspec;
  return 
end
  

function fullspec = expandToPlotspec(lineCodes)

  %% takes a concise specification of a loadings plot, and expands
  %%   it to a full description, suitable for feeding to patvis2
  %% lineeCodes is an ordered list, of self features,
  %%   then optionally interlocutor features, e.g. svo, sph, ivo
  %% specifically, for each featuretype, adds a color, a ypos, and a linetype

  interlineSpacing = 14;
  fullspec = cell(length(lineCodes),7);
  linecount = 1;
  ypos = 11;   % start at the bottom and work up 
  inteFeaturesSeen = false;
  firstSelfFeatureSeen = false;

  for ix = length(lineCodes):-1:1   % start at the bottom and work up 
    linecode = lineCodes{ix};
    sidecode = linecode(1);      % speaker code: s for speaker, i for interlocutor
    featurecode = linecode(2:3); % two-letter feature code
    
    isInteFeature = strcmp(sidecode, 'i');
    if (isInteFeature)
      inteFeaturesSeen = true;
      sideString = {'inte'};
      linestyle = '-.';
    else 
      sideString = {'self'};
      linestyle = '-';
      if ( ~firstSelfFeatureSeen && inteFeaturesSeen)
	%% place a gap between the interlocutor and self features
	ypos = ypos + 5; 
	firstSelfFeatureSeen = true;
      end
    end
    line = makeLine(sideString, linestyle, featurecode, ypos);
    for i=1:7
      fullspec(linecount,i) = {line{i}};
    end
    ypos = ypos + interlineSpacing;
    linecount = linecount + 1;
  end
end


function line = makeLine(sidecode, linestyle, featurecode, ypos)
  gray = [.02, .00, .01];
  ygain = 25;
  %%    ygain = 75;  %% temporary  for Dimension 1
  line = [sidecode, featurecode, lookupLabel(featurecode), ypos, ygain, gray, {linestyle}];
end


function label = lookupLabel(abbreviation)
  labelList = [{'vo'}, {'Intensity'};
	       {'ph'}, {'Pitch Height'};
	       {'pr'}, {'Pitch Range'};
	       {'le'}, {'Lengthening'};
	       {'cr'}, {'Creakiness'};
	       {'pd'}, {'Disalignment'};
	       {'ap'}, {'Articu. Prec.'};
	       
	       {'th'}, {'P.Highness'},
	       {'tl'}, {'P.Lowness'},
	       {'wp'}, {'P.Wideness'},
	       {'np'}, {'P.Narrowness'},
	       {'en'}, {'Enunciation'},
	       {'re'}, {'Reduction'},
	      ];

  for i= 1:length(labelList)
    if strcmp(labelList(i, 1), abbreviation)
      label = labelList(i,2);
      return
    end
  end
  fprintf('in lookupLabel: ''%s'' is not a known featurecode \n', abbreviation);
  fprintf('   so instead of a label, returning just that code\n');
  label = abbreviation;
end
  
