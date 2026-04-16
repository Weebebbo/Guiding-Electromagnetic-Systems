clear; clc; close all;

disp('==================================================');
disp('   MICROSTRIP SYNTHESIS AND VOLTAGE EVALUATION');
disp('==================================================');

%% Parameters
er = 9.8;               % Relative permittivity 
h = 1.6e-3;             % Substrate thickness
Z0 = 50;                
f = 10e9;               
c = 3e8;                

% Input conditions at z = 0
V0 = 10e-3;             % Input voltage (10 mV)
I0 = 0.4e-3;            % Input current (0.4 mA)
L = 100e-3;             % Total length of the line (100 mm = 0.1 m)

%% Microstrip Synthesis
A = (Z0 / 60) * sqrt((er + 1) / 2) + ((er - 1) / (er + 1)) * (0.23 + 0.11 / er);

% W/h ratio
W_h = (8 * exp(A)) / (exp(2 * A) - 2);

% Width in meters
W = W_h * h;            

% Effective dielectric constant
eeff = ((er + 1) / 2) + ((er - 1) / 2) * (1 / sqrt(1 + 12 / W_h));

% Display the synthesized microstrip parameters
fprintf('Target Impedance (Z0) : %.1f Ohms\n', Z0);
fprintf('Calculated Parameter A: %.4f\n', A);
fprintf('Calculated W/h ratio  : %.4f\n', W_h);
fprintf('Physical Width (W)    : %.3f mm\n', W * 1000);
fprintf('Effective Permittivity: %.4f\n\n', eeff);

%% Calculate Phase Constant 
lambda_0 = c / f;                 
lambda_g = lambda_0 / sqrt(eeff); % Guide wavelength (m)
beta = 2 * pi / lambda_g;         % Phase constant (rad/m)

fprintf('Guide Wavelength (Lg) : %.2f mm\n', lambda_g * 1000);
fprintf('Phase Constant (beta) : %.2f rad/m\n', beta);
disp('==================================================');

%% Evaluate Voltage along the line
z = linspace(0, L, 1000);

% By using the telegrapher's equation we compute voltage
V_z = V0 * cos(beta * z) - 1j * I0 * Z0 * sin(beta * z);

% Convert everything to mV for a cleaner plot
V_mag_mV = abs(V_z) * 1000; 
z_mm = z * 1000;

%% Plot
figure;
plot(z_mm, V_mag_mV, 'b-', 'LineWidth', 2);
grid on;
title('Voltage Magnitude |V_{iso}(z)| along the Microstrip Line');
xlabel('Distance along the line z (mm)');
ylabel('Voltage Magnitude (mV)');
xlim([0, 100]);
ylim([0, max(V_mag_mV) * 1.2]);

% Highlight the max and min points of the standing wave
hold on;
yline(max(V_mag_mV), 'r--', sprintf('Max Voltage (%.1f mV)', max(V_mag_mV)));
yline(min(V_mag_mV), 'g--', sprintf('Min Voltage (%.1f mV)', min(V_mag_mV)));