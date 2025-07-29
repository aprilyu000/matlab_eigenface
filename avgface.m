clc;
clear;

filenames = dir('face/*.bmp');
totalfiles = length(filenames);
numTestFiles = 28;
numTrainingFiles = totalfiles - numTestFiles;

y_dimensions = 256;
x_dimensions = 256; 
dimensions = y_dimensions * x_dimensions; %256x256

D = zeros(dimensions , numTrainingFiles); %creates zeros of 256^2 by 150

meanie = zeros(dimensions , 1);

for i = 1:numTrainingFiles
   
    mySTR = strcat('face/' , filenames(i).name);
    disp(mySTR);

    img = imread(mySTR);

    D(: , i) = double(img(:));

meanie = D(: , i) + meanie;

end

meanie = meanie./numTrainingFiles; %ψ

avgFaceImage = reshape(meanie, y_dimensions, x_dimensions); % reshape means to put back into image format
%imshow(uint8(avgFaceImage));
%title('Average Face');


% centered data
for i = 1:numTrainingFiles
    D(: , i) = D(: , i) - meanie;
end

faceCov = (D' * D)/numTrainingFiles;

[eig_vect, eig_val] = eig(faceCov);

% takes the eigen values that are organized diagonally into one column
eig_vals_diag = diag(eig_val);

% sort the eig values in decending order with the respected inital index values
[sorted_vals, index] = sort(eig_vals_diag, 'descend');

% switches back into square matrix
eig_vals_sorted = diag(sorted_vals);

% Grabbing each column of eigen vectors and sorting into the index that was assigned to the descending order of eigen values 
eig_vecs_sorted = eig_vect(:, index);

PC = D * eig_vecs_sorted;
normalizedPC = zeros(dimensions , numTrainingFiles);

% unit vector
for i = 1:numTrainingFiles
    normalizedPC(: , i) = PC(: , i) / norm(PC(: , i));
end

% percent calculations
totVar2 = sum(eig_vals_diag);
csum = 0;

for i = 1:numTrainingFiles 
    csum = csum + sorted_vals(i);
    tV = csum / totVar2;
    if tV > 0.97
        k = i;
        break
    end
end

% number of eigenfaces to display
numDisplay = 16;

for i2 = 1:numDisplay
    % Get each eigenface vector from PC (each column is one eigenface)
    rawEigenface = normalizedPC(:, i2);  % size: [65536 × 1]

    % convert matrix to grey scale
    greyeigface = mat2gray(rawEigenface);  % scale to [0,1] for imshow

    % reshape to image
    reshapedFace = reshape(greyeigface, y_dimensions, x_dimensions);

    % === display ===
     % subplot(4, 4, i2);
     % imshow(reshapedFace);
     % title({['Eigenface ' num2str(i2)]} , 'FontSize', 8);

    filename = sprintf('eigenface_%d.jpeg', i); % creates 'eigenface_1.jpeg', etc.
    imwrite(reshapedFace, filename);
end

% zeros cell for error
errorRECON = zeros(numTestFiles , 1);
error_vs_var = zeros(numTrainingFiles, numTestFiles);

for i3 = 1:numTestFiles
    readtestface = strcat('face/' , filenames(i3 + numTrainingFiles).name); 
    img2 = imread(readtestface);
    disp(readtestface);
    
    readtestface2 = double(reshape(img2, dimensions, 1));
    
    centered_testFace = readtestface2 - meanie; 
    weights = normalizedPC' * centered_testFace;
    
    reconstructed = meanie + normalizedPC(:, 1:k) * weights(1:k);
    reconstructed_img = reshape(reconstructed, x_dimensions, y_dimensions);
    original_img = reshape(readtestface2, x_dimensions, y_dimensions);

    % loop through each variance level
    for i = 1:numTrainingFiles
        weights2 = normalizedPC(:, 1:i)' * centered_testFace;  
        reconstructed2 = meanie + normalizedPC(:, 1:i) * weights2;

        error_vs_var(i , i3) = 100 * norm(reconstructed2 - readtestface2) / norm(readtestface2);
    end

    % === Open a new figure every 4 images ===
    if mod(i3-1, 4) == 0
        figure;
    end

    subplot_idx = mod(i3-1, 4) + 1;  % 1 to 4

    subplot(2, 4, subplot_idx);  % Top row: original
    imshow(original_img, []);
    title(['Original ', num2str(i3)]);

    subplot(2, 4, subplot_idx + 4);  % Bottom row: reconstructed
    imshow(reconstructed_img, []);
    title(['Reconstructed ', num2str(i3)]);
end

mean_error_vs_var = mean(error_vs_var, 2);

% Plot: Average Error vs Number of Eigenfaces Used
figure;
plot(1:numTrainingFiles, mean_error_vs_var, 'o-');
xlabel('Number of Eigenfaces Used');
ylabel('Average Reconstruction Error (%)');
title('Avg Reconstruction Error vs Number of Eigenfaces');
grid on;