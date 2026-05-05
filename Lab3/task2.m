% Problem 2: Symmetrical Cascaded Bandpass Filters (Corrected)

f_norm = linspace(0.5, 1.5, 500);
beta_l = pi * f_norm; % Electrical length of lambda/2 @ f0
Z0 = 50; % Reference impedance

% --- CORRECTED IMPEDANCES AND ORDERS ---
% To maximize attenuation, we use the absolute limits: 20 and 180 ohms.

% Case 1: Requires N=3 to hit -20 dB.
Zc_case1 = [20, 180, 20]; 

% Case 2: Mathematically requires N=5 to hit -35 dB with these impedance limits.
Zc_case2 = [20, 180, 20, 180, 20]; 

% Preallocate arrays for speed
S21_case1 = zeros(1, length(f_norm)); 
S21_case2 = zeros(1, length(f_norm));

% Calculate Cascaded S21
for k = 1:length(f_norm)
    bl = beta_l(k);
    
    % --- Case 1 Cascade (N=3) ---
    ABCD_1 = eye(2);
    for i = 1:length(Zc_case1)
        Zc = Zc_case1(i);
        A = cos(bl); 
        B = 1i * Zc * sin(bl);
        C = 1i * (1/Zc) * sin(bl); 
        D = cos(bl);
        ABCD_1 = ABCD_1 * [A, B; C, D];
    end
    S21_case1(k) = 2*Z0 / (Z0*ABCD_1(1,1) + ABCD_1(1,2) + Z0^2*ABCD_1(2,1) + Z0*ABCD_1(2,2));
    
    % --- Case 2 Cascade (N=5) ---
    ABCD_2 = eye(2);
    for i = 1:length(Zc_case2)
        Zc = Zc_case2(i);
        A = cos(bl); 
        B = 1i * Zc * sin(bl);
        C = 1i * (1/Zc) * sin(bl); 
        D = cos(bl);
        ABCD_2 = ABCD_2 * [A, B; C, D];
    end
    S21_case2(k) = 2*Z0 / (Z0*ABCD_2(1,1) + ABCD_2(1,2) + Z0^2*ABCD_2(2,1) + Z0*ABCD_2(2,2));
end

% --- Plotting ---
figure;
plot(f_norm, 20*log10(abs(S21_case1)), 'b', 'LineWidth', 1.5); hold on;
plot(f_norm, 20*log10(abs(S21_case2)), 'r', 'LineWidth', 1.5);

% Target Masks
yline(-20, 'b--', 'Case 1 Target (-20 dB)', 'LabelHorizontalAlignment', 'left');
yline(-35, 'r--', 'Case 2 Target (-35 dB)', 'LabelHorizontalAlignment', 'left');

grid on;
xlabel('Normalized Frequency f/f_0');
ylabel('|S_{21}| (dB)');
title('Problem 2: Symmetrical Bandpass Filters (Fixed)');
legend('Case 1 (N=3)', 'Case 2 (N=5)', 'Location', 'south');
ylim([-60 0]);
xlim([0.5 1.5]);