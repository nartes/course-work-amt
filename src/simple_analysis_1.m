function simple_analysis_1(is_script=true)
  pkg load linear-algebra
  L = 4096;

  s = simple_signal_1();
  V = getspectrum(s, L);
  V1 = V(1:100,:);
  FV1 = V1 >= 1.4e+3;

  [n, m] = size(V1);

  if !is_script
    set(gcf, 'Visible','off');
  end
  i = image(FV1); colormap([1 1 1; 0 0 0]);
  print(gcf(), 'build/spectrum.png');
  if !is_script
    close();
  end

  r = 2;
  [W, H] = nmf_pg(V1, 'Winit', rand(n, r), 'Hinit', rand(r, m));

  subplot(221);
  plot(W(:,1));
  subplot(223);
  plot(W(:,2));
  subplot(222);
  plot(H(1,:)');
  subplot(224);
  plot(H(2,:)');
end
