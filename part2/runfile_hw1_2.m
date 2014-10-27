% Indranil Deb 50097062
% CSE 473/573 Programming Assignment 1
% Part of code taken from the starter code given with the assignment

function [] = runfile_hw1_2(save_flag, part_2_subject_name)

% path to the folder and subfolder
root_path = 'croppedyale/';

% The subject name has to be entered
subject_name = part_2_subject_name;

height_map_processing = 1; % whether we want avg height maps of different directions

%% load images
full_path = sprintf('%s%s/', root_path, subject_name);
[ambient_image, imarray, light_dirs] = LoadFaceImages(full_path, subject_name, 64);
image_size = size(ambient_image);
imarray_size = size(imarray);

%% preprocess the data:

for i = 1 : imarray_size(3)
    % Subtacting ambient image from image in imarray
    image = imarray(:,:,i) - ambient_image;
    corrected_image = zeros(size(image));
    % making sure no pixel is less than 0
    % if < 0 making it 0
    for j = 1 : size(image,1)
        for k = 1 : size(image,2)
            pixel = image(j,k);
            if pixel < 0
                corrected_pixel = 0;
            else
                corrected_pixel = pixel;
            end
            corrected_image(j,k) = corrected_pixel;
        end
    end
    % rescaling intensity values in imarray to be between 0 and 1
    corrected_image = corrected_image/max(corrected_image(:));
    imarray(:,:,i) = corrected_image;
end

%% get albedo and surface normals
[albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs);

%% reconstruct height map
height_map = get_surface(surface_normals, image_size, height_map_processing);

%% display albedo and surface
display_output(albedo_image, height_map);

%% plot surface normal
plot_surface_normals(surface_normals);

%% save output (optional) -- note that negative values in the normal images will not save correctly!
if save_flag
    imwrite(albedo_image, sprintf('%s_albedo.jpg', subject_name), 'jpg');
    imwrite(surface_normals, sprintf('%s_normals_color.jpg', subject_name), 'jpg');
    imwrite(surface_normals(:,:,1), sprintf('%s_normals_x.jpg', subject_name), 'jpg');
    imwrite(surface_normals(:,:,2), sprintf('%s_normals_y.jpg', subject_name), 'jpg');
    imwrite(surface_normals(:,:,3), sprintf('%s_normals_z.jpg', subject_name), 'jpg');
end

end

