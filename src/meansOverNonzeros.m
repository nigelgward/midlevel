
%% This is like windowize(), but only considers frames tagged valid.
%% For windows with no such frames, regurn the overall mean
%% The primary use is to get mean values over only the speaking frames.

%% Nigel Ward, January 2023

function means = meansOverNonzeros(featVec, isValid, frPerWindow)
  integralImage = [0 cumsum(featVec)]
  integralIsValidCount = [0 cumsum(isValid)]
  windowSums = integralImage(1+frPerWindow:end) - ...
    	       integralImage(1:end-frPerWindow)
  windowDenominators = integralIsValidCount(1+frPerWindow:end) - ...
		       integralIsValidCount(1:end-frPerWindow)
  means = windowSums ./ windowDenominators;

  %% pad front and back; also replace NaNs

  globalMeanOfValids = mean(featVec(isValid==true));
  if frPerWindow > 1   % the normal case 
    headFramesToPad = floor(frPerWindow / 2) - 1  ;
    tailFramesToPad = ceil(frPerWindow / 2);
    headPadding = globalMeanOfValids * ones(1,headFramesToPad);
    tailPadding = globalMeanOfValids * ones(1,tailFramesToPad);
    means = horzcat(headPadding, means, tailPadding);
  means(isnan(means)) = globalMeanOfValids;
end 



%%test with
%% meansOverNonzeros([9 8 7 1 2 3 9 6 6], [1 1 1 0 0 0 1 0 0], 1)
%% meansOverNonzeros([9 8 7 1 2 3 9 6 6], [1 1 1 0 0 0 1 0 0], 2)
%% meansOverNonzeros([9 8 7 1 2 3 9 6 6], [0 0 0 1 1 1 0 1 0], 1)
