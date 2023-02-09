
%% This is like windowize(), but only considers frames tagged valid.
%% For windows with no such frames, regurn the overall mean
%% The primary use is to get mean values over only the speaking frames.

%% Nigel Ward, January 2023

function means = meansOverNonzeros2(featVec, isValid, frPerWindow, filler)
  integralImage = [0 cumsum(featVec)];
  integralIsValidCount = [0 cumsum(isValid)];
  windowSums = integralImage(1+frPerWindow:end) - ...
    	       integralImage(1:end-frPerWindow);
  windowDenominators = integralIsValidCount(1+frPerWindow:end) - ...
		       integralIsValidCount(1:end-frPerWindow);
  minRequired = validFramesNeeded(frPerWindow);
  windowDenominators(windowDenominators < minRequired) = 0;
  %%fprintf('lengths: featVec, isValid, windowSums, windowDenominators: %d %d %d %d\n', ...
  %% length(featVec), length(isValid), length(windowSums), length(windowDenominators));
  %% dbstop if error
  means = windowSums ./ windowDenominators
  means(isnan(means)) = filler   % unlikely
  means(isinf(means)) = filler   % common
  if frPerWindow > 1   % the normal case 
    headFramesToPad = floor(frPerWindow / 2) - 1;
    tailFramesToPad = ceil(frPerWindow / 2);
    headPadding = filler * ones(1,headFramesToPad);
    tailPadding = filler * ones(1,tailFramesToPad);
    means = horzcat(headPadding, means, tailPadding);
    means(isnan(means)) = filler;
    means(isinf(means)) = filler;
  end
end


%% This was added because scanning over timepoints where the values
%%  of some tilt feature were extreme revealed that these often were
%%  over windows that included only one isValid point, which often
%%  was in fact just a noise point.
%% To prevent that, we now report 0 as the value if there are too few
%%   isValid points to reliably compute the mean.
%% This function decides how many isValid points are needed. 
%% But, as a special case, if the fss file specifies a window size 
%%   less than 50 ms, the user has presumably decided to accept the
%%   risk of unreliability, so this function cooperates, by allowing
%%   only single valid point to be enough to compute the mean 
function minRequired = validFramesNeeded(frPerWindow)
  if frPerWindow < 5
    minRequired = 1
  elseif frPerWindow < 10
    minRequired = 2
  else
    minRequired = 3
  end
end



%%test with
%% meansOverNonzeros([9 8 7 1 2 3 9 6 6], [1 1 1 0 0 0 1 0 0], 1, 99)
%% meansOverNonzeros([9 8 7 1 2 3 9 6 6], [1 1 1 0 0 0 1 0 0], 2, 99)
%% meansOverNonzeros([9 8 7 1 2 3 9 6 6], [0 0 0 1 1 1 0 1 0], 1, 99)
