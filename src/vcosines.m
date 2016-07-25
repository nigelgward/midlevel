function cosines = vcosines(refloadings, newloadings)

% Nigel Ward
% note that the loadings matrices are the coeffs returned by princomp,
% and as such, each column is the loadings for a component 

% note that this gives exactly the same result as
% refloadings' * newloadings, showing, I guess, that princomp
% returns loadings vectors all normalized to unit length

ndims = 25;
ndims = 8;

cosines = zeros(ndims, ndims);
for refdim = 1:ndims
  for newdim = 1:ndims
    cosines(refdim, newdim) = ...
	vectorCosine(refloadings(:, refdim), newloadings(:,newdim));
    end
  end
end

function cos = vectorCosine(vec1, vec2)
  cos = (vec1' * vec2) / (norm(vec1) * norm(vec2));
end