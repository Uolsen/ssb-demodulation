[y, fs] = audioread('center4.wav');

frequency = 1500; % 1/2 of bandwidth
data_length = fs;  % Total number of data points
time = 5; %length in s of demodulated audio

t = linspace(0, time, time*data_length);  % Generate a time axis from 0 to 1 with data_length points
frequency_rad = 2*pi*frequency;  % Convert frequency to radians

% Generate first sinusoid
sinusoid1 = sin(2 * pi * frequency * t);

% Generate second sinusoid with 90 degrees phase shift
phase_shift = pi / 2;
sinusoid2 = sin(2 * pi * frequency * t - phase_shift);

left_channel = transpose(y(:, 2) * 40);
left_channel_truncated = left_channel(1:length(sinusoid1));
right_channel = transpose(y(:, 1) * 40);
right_channel_truncated = right_channel(1:length(sinusoid2));
i = left_channel_truncated;
q = right_channel_truncated;
disp(fs) %sampling rate
%disp(left_channel)

left_channel_with_sinusoid1 = left_channel_truncated .* sinusoid1;
right_channel_with_sinusoid2 = right_channel_truncated .* sinusoid2;

disp("added");

usb = left_channel_with_sinusoid1 + (right_channel_with_sinusoid2);
lsb = left_channel_with_sinusoid1 + (-right_channel_with_sinusoid2);

%usb = 5*usb;
%lsb = 5*lsb;

disp("demod");

% show signal in plot
plot(t, lsb, 'b');
hold on;
%plot(t, usb, 'r');
xlabel('Time');
ylabel('Amplitude');
title('Sinus Wave');
grid on;
hold off;

player = audioplayer(lsb, fs, 16);
play(player);

%offset = 1;  % Adjust the offset as needed
%scaling_factor = intmax('int32');  % Adjust the scaling factor as needed
%integer_signal = round((scaling_factor - offset) * (lsb - min(lsb)) / (max(lsb) - min(lsb)) + offset);

%ssb_signal = integer_signal;
signal = i + q*1i;

% Apply the FFT 
fft_result = fft(lsb);  

% Shift the FFT result to center the frequency spectrum 
fft_result_shifted = fftshift(lsb);  

% Generate the frequency axis for plotting 
fs = fs;  % Sample rate (adjust to match your signal) 
N = length(lsb);  % Length of signal array 
f = (-fs/2:fs/N:fs/2 - fs/N)';  % Frequency axis (negative to positive)  

% Plot the magnitude spectrum 
plot(f, abs(fft_result)); 
title('Magnitude Spectrum'); 
xlabel('Frequency (Hz)'); 
ylabel('Magnitude'); 

pause(time);

stop(player)