function nmf
  pkg load all

  nmf_test();

  info = audioinfo(
    #'res/piano_samples_ogg/a4.ogg'
    #'res/la-do-mi-la.wav'
    #'res/sample1.wav'
    'res/sample2.0.wav'
    #'res/sample3.wav'
  );

  L = 4096;
  MAX_WINDOWS = 10000;
  raw_signal = mean(audioread(info.Filename)');
  s = raw_signal(1:min(length(raw_signal), L * MAX_WINDOWS)');

  printf("File name is %s\n", info.Filename);
  printf ("Signal length is %d (approx. %ds)\n",
      length(s), length(s) / info.SampleRate);
  printf ("Num of channels is %d\n", info.NumChannels);
  printf ("Window length is %d\n", L);

  V = getspectrum(s, L);
  #[W, H, d] = innernmf(V, 4);
  [n, m] = size(V);
  r = 7;
  [W, H] = nmf_pg(V, 'Winit', rand(n, r), 'Hinit', rand(r, m));

  subplot(121);
  mesh(W);
  subplot(122);
  mesh(H);
endfunction

function nmf_test
  # V = W * H

  n = 2048;
  r = 4;
  m = 22;

  W = rand(n, r);
  H = ones(r, m);

  V = W * H;

  [W1, H1, d] = innernmf(V, r);

  printf("Error is %d\n", d);

  if (d > 0.1)
    error("incorrect nmf algorithm!");
  end
endfunction

function [W,H,d] = innernmf(V, r = 2)
  [n, m] = size(V);

  PERGRADIENT = 1000;
  count = 0;
  MAX_ITER = 10000;

  do
    W = rand(n, r); H = rand(r, m);

    #updateH = @(V,H,W) H .* sum(W)' .* sum(V) ./ sum(W*H) ./ sum(W)';
    #updateW = @(V,H,W) W .* sum(H, 2)' .* sum(V, 2) ...
    #            ./ sum(W * H, 2) ./ sum(H, 2)';
    updateH = @(V, H, W) H .* (W' * V) ./ (W' * W * H);
    updateW = @(V, H, W) W .* (V * H') ./ (W * H * H');

    D = @(A,B) sum(sum(A .* log (A ./ B) .- A .+ B));
    N = @(A, B) sum(sumsq(A .- B));

    #while (D(V, W * H) > 0.1)
    printf("N is %d\n", N(V, W * H));
    while (N(V, W * H) > 0.1)
      H = updateH(V, H, W);
      W = updateW(V, H, W);

      ++count;
      if (rem(count, PERGRADIENT) == 0)
        break;
      end
      printf("N is %d\n", N(V, W * H));
    endwhile

    d = N(V, W * H);
  until (d < 0.1 || count == MAX_ITER)
  printf("Iter is %d\n", count);
endfunction
