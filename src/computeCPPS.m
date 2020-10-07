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

function [CPPS_midlevel] = computeCPPS(s, samp_freq)

    %% Window analysis settings
    
    s_len = length(s);

    % Window size and step
    win_len = round(0.04 * samp_freq);
    win_step = round(0.002 * samp_freq);
    win_overlap = win_len - win_step;

    % Size of the midlevel analysis window
    mid_win_len = round(0.01 * samp_freq);

    % Quefrency range
    quef_bot = round(samp_freq ./ 300);
    quef_top = round(samp_freq ./ 60);
    quefs = (quef_bot:quef_top)';

    %% Pre-emphasis from 50 Hz

    alpha = exp(-2 * pi * 50 / samp_freq);
    s = filter([1, -alpha], 1, s);

    %% Compute spectrum and cepstrum

    spec = spectrogram(s, gausswin(win_len), win_overlap);
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

    prepad_size = floor(win_len / win_step - 1);
    postpad_from = floor(s_len / win_step) * win_step;
    postpad_to = ceil(s_len / mid_win_len) * mid_win_len;
    postpad_size = floor((postpad_to - postpad_from) / win_step);
    cpps_padded = [nan(1, prepad_size), cpps, nan(1, postpad_size)];
    
    cpps_win = reshape(cpps_padded(3:end-3), 5, [])';
    CPPS_midlevel = median(cpps_win, 2, 'omitnan');

    % Replace NaNs with median CPPS.
    CPPS_midlevel(isnan(CPPS_midlevel)) = median(CPPS_midlevel, 'omitnan');

end