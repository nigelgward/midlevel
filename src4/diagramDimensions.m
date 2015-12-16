function diagramDimensions(coeff, fssfile)
  % saves plots to files
  % coeff is the projection-matrix coefficients, obtained with findDimensions
  %   and retrieved with load(rotationspec)
  % fssfile is the path of the featurespec file.  
  %   Must match the one used to generate coeff.  This info is also in rotationspec.
  % Nigel Ward,  UTEP, May 2015

  directoryName = 'loadingplots';
  if isdir(directoryName) == false
        mkdir(directoryName);
  end 

  for dim = 1:50
    for side = -1:2:1
       if side == -1
         filename = sprintf('%s/dim%02dlo', directoryName, dim);
    	 titleString = sprintf('dimension %2d low', dim);
      else
         filename = sprintf('%s/dim%02dhi', directoryName, dim);
    	 titleString = sprintf('dimension %2d high', dim);
      end
      patvis(side * coeff(:,dim), fssfile, titleString, true);
      set(gcf, 'PaperPositionMode', 'auto');
      saveas(gcf, filename, 'png');
    end
  end
end

% sample call ...   'april.fss',  ... 
