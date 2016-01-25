function diagramDimensions2(rotationspecfile, fssfile)
% makes loadings plots for each dimension and saves them to files
%   in the loadingplots subdirectory of the current directory
% typical call: diagramDimensions2('../rotationspec.mat');

% Nigel Ward,  UTEP, May 2015


  % get coeff, fsspecFile, rotation_provenance, saved earlier by findDimensions
  load(rotationspecfile);    
  % old rotationspec files may lack fsspecFile
  if exist('fsspecFile') && ~strcmp(fssfile,fssspecFile)
    fprintf('using featurespec file from rotationspec, rathre than %s\n', ...
	    fssfile);
    fssfile = fsspecfFile
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

  for dim = 1:min(40,length(coeff))
    for side = -1:2:1
       if side == -1
         filename = sprintf('%s/dim%02dlo', directoryName, dim);
    	 titleString = sprintf('dimension %2d low', dim);
      else
         filename = sprintf('%s/dim%02dhi', directoryName, dim);
    	 titleString = sprintf('dimension %2d high', dim);
      end
      patvis(side * coeff(:,dim), fssfile, ...
	     titleString, true, rotation_provenance');
      set(gcf, 'PaperPositionMode', 'auto');
      saveas(gcf, filename, 'png');
    end
  end
end

