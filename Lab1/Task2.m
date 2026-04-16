clear; clc; close all;

%% Define Parameters
Z0 = 50;           % Reference/Source impedance
ZL = 100;          % Load impedance
Zc1 = 60;          % Characteristic impedance of line 1
Zc2 = 84;          % Characteristic impedance of line 2

f_norm = linspace(0, 2, 10000); % Normalized frequency f/f0
theta = (pi / 2) * f_norm;      % Electrical length

%% Calculate S11 using ABCD Matrices
% ABCD matrix elements for Line 1
A1 = cos(theta);
B1 = 1j * Zc1 * sin(theta);
C1 = 1j * sin(theta) / Zc1;
D1 = cos(theta);

% ABCD matrix elements for Line 2
A2 = cos(theta);
B2 = 1j * Zc2 * sin(theta);
C2 = 1j * sin(theta) / Zc2;
D2 = cos(theta);

% In order to cascade the two sections we have to multiply 
% the 2 matrixes: [ABCD_total] = [ABCD_1] * [ABCD_2]
A_tot = A1 .* A2 + B1 .* C2;
B_tot = A1 .* B2 + B1 .* D2;
C_tot = C1 .* A2 + D1 .* C2;
D_tot = C1 .* B2 + D1 .* D2;

% Calculate Input Impedance and S11
Zin_p2 = (A_tot .* ZL + B_tot) ./ (C_tot .* ZL + D_tot);
S11_p2 = (Zin_p2 - Z0) ./ (Zin_p2 + Z0);
S11_p2_dB = 20 * log10(abs(S11_p2));

%% Determine Bandwidth (S11 < -20 dB)
idx_p2 = find(S11_p2_dB < -20);
if ~isempty(idx_p2)
    f1_p2 = f_norm(idx_p2(1));
    f2_p2 = f_norm(idx_p2(end));
    BW_p2 = f2_p2 - f1_p2;
    fprintf('Problem 2 (Two-Section):\n');
    fprintf('  Interval [f1, f2] / f0: [%.3f, %.3f]\n', f1_p2, f2_p2);
    fprintf('  Fractional Bandwidth: %.2f%%\n\n', BW_p2 * 100);
end

%% Plotting
figure('Name', 'Task1', 'Color', 'w');
plot(f_norm, S11_p2_dB, 'r-', 'LineWidth', 1.5); 
hold on;
yline(-20, 'k:', 'LineWidth', 1.5, 'Label', '-20 dB target');

% Formatting the plot
ylim([-50 0]);
xlim([0 2]);
grid on;
title('Frequency Behavior of Matching Circuits (Z_L = 100 \Omega)');
xlabel('Normalized Frequency (f/f_0)');
ylabel('|S_{11}| (dB)');
hold off;