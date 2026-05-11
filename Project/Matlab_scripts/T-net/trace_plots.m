% MATLAB script to import and plot data from PI_graph_trace.txt

% 1. Define the filename
filename = 'T_graph_trace.txt';

% 2. Import the data
% We use readmatrix and skip the first line (the text header)
data = readmatrix(filename, 'NumHeaderLines', 1);

% 3. Extract the columns into separate variables
freq = data(:, 1);              % Column 1: Frequency (GHz)
s21_pi_network = data(:, 2);    % Column 2: DB(|S(2,1)|) for PI_network_lpf
s21_em_extract = data(:, 3);    % Column 3: DB(|S(2,1)|) for EM_Extract_Doc

% 4. Create the plot
figure; % Open a new figure window

% Plot the first trace (PI network) with a blue solid line
plot(freq, s21_pi_network, 'b-', 'LineWidth', 1.5);
hold on; % Keep the first plot on the axes while we add the second

% Plot the second trace (EM Extract) with a red dashed line
plot(freq, s21_em_extract, 'r--', 'LineWidth', 1.5);

% 5. Add formatting and labels
title('Insertion Loss (S21) vs Frequency');
xlabel('Frequency (GHz)');
ylabel('Magnitude (dB)');

% Add a legend. The '\_' prevents MATLAB from interpreting underscores as subscripts
legend('T\_network\_lpf', 'EM\_Extract\_Doc', 'Location', 'southwest');

% Turn on the grid for easier reading
grid on;

hold off; % Release the plot hold