% Problem 1: Frequency response of a half-wave line
f_norm = linspace(0.5, 1.5, 500); % Normalized frequency f/f0
beta_l = pi * f_norm;             % Electrical length

% Define the test cases
cases = [50, 100; 
         50, 150; 
         75, 10];

figure; hold on;
for i = 1:size(cases, 1)
    Z0 = cases(i, 1);
    Zc = cases(i, 2);

    % We compute ABCD parameters for a transmission line and we use them in the formula to compute
    % S21, at the sime time we calculate the magnitude.
    mag_S21 = 1 ./ sqrt(cos(beta_l).^2 + ((Zc^2 + Z0^2)/(2*Z0*Zc)).^2 .* sin(beta_l).^2);
    S21_dB = 20 * log10(mag_S21);

    plot(f_norm, S21_dB, 'DisplayName', sprintf('Z_0 = %d \\Omega, Z_c = %d \\Omega', Z0, Zc), 'LineWidth', 1.5);
end

grid on;
xlabel('Normalized Frequency f/f_0');
ylabel('|S_{21}| (dB)');
title('Problem 1: Frequency Response of \lambda_0/2 Line');
legend('Location', 'south');
ylim([-30 0]);