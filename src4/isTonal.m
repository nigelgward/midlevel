function istonal(coeff, fssfile, latent)
% Nigel Ward, UTEP and Kyto University, November 2015

% example use: 
%   findDimensions ...
%   load rotationspec
%   istonal(coeff, 'tonehunter.fss', latent) 

% outputs a best guess as to whether each dimension is
% mostly about tone, or mostly not 
%   if not, it's pragmatic, mixed tone+pragmatic, or noise

% a-priori likely to be tone-related are cases where 
% there's a lot of pitch-related variance concentrated in the area of one word
% that is, the loadings for pitch in that little area are high
% sum the square of the values of loadings for such features

  flist = getfeaturespec(fssfile);
  if length(flist) ~= length(coeff)
    fprintf('!!!looks like the wrong feature file\n');
  end
  for dim = 1:20 %dim=1:length(coeff)
    toneloadings = 0; tonecount = 0; % 64 total tonish features
    pragloadings = 0; pragcount = 0; % 96 total pragish features
    allloadings = 0;                 % 40 other features
    loadings = coeff(:,dim);
    for feat = 1:length(flist)
       if tonishFeature(flist(feat))
	 toneloadings = toneloadings + loadings(feat) * loadings(feat);
	 tonecount = tonecount+1;
       end
       if pragishFeature(flist(feat))
	 pragloadings = pragloadings + loadings(feat) * loadings(feat);
	 pragcount = pragcount+1;
       end
       allloadings = allloadings + loadings(feat) * loadings(feat);
    end 
    fprintf('dimension %2d (%.1f%%): tonal %.2f, prag %.2f, diff %.2f \n', ...
	    dim, 100 *latent(dim)/sum(latent), ...
	    toneloadings, pragloadings,  ...
	    toneloadings - pragloadings);
   end
end

function avg = avgsumsquare(vec)
  avg = sum(vec .* vec) / length(vec)
end

% three types of features:
% - tone-ish (pitch in a one-word area)
% - prag-ish (anything outside that area)
% - not sure (vo, cr, sr in that one-word area)

% tune to get agreement with data:
%    the word-related size (251ms, or more or less)
%    the weight on toneloadings - pragloadings


function tfeat = tonishFeature(thisfeature)
   inRange = thisfeature.startms > -251 && thisfeature.endms < 251;
   pitchRelated = ismember(thisfeature.featname, {'th', 'tl', 'np', 'wp'});
   % excludes vo, sr, cr
   tfeat = inRange && pitchRelated;
%   if tfeat
%     fprintf('%s %d is hot \n', thisfeature.featname, thisfeature.startms); 
%   end
end

function pfeat = pragishFeature(thisfeature)
   pfeat = thisfeature.startms < -301 || thisfeature.endms > 301;
end

