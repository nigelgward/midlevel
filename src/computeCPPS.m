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

function [CPPS_midlevel] = computeCPPSmodifiedOld(signal, sampleRate)

    % NOTE: This function modifies computeCPPS.m so that the length of
    % CPPS_midlevel is the expected length (so that each column represents
    % 10 ms). For the improved version, see computeCPPSmodified.m.

    %% Window analysis settings
    
    s_len = length(signal);

    % Window size and step
    win_step_s = 0.002; % Step size in seconds
    win_len = round(0.04 * sampleRate);
    win_step = round(win_step_s * sampleRate); 
    win_overlap = win_len - win_step;

    % Size of the midlevel analysis window
    mid_win_len = round(0.01 * sampleRate);
    
    % Quefrency range
    quef_bot = round(sampleRate ./ 300);
    quef_top = round(sampleRate ./ 60);
    quefs = (quef_bot:quef_top)';

    %% Pre-emphasis from 50 Hz

    alpha = exp(-2 * pi * 50 / sampleRate);
    signal = filter([1, -alpha], 1, signal);

    %% Compute spectrum and cepstrum
    % spec will have length equal to
    % fix((s_len - win_overlap)/(win_len - win_overlap))
    spec = spectrogram(signal, hanning(win_len), win_overlap);
    spec_log = 10 * log10(abs(spec).^2);
    ceps_log = 10 * log10(abs(fft(spec_log)).^2);

    %% Do time- and quefrency-smoothing

    % Smooth over 10 samples and 10 quefrency bins
    smooth_filt_b = ones(1, 10) / 10;
    ceps_log = filter(smooth_filt_b, 1, filter(smooth_filt_b, 1, ceps_log')');

    %% Find cepstral peaks in the quefrency range
    ceps_log = ceps_log(quefs,:);
    [peak, peak_quef] = max(ceps_log, [], 1);

    %% Get the regression line and calculate its distance from the peak
    n_wins = size(ceps_log, 2);
    ceps_norm = zeros(1, n_wins);

    for n = 1:n_wins
      p = polyfit(quefs, ceps_log(:, n), 1);
      ceps_norm(n) = polyval(p, quefs(peak_quef(n)) );
    end

    cpps = peak - ceps_norm;

    %% Pad the CPPS vector and calculate means in 10-ms window
    midlevelFrameWidth_ms = 10;
    midlevelFrameWidth_s = midlevelFrameWidth_ms / 1000;
    % Reshape cpps so that each column represents 10 ms. Since win_step_s
    % and midlevelFrameWidth_s are fixed, cppsReshapeNumCols is always 5,
    % but is added here for clarity.
    cppsReshapeNumCols = round(midlevelFrameWidth_s / win_step_s);
    signalDuration_s = length(signal) / sampleRate;
    signalDuration_ms = signalDuration_s * 1000;
    expectedCPPSmidlevelLen = floor(signalDuration_ms / midlevelFrameWidth_ms);
    totalPaddingSize = expectedCPPSmidlevelLen * cppsReshapeNumCols - size(cpps,2);
    prepadSize = floor(totalPaddingSize / 2);
    postpadSize = totalPaddingSize - prepadSize;
    cpps_padded = [nan(1, prepadSize), cpps, nan(1, postpadSize)];
    cpps_win = reshape(cpps_padded, cppsReshapeNumCols, [])';
    CPPS_midlevel = median(cpps_win, 2, 'omitnan');

    %% replace NaNs with median CPPS
    CPPS_midlevel(isnan(CPPS_midlevel)) = median(CPPS_midlevel, 'omitnan');

    %% plot(CPPS_midlevel(1:1000))  %% debug 
end
