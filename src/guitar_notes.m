% guitar_notes.m

function guitar_notes()
	show_peak("tmp/GuitarNotes/(Scale3) Mi.wav", 2048);
endfunction

function show_peak(fname, L)
  Fs = audioinfo(fname).SampleRate;
	x = audioread(fname);
	v = getspectrum(x, L);
	freqs = 1.0 * (0 : (L / 2)) / L * Fs;
	plot(freqs, v(:, 3));
endfunction
