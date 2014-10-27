% Indranil Deb 50097062
% CSE 473/573 Programming Assignment 1
% Part of code taken from the starter code given with the assignment

function [] = runfile_hw1_1(save_image, part_1_image_name)

% preprocessing flags
crop_image = true;
use_canny = true;

% Read all files starting with part1 from the dir
files = dir(part_1_image_name);

for i = 1 : length(files)
    raw_image = files(i).name;
    
    % send the file to colorize
    [colorized_image, height, width, dv_R, dv_G]...
        = colorize(raw_image, crop_image, use_canny);
    
    % open figure
    if crop_image
        figure, imshow(imcrop(colorized_image, [28 25 width-50 height-50]))...
            , title(strcat(raw_image,' Red : ',mat2str(dv_R)...
            ,' Green : ',mat2str(dv_G)));
    else
        figure, imshow(colorized_image)...
            , title(strcat(raw_image,' Red : ',mat2str(dv_R)...
            ,' Green : ',mat2str(dv_G)));
    end
    
    % save result image
    if save_image
        if crop_image
            imwrite(imcrop(colorized_image, [28 25 width-50 height-50])...
                ,['recombined_by_indranil_cropped_' raw_image]);
        else
            imwrite(colorized_image,['recombined_by_indranil_' raw_image])
        end
    end
end
end


function [colorized_image, height, width, displacement_vector_R, displacement_vector_G]...
    = colorize(raw_image, crop_image, use_canny)

% read in the image
original_plates = imread(raw_image);
fprintf('For Image : %s\n', raw_image);

% convert to double matrix
original_plates = im2double(original_plates);

% compute the height/3 and width of each part
height = floor(size(original_plates,1)/3);
width = floor(size(original_plates,2));

% separate color channels
Blue = original_plates(height*0+1:height*1,:);
Green = original_plates(height*1+1:height*2,:);
Red = original_plates(height*2+1:height*3,:);

% Find displacement vector with the lowest SSD to align red to blue channel.
displacement_vector_R = find_displacement_vector_with_least_SSD(Red, Blue, crop_image, use_canny);
% apply the shift on the base red plate to align with the blue
R_aligned_to_B = circshift(Red, displacement_vector_R);
fprintf('displacement vector for Red : (%d, %d)\n', displacement_vector_R);

% Find displacement vector with the lowest SSD to align green to blue channel.
displacement_vector_G = find_displacement_vector_with_least_SSD(Green, Blue, crop_image, use_canny);
% apply the shift on the base green plate to align with the blue
G_aligned_to_B = circshift(Green, displacement_vector_G);
fprintf('displacement vector for Green : (%d, %d)\n', displacement_vector_G);

% Recombined the red and green aligned plates with the Base blue plateusing cat
colorized_image = cat(3, R_aligned_to_B, G_aligned_to_B, Blue);
end


% Function for displacement vector with least SSD
function [displacement_vector] = find_displacement_vector_with_least_SSD...
    (plate_to_be_aligned, base_plate, crop_image, use_canny)

% Cropping the image
if crop_image
    plate_to_be_aligned = imcrop(plate_to_be_aligned, [50 50 300 300]);
    base_plate = imcrop(base_plate, [50 50 300 300]);
end

% Using edge detection (canny) on the plates
if use_canny
    plate_to_be_aligned = edge_detection(plate_to_be_aligned);
    base_plate = edge_detection(base_plate);
end

% intention is to find the vectors with the lowest SSD
% starting with a huge value
sum_of_squared_differences_tracker = inf;

% now I shall do an exhaustive search over a large window of displacements
for i = -20 : 20
    for j = -20 : 20
        % created a shifted image
        shifted_image = circshift(plate_to_be_aligned, [i j]);
        % got the SSD of the base blue plate with the shifted other color plate
        sum_of_squared_differences = sum(sum((base_plate - shifted_image).^2));
        % now I will store vectors with the the lowest SSD
        if sum_of_squared_differences < sum_of_squared_differences_tracker
            sum_of_squared_differences_tracker = sum_of_squared_differences;
            displacement_vector_with_least_ssd = [i j];
        end
    end
end

% finally return the vector with the lowest SSD
displacement_vector = displacement_vector_with_least_ssd;
end

% Function for edge detection
function [image] = edge_detection(image)
image = edge(image, 'canny');
end
