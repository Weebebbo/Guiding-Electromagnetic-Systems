% =========================================================================
% Microstrip T-Junction Power Divider with Dispersion
% =========================================================================

% General Parameters
f0 = 5.8e9;                 
c = 3e8;                    
e_r = 4.45;                 
h = 1.55e-3;                % Substrate thickness in meters
Z0 = 50;                    
Y0 = 1 / Z0;

% Z_inf2 in physical Parameters (Z_inf2 = 75 Ohm)
W2 = 1.37e-3;                % Width in meters
l2 = 7.254e-3;               % Physical length in meters
Y_inf2 = 1 / 75;

% Z_inf3 in pysical Parameters (Z_inf3 = 67.08 Ohm)
W3 = 1.729e-3;               % Width in meters 
l3 = 7.197e-3;               % Physical length in meters 
Y_inf3 = 1 / 67.08;

% Frequency Sweep Setup [0, 2*f0]
% Starting slightly above 0 (1 MHz) to avoid division by zero in dispersion formulas
f = linspace(1e6, 2*f0, 1000); 
norm_f = f / f0;
lambda0 = c ./ f;          

% Static Effective Permittivities
e_eff0_2 = (e_r + 1)/2 + ((e_r - 1)/2) * (1 / sqrt(1 + 12*h/W2));
e_eff0_3 = (e_r + 1)/2 + ((e_r - 1)/2) * (1 / sqrt(1 + 12*h/W3));

% Dispersive Effective Permittivities, this is frequency dependant!!
% F factors for Branch 2 
F2 = 4 * (h ./ lambda0) * sqrt(e_r - 1) .* (0.5 + (1 + 0.868 * log(1 + W2/h)).^2);
% F factors for Branch 3
F3 = 4 * (h ./ lambda0) * sqrt(e_r - 1) .* (0.5 + (1 + 0.868 * log(1 + W3/h)).^2);

% e_eff(f) for branch 2
e_eff_f2 = (sqrt(e_eff0_2) + (sqrt(e_r) - sqrt(e_eff0_2)) ./ (1 + 4 * F2.^(-1.5))).^2;
% e_eff(f) for branch 3
e_eff_f3 = (sqrt(e_eff0_3) + (sqrt(e_r) - sqrt(e_eff0_3)) ./ (1 + 4 * F3.^(-1.5))).^2;

% Frequency-Dependent Electrical Lengths
theta2 = (2 * pi * f / c) .* sqrt(e_eff_f2) * l2;
theta3 = (2 * pi * f / c) .* sqrt(e_eff_f3) * l3;

% Input Admittances of the Two Branches
Yin2 = Y_inf2 .* ( (Y0 + 1i * Y_inf2 .* tan(theta2)) ./ (Y_inf2 + 1i * Y0 .* tan(theta2)) );
Yin3 = Y_inf3 .* ( (Y0 + 1i * Y_inf3 .* tan(theta3)) ./ (Y_inf3 + 1i * Y0 .* tan(theta3)) );

% Total Input Admittance & Reflection Coefficient at T-Junction
Yin_total = Yin2 + Yin3;
S11 = (Y0 - Yin_total) ./ (Y0 + Yin_total);

% 10. Plotting the Results
figure;
plot(norm_f, abs(S11), 'LineWidth', 2, 'Color', 'b');
title('Frequency Behavior of |S_{11}(f)| with Dispersion');
xlabel('Normalized Frequency (f / f_0)');
ylabel('|S_{11}|');
grid on;