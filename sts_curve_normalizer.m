%This program calculates the real conductance values of an STS curve and
%normalizes the curve by I/V. Both Sets of data (dI/dV and dI/dV/(I/V)) are
%saved in a new file, along with V and I.

%NOTE: You have to input the following variables by hand every time:

function [V, I_t, dIdV, dIdV_normalized, header] = sts_curve_normalizer(file_in)

%file_in = './Run 3/MoSe2_run3_006.dat';
gain = 1E8;
smudge = 5E-11;      %This is the factor that multiplies I/V to get rid of infinities

%Figure out how many lines are in the header:
header_lines = 0;
fid = fopen(file_in);
header_flag = 1;
line = fgets(fid);
while header_flag
    header_lines = header_lines + 1;
    if strfind(line, '[DATA]') == 1
        header_flag = 0;
        fprintf('There are ');
        fprintf('%i', header_lines);
        fprintf(' lines in your file header \n');
    elseif header_lines > 100
        header_flag = 0;
        fprintf('Sorry, no header found \n');
    end
    line = fgets(fid);
end

fclose(fid);


fid = importdata(file_in, '\t', header_lines+1);

%Determine lockin parameters:

for i = 1:header_lines
    cell = fid.textdata(i, 1);  %Reads the cell containing the header information
    line = cell{1};              %Puts the cell contents into a string array

    %Determine the sensitivity
    sens_location = strfind(line, 'Sensitivity');
    if ~isempty(sens_location)
        sens_string = line((sens_location+12:end));
        sens = sscanf(sens_string, '%i');  %Pull out the number from the sensitivity
        if ~isempty(strfind(sens_string, 'uV'))
            sens = sens * 0.000001;
        elseif ~isempty(strfind(sens_string, 'mV'))
            sens = sens * 0.001;
        elseif ~isempty(strfind(sens_string, 'V'))
            sens = sens * 1;
        end
    end
    
    %Determine the wiggle voltage
    deltaV_location = strfind(line, 'Osc. Amplitude');
    if ~isempty(deltaV_location)
        deltaV_string = line((deltaV_location+19:end));
        deltaV = sscanf(deltaV_string, '%g');  %Pull out the number
        deltaV = deltaV / 10;       %Don't forget - we have a 10x voltage divider on the wiggle voltage
    end
    
    %Determine the preamp gain
    gain_location = strfind(line, 'Current>Gain');
    if ~isempty(gain_location)
        gain_string = line((end-1:end));
        gain = sscanf(gain_string, '%i');  %Pull out the number for the gain exponent
        gain = 10^gain
    end

    
end

V = fid.data(:,1);
I_t = fid.data(:,2);
LIY = fid.data(:,4);

%dIdV = sens*sqrt(2)/(gain*deltaV*2.5)*LIY;
dIdV = LIY;

dIdV_normalized = dIdV./(I_t./V +smudge);

output = [V, I_t, dIdV, dIdV_normalized];


header = fid.textdata(1:end-1,1);





% file_out = fopen(strcat(file_in, '.norm'), 'w+');
% 
% fprintf(file_out, '%s\r\n', fid.textdata{1:end-1,1});
% fprintf(file_out, 'Sample Bias (V)\tCurrent (A)\tdI/dV (S)\tdI/dV normalized (SV/A)\r\n');
% fprintf(file_out, '%d\t%d\t%d\t%d\t\r\n', output');
% fclose(file_out);
% 
% set(0, 'defaultlinelinewidth', 2);
% set(0, 'defaultfigurecolor', 'w');
% 
% subplot(1,2,1);
% plot(V, dIdV);
% title('dI/dV');
% xlabel('Sample Bias(V)');
% ylabel('dI/dV');
% subplot(1,2,2);
% plot(V, dIdV_normalized);
% title('dI/dV / (I/V)');
% xlabel('Sample Bias(V)');
% ylabel('dI/dV / (I/V)');


