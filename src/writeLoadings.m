function writeLoadings(coeff, featuresCellArray, header, outdir)
  numberToWrite = min(length(coeff),30);
  lfd = fopen([outdir 'loadings.txt'], 'w');
  fprintf(lfd, '%s\n', header);
  for col = 1:numberToWrite
    fprintf(lfd, '\n');
    for row = 1:numberToWrite
      featureNameCell = featuresCellArray(row);
      fprintf(lfd, 'dimension%d  %5.2f  %s\n', ...
	      col, coeff(row,col), featureNameCell{1});
    end
  end
  fclose(lfd);
end
