function realaudio_nmf_post( ...
	fname = 'res/organ.wav', M = 2048, ...
	N = 4096, MFH = 6000, TR = 5.5, R = 4)
  pkg('load', 'linear-algebra');

  info = audioinfo(fname);

  FS = info.SampleRate;
  HS = floor(M * 0.25);
  MFS = floor(MFH / FS * N);


  TL = 0.0;
  SL = floor(TL * FS) + 1;
  SR = floor(TR * FS) + 1;

  x = mean(audioread(info.Filename), 2)(SL : SR);
  [y, c] = stft(x, M, HS, N / 2);
  L = size(y, 2);

  sy = y(1 : MFS, :);

  test_peaks_detector(sy(:, round(L / 2)), N, FS);

  plot_grayscale_spectrogram(sy);

  [W, H] = innernmf(abs(sy), R, 1e-2);

  plot_h_matrix(L, M, HS, FS, TL, R, H);
  plot_w_matrix(FS, N, MFS, R, W);
endfunction

function test_peaks_detector(sy, N, FS)
  sl = abs(sy)';

  peaks = peaks_detector(sl);
  plot((1 : length(sl)) / N * FS, sl, 'r-',
       peaks(:, 1) / N * FS, peaks(:, 2), 'g*');
  xlabel('Hz'); ylabel('amplitude');

  print('build/test_peaks_detector.png');
endfunction

function [peaks] = peaks_detector(x)
  ind = find(x(2 : end - 1) > x(1 : end - 2) &
             x(2 : end - 1) > x(3 : end)) + 1;

  peaks = zeros(length(ind), 2);

  for i = 1 : length(ind)
    bin = ind(i);
    px = [bin - 1, bin, bin + 1];
    py = x(px);
    p = polyfit(px, py, 2);
    dp = polyder(p);
    r = roots(dp);
    mx = r(r > bin - 1 & r < bin + 1);
    abin = polyval(p, mx)(1);
    peaks(i, :) = [mx abin];
  endfor
endfunction

function pitch_estimator(FS, N, R, W)
  peaks = cell(1, R);
  for k = 1 : R
    x = W(:, k)';
    peaks(k) = peaks_detector(x);
  endfor
endfunction

function plot_grayscale_spectrogram(sy)
  figure();
  imshow(flipud(abs(sy)));

  print('build/plot_grayscale_spectrogram.png');
endfunction

function plot_3d_mesh(L, MFS, sy)
  [ftime, ffreq] = meshgrid(1 : L, 1 : MFS);
  mesh(ftime, ffreq, abs(sy));
endfunction

function plot_w_matrix(FS, N, MFS, R, W)
  fhz = (1 : MFS) / N * FS;

  figure();
  for k = 1 : R
    subplot(R, 1, k);
    plot(fhz, W(:, k)');
    xlabel('Hz'); ylabel('amplitude');
  endfor
  print('build/plot_w_matrix.png');
endfunction

function plot_h_matrix(L, M, HS, FS, TL, R, H)
  tsec = ((0 : L - 1)  * HS + M / 2) / FS + TL;
  figure();
  for k = 1 : R
    subplot(R, 1, k);
    plot(tsec, H(k, :));
    xlabel('sec'); ylabel('amplitude');
  endfor

  print('build/plot_h_matrix.png');
endfunction
