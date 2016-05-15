function s=simple_signal_1(is_script=false)
  signal = @(a, b, g, d, t) gate(a * t) .* sin(g * t) + gate(b * t) .* sin(d * t);

  sample_rate = 44100;
  duration = 10; % seconds

  t = linspace(0, duration, round(duration * sample_rate));

  a = 2 * pi / duration * 3;
  b = 2 * pi / duration * 2;
  g = 440 * 2 * pi; %A4
  d = (440 * pow2(-5 / 12)) * 2 * pi; %E4 five semitons lower than A4

  s = signal(a, b, g, d, t);

  if is_script  == true
    audiowrite('./build/audio.wav', s, sample_rate);

    system('mplayer ./build/audio.wav');
  end
end
