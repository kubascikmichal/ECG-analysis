% Ruta de los archivos CSV
filename1 = fullfile('16 SDHB', 'csv',  '231m (9).csv'); 
filename2 = fullfile('16 SDHB', 'csv',  '231m (6).csv'); 

% Leer los datos de ambos archivos
data1 = readmatrix(filename1);
data2 = readmatrix(filename2);

% Crear un vector de tiempo si los datos son muestreados (asumiendo misma longitud y frecuencia)
fs = 360; % frecuencia de muestreo en Hz
t = (0:length(data1)-1)/fs;

% Plotear los datos
figure;
plot(t, data1, 'b-', 'LineWidth', 1.5); % Gráfica del primer archivo en azul
hold on;
plot(t, data2, 'r-', 'LineWidth', 1.5); % Gráfica del segundo archivo en rojo
hold off;

% Añadir títulos y etiquetas
title('Superposición de Datos de Dos Archivos CSV');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Archivo 1', 'Archivo 2');
grid on;
