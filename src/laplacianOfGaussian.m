% Laplacian of Gaussian
% Nigel Ward, University of Texas at El Paso and Kyoto University
% January 2016

% This is to be used for peak spotting.

function vec = laplacianOfGaussian(sigma)

  % if longer, slows things down a little in the subsequent convolution
  % if shorter, insufficient consideration of local context to see if it's a real peak 
  length = sigma * 5;   

  sigmaSquare = sigma * sigma;
  sigmaFourth = sigmaSquare * sigmaSquare;

  vec = zeros(1, length);
  center = floor(length / 2);
  for i = 1:length
     x = i - center;
     y = ((x * x) / sigmaFourth - 1 / sigmaSquare) * ...
	 exp( (-x * x) / (2 * sigmaSquare));
     vec(i) = - y;
  end
end

% test
% x = rand(1,200);
% x(30:35) = 1;
% x(32) = 2;
% x(70:80) = 3;
% vec = lapacianOfGaussian(8);
% c = conv(x, vec, 'same');
% plot(1:200, c);

%% to make a pretty picture
%% vec = laplacianOfGaussian(100);
%% plot( (-249:250)/250, vec * 10000)
%% axis([-1 1 -0.6 1.1])
