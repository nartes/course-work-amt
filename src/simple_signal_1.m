function simple_signal_1
	signal = @(a, b, g, d, t) gate(a * t) .* sin(g * t) + gate(b * t) .* sin(d * t);

	sample_rate = 44100;
	duration = 10; % seconds

	t = linspace(0, duration, round(duration * sample_rate));

	a = 2 * pi / duration * 3;
	b = 2 * pi / duration * 2;
	g = 440 * 2 * pi;
	d = (440 * pow2(-5 / 12)) * 2 * pi;

	s = signal(a, b, g, d, t);

	audiowrite('/tmp/audio.wav', s, sample_rate);

	system('mplayer /tmp/audio.wav');
end
