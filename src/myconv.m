% myconv.m

% like the standard convolution, except pad with zeros
% to trimwidth at beginning and end, to avoid artifacts

function result = myconv(vector, filter, filterHalfWidth)
  result = conv(vector, filter, 'same');
  trimWidth = floor(filterHalfWidth);
  result(1:trimWidth) = 0;
  result((end - trimWidth) : end) = 0;
end

