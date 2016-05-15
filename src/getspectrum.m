function v = getspectrum(s, L)

# usage: getspectrum(s, L)
#
# This function generates spectrogram
# of a signal s with a time window
# of a size L
#
# s - audiosignal
# L - time window size
#
# return: matrix V of a size (L / 2 + 1) x (length(s) / L)

  x = @(t) abs (fft (s (t:t + L - 1))) (1:L / 2 + 1);
  m = idivide(length(s), L);
  res = ones(L / 2 + 1, m);

  for i = 1:m
    res(:, i) = x((i - 1) * L + 1);
  end

  v = res;
endfunction
