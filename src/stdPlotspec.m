function ps = stdPlotspec()

% A specification for how patvis2 should behave.
% Since this is for normalized features,
%  all should have the same gain, 25.

  dustyPurple = [140/256 106/256 186/256];    
  darkGreen  = [127/256 190/256 92/256];     
  mexicanFlagRed = [206/256  17/256  38/256]; 
  mexicanFlagGreen = [  0/256 104/256 71/256];

  % side, feature type, label, ybaseline, ygain, color, linestyle
  % note that y = 0 is at the lower left
  ps  =[{'self'}, {'vo'}, {'Intensity'},  135, 25, dustyPurple, {'-'}; ...
	{'self'}, {'cr'}, {'Creakiness'}, 125, 25, dustyPurple, {'-'}; ...
	{'self'}, {'sr'}, {'S. Rate'},    115, 25, dustyPurple, {'-'}; ...
	{'self'}, {'ph'}, {'Pitch Height'},105, 25, dustyPurple, {'-'}; ...
	{'self'}, {'pr'}, {'Pitch Range'}, 95, 25, dustyPurple, {'-'}; ...
	{'self'}, {'le'}, {'Lengthening'}, 85, 25, dustyPurple, {'-'}; ...
	{'self'}, {'pd'}, {'Disalignment'},75, 25, dustyPurple, {'-'}; ...
	...
	{'inte'}, {'vo'}, {'Intensity'},   60, 25, darkGreen, {'-'}; ...
	{'inte'}, {'cr'}, {'Creakiness'},  50, 25, darkGreen, {'-'}; ...
	{'inte'}, {'sr'}, {'S. Rate'},     40, 25, darkGreen, {'-'}; ...
	{'inte'}, {'ph'}, {'Pitch Height'},30, 25, darkGreen, {'-'}; ...
	{'inte'}, {'pr'}, {'Pitch Range'}, 20, 25, darkGreen, {'-'}; ...
	{'inte'}, {'pd'}, {'Disalignment'},10, 25, darkGreen, {'-'}; ...
	{'inte'}, {'le'}, {'Lengthening'},  0, 25, darkGreen, {'-'}; ...
       ];
end
