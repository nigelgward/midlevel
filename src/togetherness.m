function avgsAtExtremes =  togetherness(allRotated)

% Nigel Ward, UTEP, April 2015

% For each dimension's extreme highs and extreme lows,
%  return the averages of other dimensions' values at those points.
% Each row of avgsAtExtremes starts with a dimension-side indicator
%  for example -8 for the low side of dimension 8, then the averages
%  for all dimensions (including 8)
% This function is to test a hunch:
% I suspect that non-natives and natives combine patterns differently.  
% For example, at points high on dimension 8, perhaps non-natives are 
%  often also high on dimension 4, but natives are low on that dimension.
% First we run this for the natives,  and print it out,
%  then for the non-natives and print it out; then eyeball the two 
% this should come after applynormrot, as described in ../histo/README.txt

  nExtremes = 20;  % have tried from 20 to 1000
  ndims = 20;
  nOtherDims = 20;
  avgsAtExtremes = zeros(ndims * 2, 1+nOtherDims);

  fd = fopen('togetherness.txt', 'w');

  for dim = 1:20
    for direction = -1:2:1    % first do -1 (low) then +1 (high)
       er = extremeRows(allRotated, dim, nExtremes, direction);
       avgs = mean(er);
       stds = std(er);
       if direction == -1 
         fprintf(fd, '\n\nfor dimension %d lo avgs, stds:', dim);
	 avgsAtExtremes(dim*2-1,:) = [direction * dim      avgs(1:nOtherDims)];
       else
         fprintf(fd, '\n\nfor dimension %d hi avgs, stds:', dim);	   
	 avgsAtExtremes(dim*2-0,:) = [direction * dim      avgs(1:nOtherDims)];
       end
       for otherdim = 1:20    
            fprintf(fd, '%2d %4.1f (%4.1f), ', otherdim, avgs(otherdim), stds(otherdim));
       end

    end 
  end
  fprintf(fd, '\n');
  fclose(fd);
end


% This doesn't explicitly ensure the extremes found have diversity over speakers 
%  but in practice that is the case
% direction = 1 means we want the max values, direction = -1 means min 
function extremeRows = extremeRows(allRotated, dimension, npoints, direction)
  extremeRows = [];
  for i = 1:npoints
    if direction == 1
      [extrVal, extrIndex] = max(allRotated(:,dimension));
    else 
      [extrVal, extrIndex] = min(allRotated(:,dimension));
    end 
    extremeRows = vertcat(extremeRows, allRotated(extrIndex,:));   % append it

    % zero out this guy so we don't find it again
    allRotated(extrIndex, dimension) = 0;

    % to obtain  diversity over timepoints, zero out also the neighbors 
    minInterPeakDistance = 200;   % 200 frames = 2 seconds spacing
    startErase= max(extrIndex - minInterPeakDistance, 1);
    endErase  = min(extrIndex + minInterPeakDistance, length(allRotated));
    allRotated(startErase:endErase, dimension) = zeros(endErase-startErase+1, 1);  end
end


  
