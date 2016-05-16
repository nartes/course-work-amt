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
