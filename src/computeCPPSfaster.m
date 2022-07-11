% COMPUTECPPSMODIFIED, Jonathan E. Avila July 2022
%This function modifies COMPUTECPSS to reduce
% the number of spectrogram windows computed by a factor of 5.
% This gives a 5x speedup, but does not give exactly the same results
%  as the original method. Visually it's pretty similar, and the correlations
%  are pretty good, typically aroung .95 for a one-minute file,
%  but they are lower for shorter files or files with many slices.
% Conclusion: use at your own risk. 
% The original author and copyright license are below.
%
% computeCPPS - calculate Smoothed Cepstral Peak Prominence (CPPS)
% Copyright (C) 2020 Marcin Włodarczak
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

function CPPS_midlevel = computeCPPSfaster(signal, sampleRate)

    midlevelFrameWidth_ms = 10;
	midlevelFrameWidth_s = midlevelFrameWidth_ms / 1000;
    signalDuration_s = length(signal) / sampleRate;
    signalDuration_ms = signalDuration_s * 1000;
    expectedCPPSmidlevelLen = floor(signalDuration_ms / midlevelFrameWidth_ms);

    %% Window analysis settings

    % Window size is increased to 48 ms and window step is increased to 10 
    % ms because computeCPPS.m is averaging five 40 ms windows with 2 ms
    % step size,
    %   (40 ms + 2 ms * (5 - 1)) = 48 ms.
    % With these changes the averaging step is no longer needed.
    win_len_s = 0.048;
    win_step_s = midlevelFrameWidth_s;
    win_len = round(win_len_s * sampleRate);
    win_step = round(win_step_s * sampleRate); 
    win_overlap = win_len - win_step;

    % Quefrency range
    quef_bot = round(sampleRate ./ 300);
    quef_top = round(sampleRate ./ 60);
    quefs = (quef_bot:quef_top)';

    %% Pre-emphasis from 50 Hz

    alpha = exp(-2 * pi * 50 / sampleRate);
    signal = filter([1, -alpha], 1, signal);

    %% Compute spectrum and cepstrum

    spec = spectrogram(signal, hanning(win_len), win_overlap);
    spec_log = 10 * log10(abs(spec).^2);
    ceps_log = 10 * log10(abs(fft(spec_log)).^2);

    %% Do time- and quefrency-smoothing

    % Smooth over 2 samples (20 ms) and 10 quefrency bins
    % The number of samples to smooth over is decreased by a factor of 5
    % since there are now 5 times fewer samples.
    smooth_filt_samples = ones(1, 2) / 2;
    smooth_filt_quef = ones(1, 10) / 10;
    ceps_log_smoothed = filter(smooth_filt_quef, 1, filter(smooth_filt_samples, 1, ceps_log')');

    %% Find cepstral peaks in the quefrency range
    ceps_log_smoothed = ceps_log_smoothed(quefs,:);
    [peak, peak_quef] = max(ceps_log_smoothed, [], 1);

    %% Get the regression line and calculate its distance from the peak
    n_wins = size(ceps_log_smoothed, 2);
    ceps_norm = zeros(1, n_wins);

    for n = 1:n_wins
      p = polyfit(quefs, ceps_log_smoothed(:, n), 1);
      ceps_norm(n) = polyval(p, quefs(peak_quef(n)));
    end

    cpps = peak - ceps_norm;

    %% Pad the CPPS vector and calculate means in 10-ms window
    % Add enough padding to cpps to match its expected length. Try to
    % distribute the padding evenly across the front and end of the vector.
    padSize = expectedCPPSmidlevelLen - length(cpps);
    prepadSize = floor(padSize / 2);
    postpadSize = padSize - prepadSize;
    cpps_padded = [nan(1, prepadSize), cpps, nan(1, postpadSize)];
    CPPS_midlevel = cpps_padded';
    %% replace NaNs with median CPPS
    CPPS_midlevel(isnan(CPPS_midlevel)) = median(CPPS_midlevel, 'omitnan');

    %% plot(CPPS_midlevel(1:1000))  %% debug 
end
