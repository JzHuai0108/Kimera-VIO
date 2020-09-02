csv = './kimera_vio_noros/src/Kimera-VIO/output_logs/traj_vio.csv';
data = readmatrix(csv);
close all;

std_index = 1 + 15 + (1:3);
figure;
plot(data(:, std_index(1)), 'r'); hold on;
plot(data(:, std_index(2)), 'g');
plot(data(:, std_index(3)), 'b');
legend('x', 'y', 'z');
grid on;

std_index = 1 + 15 + (4:6);
figure;
plot(data(:, std_index(1)), 'r'); hold on;
plot(data(:, std_index(2)), 'g');
plot(data(:, std_index(3)), 'b');
legend('r', 'p', 'y');
grid on;
