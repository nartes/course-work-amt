function simple_analysis_1(is_script=true)
  pkg load linear-algebra
  L = 4096;
  Fs = 44100;

  s = simple_signal_1(false, Fs);

  V = getspectrum(s, L);
  V1 = V(1:100,:);
  FV1 = V1 >= 1.4e+3;

  [n, m] = size(V1);

  if !is_script
    set(gcf(), 'Visible','off');
  end
  figure();
  i = image(FV1); colormap([1 1 1; 0 0 0]);
  print(gcf(), 'build/simple_analysis_dtfs.png');
  if !is_script
    close();
  end

  r = 2;
  [W, H, d, iter] = innernmf(V1, r, 1e-2, 100, 1);
  printf("Distance = %d, iter = %d\n", d, iter);

  figure();
  illustrate(W, H, L, Fs);
end

function illustrate(W, H, L, Fs)
  t = (1:size(W,1)) * Fs / L;
  subplot(221);
  plot(t, W(:,1),'k');
  subplot(223);
  plot(t, W(:,2),'k');
  subplot(222);
  plot(H(1,:)','k');
  subplot(224);
  plot(H(2,:)','k');
  print(gcf(), 'build/simple_analysis_nmf.png');
end
