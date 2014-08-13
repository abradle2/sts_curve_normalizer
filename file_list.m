for i=1:23
    files = strcat('./Run 3/MoSe2_run3_00', int2str(i), '.dat');
    sts_curve_normalizer(files); 
end