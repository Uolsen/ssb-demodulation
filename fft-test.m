N=150; t = linspace(0,2*pi, N);
f = sin(2*t) + 2*sin(5*t);

F = fft(f);
plot(abs(F), "o-");