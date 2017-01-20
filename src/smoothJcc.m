function smoothed = smoothJcc(vector, smoothingSize)
    % Smooths the points in vector using a rolling average of the
    % surrounding smoothingSize points, except for the
    % first floor(smoothingSize/2) points and the last
    % floor(smoothingSize/2) points. 
    % Jason Carlson's reimplementation of Matlab's smooth() function.
    % UTEP, January 2017

    oddvlen = length(vector);
    if mod(oddvlen,2) == 0
        oddvlen = oddvlen - 1;
    end
    
    smoothingSize = min([smoothingSize oddvlen]);
    smoothed = zeros(size(vector));
    
    csum = cumsum(vector);
       
    index = 1;
    for i = 1:2:smoothingSize
        smoothed(index) = csum(i)/i;       
        index = index + 1;
    end
    
    start = index;
    finish = length(vector) - floor(smoothingSize/2);
    
    %integral vector for speed
    if start <= finish
        smoothed(start:finish) = (csum(smoothingSize+1:end) - csum(1:(length(vector) - smoothingSize)))/smoothingSize;
    end
    
    index = finish + 1;
    for i = (length(vector) - smoothingSize + 2):2:(length(vector)-1)
        smoothed(index) = (csum(end) - csum(i))/(length(vector)-i);
        index = index + 1;
    end

end
