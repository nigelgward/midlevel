function [ percentDifferenceVector ] = getDifferenceVector( pitchPoints,comparisonSize )
%Finds percent difference of each pair of points in given pitch vector

percentDifferenceVector = zeros(1,comparisonSize);
currentPoint = 1;
  
for i=1:size(pitchPoints,1)
   for j=i+1:size(pitchPoints,1)
      percentDifferenceVector(currentPoint) = abs((pitchPoints(i:i)-pitchPoints(j:j))/((pitchPoints(i:i)+pitchPoints(j:j))/2));
      currentPoint = currentPoint+1;
   end
end


end

