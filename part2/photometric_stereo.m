function [albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs)

% light_dirs: Nimages x 3 array of light source directions

% imarray: h x w x Nimages array of Nimages no. of images
imarray_size = size(imarray);

% surface_normals: h x w x 3 array of unit surface normals
surface_normals = zeros(imarray_size(1), imarray_size(2), 3);

% albedo_image: h x w image
albedo_image = zeros(imarray_size(1), imarray_size(2));

% Iterating through all pixels in the Nimages
for i = 1 : imarray_size(1)
    for j = 1 : imarray_size(2)
        % creating a new array to store the intensities at a pixel for Nimages
        new_array = zeros(imarray_size(3), 1);
        for k = 1 : imarray_size(3)
            new_array(k, 1) = imarray(i, j, k);
        end
        % get g by using least squares method / matlab mldivide or \
        g = light_dirs \ new_array;
        % get the albedo at that pixel by getting the magnitude of g, |g|
        albedo_image(i, j) = norm(g);
        % surface normals are calculated by g/|g| 
        surface_normals(i, j, :) = g/albedo_image(i, j);
    end
end

end

