clear; clc; close all;

%% Initial parameters
er = 9.8;               
h = 1.6e-3;             
Z0 = 50;                
f = 10e9;               
c = 3e8;                

% Input conditions at z = 0
V1 = 10e-3;             
I1 = 0.4e-3;
V2 = 0;
I2 = 0;
L = 100e-3;   

% Parameters calculated precedently or gotten from the online calculator
eeff = 6.6063;
lambda_0 = c / f;                 
lambda_g = lambda_0 / sqrt(eeff);
beta = 2 * pi / lambda_g;   

Z_even = 50.2845;
Z_odd = 49.0469;
k_even = 6.68437;
k_odd = 6.47581;

%% Calculations
%  Calculate phase constants
beta_e = (2 * pi * f / c) * sqrt(k_even);
beta_o = (2 * pi * f / c) * sqrt(k_odd);

% Decompose into Even and Odd modes at z = 0
Ve_0 = (V1 + V2) / 2;
Ie_0 = (I1 + I2) / 2;

Vo_0 = (V1 - V2) / 2;
Io_0 = (I1 - I2) / 2;

z = linspace(0, L, 1000);

% Telegrapher's equations for Even and Odd modes
Ve_z = Ve_0 * cos(beta_e * z) - 1j * Ie_0 * Z_even * sin(beta_e * z);
Vo_z = Vo_0 * cos(beta_o * z) - 1j * Io_0 * Z_odd * sin(beta_o * z);

% 4. Recombine to get the actual physical voltages on Line 1 and Line 2
V1_z = Ve_z + Vo_z;
V2_z = Ve_z - Vo_z;

% Convert magnitudes to mV for plotting
V1_mag_mV = abs(V1_z) * 1000;
V2_mag_mV = abs(V2_z) * 1000;
z_mm = z * 1000;

%% |Viso| for comparison
Viso_z = V1 * cos(beta * z) - 1j * I1 * Z0 * sin(beta * z);
V_mag_mV = abs(Viso_z) * 1000; 
z_mm = z * 1000;

%% Plot
figure;
plot(z_mm, V1_mag_mV, 'b-', 'LineWidth', 2); hold on;
plot(z_mm, V2_mag_mV, 'r--', 'LineWidth', 2); hold on;
plot(z_mm, V_mag_mV, 'm-.', 'LineWidth', 1);
grid on;
title('Voltage Magnitudes Along Coupled Microstrip Lines');
xlabel('Distance z (mm)');
ylabel('Voltage Magnitude (mV)');
legend('|V_1(z)|', '|V_2(z)|', '|V_{iso}(z)| for comparison');
xlim([0, 100]);