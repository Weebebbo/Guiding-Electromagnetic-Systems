% Problem 2: Symmetrical Cascaded Bandpass Filters (Corrected)
f_norm = linspace(0.5, 1.5, 500);
beta_l = pi * f_norm; % Electrical length of lambda/2 @ f0
Z0 = 50; % Reference impedance

% --- CORRECTED IMPEDANCES AND ORDERS ---
% To maximize attenuation, we use the absolute limits: 20 and 180 ohms.
% Case 1
% TEST CASE 1:
%Zc_case1 = [20, 180, 20];
% CORRECT CASE 1:
Zc_case1 = [20, 160, 20]; 

% Case 2
% TEST CASE 2
%Zc_case2 = [20, 180, 20, 180, 20];
% CORRECT CASE 2
Zc_case2 = [20, 135, 20, 135, 20]; 
 
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
figure('Position', [100, 100, 1000, 450]);

% Convert complex S21 to dB
S21_case1_dB = 20*log10(abs(S21_case1));
S21_case2_dB = 20*log10(abs(S21_case2));

% Case 1 Plot
subplot(1, 2, 1);
plot(f_norm, S21_case1_dB, 'b-', 'LineWidth', 1.5); hold on;
yline(-0.5, 'r--', 'LineWidth', 1.2);
yline(-20, 'y--', 'LineWidth', 1.2);
xline(0.85, 'g:'); 
xline(1.15, 'g:');
ylim([-40, 2]);
title('Case 1: 30% FBW, N=3');
xlabel('f / f_0'); ylabel('|S_{21}| (dB)');
grid on; 
legend('|S_{21}|', '-0.5 dB Ripple Limit', '-20 dB IL Target', 'Location', 'south');

% Case 2 Plot
subplot(1, 2, 2);
plot(f_norm, S21_case2_dB, 'b-', 'LineWidth', 1.5); hold on;
yline(-1.5, 'r--', 'LineWidth', 1.2);
yline(-35, 'y--', 'LineWidth', 1.2);
xline(0.80, 'g:'); 
xline(1.20, 'g:');
ylim([-60, 2]);
title('Case 2: 40% FBW, N=5');
xlabel('f / f_0'); ylabel('|S_{21}| (dB)');
grid on; 
legend('|S_{21}|', '-1.5 dB Ripple Limit', '-35 dB IL Target', 'Location', 'south');