function simple_analysis_1()
  L = 4096;

  s = simple_signal_1();
  V = getspectrum(s, L);
  V1 = V(1:100,:);
  FV1 = V1 >= 1.4e+3;

  %meshc(FV1 .* ones(size(FV1)));
  image(FV1); colormap([1 1 1; 0 0 0]);
end
