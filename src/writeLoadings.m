%% buggy; not useful
function writeLoadings(coeff, featuresCellArray, header, outdir)
  numberToWrite = min(length(coeff),12);
  lfd = fopen([outdir 'hrloadings.txt'], 'w');  % hr loadings = human-readable loadings
  fprintf(lfd, '%s\n', header);
  for col = 1:numberToWrite
    fprintf(lfd, '\n');
    for row = 1:length(coeff) %numberToWrite
      featureNameCell = featuresCellArray(row);
      fprintf(lfd, 'dimension%d  %5.2f  %s\n', ...
	      col, coeff(row,col), featureNameCell{1});
    end
  end
  fclose(lfd);
end
