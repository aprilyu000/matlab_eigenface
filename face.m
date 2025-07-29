% cell array to store 178 images
A = cell(178 , 1);

% loop from 0 to 177 to process images
for index = 0:177
    
% command to convert index into a 3-digit string format, with leading zeros if needed
    D = sprintf('%03d', index);

% attaches srings together     
    mySTR = strcat('face' , D , '.bmp');

% debug: image being processed    
    disp(['Processing file: ' , mySTR])

% analyze image from file name and show figure in another window 
        img = imread(mySTR);
        imshow(img);

% debug: image         
        title(mySTR)
        pause(0.001)
 
% stores image in cell array A, A is an array storage  (memory)        
    A{index + 1} = img;

end


%for index = 0:177
    %imshow(A{index + 1})
    %pause(0.1)
%end



%Write below code to calculate the average of the face (From array A)


% initialize first image to accumulate (convert to double to avoid overflow)
Temp = double(A{1});

% loop through remaining images and accumulate values
for i = 2:178
    Temp = Temp + double(A{i});
end

% take average of all images
Temp = Temp / length(A);

% convert back to uint8 for display (if original images are uint8)
Temp = uint8(Temp);

% Display the average face
imshow(Temp);
title('Average Face');