function ps = midPlotspecSeparate()

% A specification for how patvis2 should behave.
% derived from stdPlotspec, augmented to handle all features in largest.fss

  dustyPurple = [130/256 96/256 176/256];    
  darkGreen  = [117/256 180/256 82/256];     
  mexicanFlagRed = [206/256  17/256  38/256]; 
  mexicanFlagGreen = [  0/256 104/256 71/256];
  skRed  = [216/256  17/256  20/256]; 
  skBlue = [  10/256 20/256 240/256];
  gray = [.4 .4 .4];

  % side, feature type, label, ybaseline, ygain, color, linestyle
  % note that y = 0 is at the lower left
  ps  =[{'self'}, {'vo'}, {'Intensity'},  235, 25, skRed, {'-'}; ...  
	{'self'}, {'th'}, {'Pitch Highness'},225, 25, gray, {'-'}; ...
	{'self'}, {'tl'}, {'Pitch Lowness'}, 215, 25, gray, {'-'}; ...
	{'self'}, {'wp'}, {'Pitch Width'},   205, 25, gray, {'-'}; ...
	{'self'}, {'np'}, {'Pitch Narrowness'}, 195, 25, gray, {'-'}; ...
	{'self'}, {'pd'}, {'Disalignment'},    185, 25, skRed, {'-'}; ...
	{'self'}, {'le'}, {'Lengthening'},    175, 25, skRed, {'-'}; ...
	{'self'}, {'cr'}, {'Creakiness'}, 165, 25, gray, {'-'}; ...
	{'self'}, {'sr'}, {'Energy Flux'},155, 25, skRed, {'-'}; ...
	{'self'}, {'ap'}, {'Articu. Prec.'},145, 25, skRed, {'-'}; ...
	{'self'}, {'en'}, {'Enunciation.'},135, 25, skRed, {'-'}; ...
	{'self'}, {'re'}, {'Reduction'}, 125, 25 skRed, {'-'}; ...
		
		...
	{'inte'}, {'vo'}, {'Intensity'},  110, 25, skBlue, {'-'}; ...
	{'inte'}, {'th'}, {'Pitch Highness'},100, 25, gray, {'-'}; ...
	{'inte'}, {'tl'}, {'Pitch Lowness'}, 90, 25, gray, {'-'}; ...
	{'inte'}, {'wp'}, {'Pitch Width'},   80, 25, gray, {'-'}; ...
	{'inte'}, {'np'}, {'Pitch Narrowness'}, 70, 25, gray, {'-'}; ...

	{'inte'}, {'pd'}, {'Disalignment'},60, 25, skBlue, {'-'}; ...
	{'inte'}, {'le'}, {'Lengthening'}, 50, 25, skBlue, {'-'}; ...
	{'inte'}, {'cr'}, {'Creakiness'},  40, 25, gray, {'-'}; ...
	{'inte'}, {'sr'}, {'Energy Flux'}, 30, 25, skBlue, {'-'}; ...
	{'inte'}, {'en'}, {'Enunciation.'},30, 25, skRed, {'-'}; ...
	{'inte'}, {'re'}, {'Reduction'},  10, 25 skRed, {'-'}; ...


       ];
end
