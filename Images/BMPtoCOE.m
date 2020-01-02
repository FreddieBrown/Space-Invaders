 [filename, pathname] = uigetfile('*.bmp;*.tif;*.jpg;*.pgm','Pick an M-file');
img = imread(filename);


imgTrans(:,:,1) = img(:,:,1).';
imgTrans(:,:,2) = img(:,:,2).';
imgTrans(:,:,3) = img(:,:,3).';



img1D = imgTrans(:);
img1D = bitsra(img1D,4);
img = dec2bin(img1D,4);

img3 = zeros(1024,3);
img3(:,1) = img1D(1:1024);
img3(:,2) = img1D(1025:2048);
img3(:,3) = img1D(2049:3072);

% New txt file creation
fid = fopen('inputHex.coe', 'wt');
% Hex value write to the txt file
fprintf(fid,'memory_initialization_radix=16;\n');
fprintf(fid,'memory_initialization_vector=\n');
for i = 1:1024
fprintf(fid, '%x%x%x,\n', img3(i,1),img3(i,2),img3(i,3));
end
% Close the txt file
fclose(fid)

