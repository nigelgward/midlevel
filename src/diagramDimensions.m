function diagramDimensions(rotationspecfile, fssfile)
% makes loadings plots for each dimension and saves them to files
%   in the loadingplots subdirectory of the current directory
% typical call: diagramDimensions('rotationspec.mat');

% Nigel Ward,  UTEP, May 2015

  % get coeff, fsspecFile, rotation_provenance, saved earlier by findDimensions
  load(rotationspecfile);    
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

  directoryName = 'loadingplots';
  if isdir(directoryName) == false
    mkdir(directoryName);
  else
     fprintf('warning: overwriting directory contents\n');
  end 
  sfp = fopen('source.txt', 'w');
  fprintf(sfp, 'plots for %s\n', rotation_provenance);
  fclose(sfp);

  plotspec = makeStdPlotspec();

  for dim = 1:min(30,length(coeff))
    for side =  -1:2:1
       if side == -1
         filename = sprintf('%s/dim%02dlo', directoryName, dim);
    	 titleString = sprintf('dimension %2d low', dim);
      else
         filename = sprintf('%s/dim%02dhi', directoryName, dim);
    	 titleString = sprintf('dimension %2d high', dim);
      end
      patvis2(titleString, side * coeff(:,dim), fssfile, plotspec, ...
	     -1700, 1700);
      set(gcf, 'PaperPositionMode', 'auto');
      saveas(gcf, filename, 'png');
    end
  end
end
