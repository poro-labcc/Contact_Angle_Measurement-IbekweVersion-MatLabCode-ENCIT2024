function dataMatrix = readRawFile(filename, x, y, z)
    % Open the file in binary mode
    fid = fopen(filename, 'rb');
    
    % Check if the file is opened successfully
    if fid == -1
        error('Error opening file.');
    end
    
    % Read the data from the file
    rawData = fread(fid, x * y * z, 'uint8');
    
    % Close the file
    fclose(fid);
    
    % Reshape the data into a 3D matrix
    dataMatrix = reshape(rawData, [x, y, z]);
end
