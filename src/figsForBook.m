function figsForBook()
% typical call: cd book/pbook-run; figsForBook();
% derived from diagramDimensions();

% Nigel Ward,  UTEP, July 2015

  ndims = 1;    %14;  % *****
  % get coeff, fsspecFile, rotation_provenance, saved earlier by findDimensions

  load('rotationspec');
  if exist('fsspecFile') 
    fssfile = fsspecFile;
    if nargin > 1 && ~strcmp(fssfile,fsspecFile)
      fprintf('note: using featurespec file from rotationspec, not %s\n', ...
	      fssfile);
    end
  else 
    % then it's a legacy rotationspec file that lacks fsspecFile
    if nargin < 2
       fprintf('please specify a featureset specification file (.fss file)\n');
    % else just use the second argument fssfile as the feature spec
    end 
  end

  directoryName = '../plotsForBook2';
  if isdir(directoryName) == false
    mkdir(directoryName);
  else
     fprintf('warning: overwriting contents of directory "%s"\n', directoryName);
  end 
  provenanceFilename = sprintf('%s/provenance.txt', directoryName);
  sfp = fopen(provenanceFilename, 'w');
  fprintf(sfp, 'plots for %s\n', rotation_provenance);
  fclose(sfp);

  featurespec = getfeaturespec(fssfile);
  figList = makeFigList();
  for i=1:length(figList)
    figInfo = figList{i};
    plotspec = expandToPlotspec(figInfo(4:end));
    plotnamecell = figInfo(1);
    plotname = plotnamecell{1};
    class(plotname);
    dimcell = figInfo(2);
    dim = dimcell{1};
    sidecell = figInfo(3);
    side = sidecell{1};
    
    patvis2(plotname, side * coeff(:,dim), ...
	    featurespec, plotspec, ...
	    -1700, 1700, rotation_provenance);
    ylim([0 300]);    % 300
    
    %% improve the x-axis labels
    set(gca, 'fontname', 'Arial');
    set(gca, 'fontsize', 9);
    set(gcf, 'PaperPositionMode', 'auto');
    saveas(gcf, [directoryName '/' plotname], 'png');
    saveas(gcf, [directoryName '/' plotname], 'pdf');
    %%  print(filename, '-dpdf');  % another way to save pdf plots 
  end 
end

function fig = makeFigList()
  fig =  {{'dim01lo', 1, -1, 'svo', 'sph', 'spr', 'sap', 'ivo'}, ...
	  {'dim02lo', 2, -1, 'svo', 'ivo'}, ...
	  {'dim02hi', 2,  1, 'svo', 'sph', 'spr', 'ivo', 'iph', 'ipr'}, ...
	  {'dim03hi-small', 3, 1, 'svo', 'sph', 'ivo', 'iph'}, ...  % for ch-revisited
	  {'dim03hi', 3, 1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo', ...
	   'iph', 'ipr', 'ile', 'icr', 'iap'}, ...
	  {'dim04lo', 4, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', ...
	   'spd', 'ivo', 'iph', 'ipr', 'ile', 'icr', 'iap', 'ipd'}, ...
	  {'dim05lo', 5, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', ...
	   'ivo', 'iph', 'ipr', 'ile', 'icr', 'iap'}, ...
	  {'dim05hi', 5,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'spd', 'sap'}, ...
	  {'dim06hi', 6,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo'}, ...
	  {'dim06lo', 6, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap'}, ...
	  {'dim07lo', 7, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'spd', 'sap'}, ...
	  {'dim07hi', 7,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'spd', 'sap'}, ...
	  {'dim08lo', 8, -1, 'svo', 'sph', 'spr', 'sle'}, ...
	  {'dim08hi', 8,  1, 'svo', 'sph', 'spr', 'sle', 'scr'}, ...
	  {'dim09lo'  9, -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo', ...
	   'iph', 'ipr', 'ile', 'icr', 'iap'}, ...
	  {'dim10lo', 10, -1, 'svo', 'sph', 'spr', 'spd'},...
	  {'dim10hi', 10,  1, 'svo', 'sph', 'spr', 'sle'},...
	  {'dim11hi', 11,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap'}, ... 
	  {'dim11lo', 11,  -1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap', 'ivo', 'iph', ...
	   'ipr', 'ile', 'icr', 'iap'}, ...
	  {'dim12lo', 12, -1, 'svo', 'sth', 'stl', 'swp', 'snp', 'sle', 'scr', 'sen', 'sre', ...
	   'ivo', 'ith', 'itl', 'iwp', 'inp', 'ile', 'icr', 'ien', 'ire'}, ...
	  {'dim12-lo-ph', 12, -1, 'sph'}, ...
	  {'dim12-lo-pr', 12, -1, 'spr'}, ...
	  {'dim14hi', 14,  1, 'svo', 'sph', 'spr', 'sle', 'scr', 'sap'}, ...
	 };
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
  

function fullspec = expandToPlotspec(lineCodes)

  %% takes a concise specification of a loadings plot, and expands
  %%   it to a full description, suitable for feeding to patvis2
  %% lineeCodes is an ordered list, of self features,
  %%   then optionally interlocutor features, e.g. svo, sph, ivo
  %% specifically, for each featuretype, adds a color, a ypos, and a linetype

  interlineSpacing = 16;
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
	ypos = ypos + 8; 
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
  ygain = 40; %25;
  ygain = 100;  %% temporary  for Dimension 1
  line = [sidecode, featurecode, lookupLabel(featurecode), ypos, ygain, gray, {linestyle}];
end
