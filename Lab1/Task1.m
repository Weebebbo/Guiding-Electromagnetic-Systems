    clear; clc; close all;
    
    %% Define Parameters
    Z0 = 50;         % Characteristic impedance
    ZL1 = 100;       % Load impedance for Case 1 
    ZL2 = 200;       % Load impedance for Case 2 
    
    % Calculate Zc for both cases
    Zc1 = sqrt(Z0 * ZL1);
    Zc2 = sqrt(Z0 * ZL2);
    
    fprintf('--- Characteristic Impedances ---\n');
    fprintf('Case 1 (ZL = 100 Ohms): Zc = %.2f Ohms\n', Zc1);
    fprintf('Case 2 (ZL = 200 Ohms): Zc = %.2f Ohms\n\n', Zc2);
    
    %% Normalized frequency range f_norm = f / f0 
    %  it has to be calculated for the range [0,2f0], that's why it goes from 0
    %  to 2
    f_norm = linspace(0, 2, 10000); 
    
    % Electrical length of a quarter-wave line
    theta = (pi / 2) * f_norm; 
    
    %% Calculate S11
    % Case 1
    % Input impedance
    Zin1 = Zc1 .* (ZL1 + 1j * Zc1 .* tan(theta)) ./ (Zc1 + 1j * ZL1 .* tan(theta));
    % S11 and conversion to dB
    S11_1 = (Zin1 - Z0) ./ (Zin1 + Z0);
    S11_1_dB = 20 * log10(abs(S11_1));
    
    % Case 2
    Zin2 = Zc2 .* (ZL2 + 1j * Zc2 .* tan(theta)) ./ (Zc2 + 1j * ZL2 .* tan(theta));
    
    S11_2 = (Zin2 - Z0) ./ (Zin2 + Z0);
    S11_2_dB = 20 * log10(abs(S11_2));
    
    %% Determine Fractional Bandwidth (S11 < -20 dB)
    fprintf('--- Fractional Bandwidths ---\n');
    
    % Case 1 Bandwidth
    % we use the find function to fill idx_p2 of all the addresses of the
    % values that satisfy the condition, then we pick the first and the last
    % value.
    idx1 = find(S11_1_dB < -20);
    if ~isempty(idx1)
        f1_1 = f_norm(idx1(1));
        f2_1 = f_norm(idx1(end));
        BW1 = f2_1 - f1_1;
        fprintf('Case 1 (ZL = 100 Ohms):\n');
        fprintf('  Interval [f1, f2] / f0: [%.3f, %.3f]\n', f1_1, f2_1);
        fprintf('  Fractional Bandwidth: %.2f%%\n\n', BW1 * 100);
    else
        fprintf('Case 1 never reaches |S11| < -20 dB.\n\n');
    end
    
    % Case 2 Bandwidth
    idx2 = find(S11_2_dB < -20);
    if ~isempty(idx2)
        f1_2 = f_norm(idx2(1));
        f2_2 = f_norm(idx2(end));
        BW2 = f2_2 - f1_2;
        fprintf('Case 2 (ZL = 200 Ohms):\n');
        fprintf('  Interval [f1, f2] / f0: [%.3f, %.3f]\n', f1_2, f2_2);
        fprintf('  Fractional Bandwidth: %.2f%%\n', BW2 * 100);
    else
        fprintf('Case 2 never reaches |S11| < -20 dB.\n');
    end
    
    %% Plotting
    figure('Name', 'S11 Frequency Behavior', 'Color', 'w');
    
    plot(f_norm, S11_1_dB, 'b', 'LineWidth', 1.5); hold on;
    plot(f_norm, S11_2_dB, 'r--', 'LineWidth', 1.5);
    yline(-20, 'k:', 'LineWidth', 1.5, 'Label', '-20 dB target');
    
    % Formatting the plot
    ylim([-50 0]);
    xlim([0 2]);
    grid on;
    title('Frequency Behavior of QWT');
    xlabel('Normalized Frequency (f/f_0)');
    ylabel('|S_{11}| (dB)');
    legend('Case 1: Z_L = 100 \Omega', 'Case 2: Z_L = 200 \Omega', 'Location', 'south');