% surface_normals: h x w x 3 array of unit surface normals
% image_size: [h, w] of output height map/image
% height_map: height map of object of dimensions [h, w]
% the algorithm used here is taken from the text book

function  height_map = get_surface(surface_normals, image_size, height_map_processing)

% initialize the height map
height_map_LR = zeros(image_size);
if height_map_processing
    height_map_RL = zeros(image_size);
    height_map_UD = zeros(image_size);
    height_map_DU = zeros(image_size);
end

% initialize p and q
p = zeros(image_size);
q = zeros(image_size);

% temp variable to store the surface normals at each pixel
surface_normal_at_ij = zeros(1,3);

% iterate over the surface normals to find p and q and store them
for i = 1 : image_size(1)
    for j = 1 : image_size(2)
        for k = 1 : 3
            surface_normal_at_ij(1,k) = surface_normals(i,j,k);
        end
        p(i, j) = surface_normal_at_ij(1,1)/surface_normal_at_ij(1,3);
        q(i, j) = surface_normal_at_ij(1,2)/surface_normal_at_ij(1,3);
    end
end

% Now integrate the p and q in respective directions

% H_MAP 1 : left to right
for i = 2 : image_size(1)
    height_map_LR(i,1) = height_map_LR(i-1,1) + q(i,1);
end
for i = 1 : image_size(1)
    for j = 2 : image_size(2)
        height_map_LR(i,j) = height_map_LR(i,j-1) + p(i,j);
    end
end

% if processing H_Map flag is true then get H_Map from other directions

if height_map_processing
    % H_MAP 2 : right to left
    for i = image_size(1)-1 : -1 : 1
        height_map_RL(i,image_size(2)) = height_map_RL(i+1,image_size(2))...
            + q(i,image_size(2));
    end
    for i = image_size(1) : -1 : 1
        for j = image_size(2)-1 : -1 : 1
            height_map_RL(i,j) = height_map_RL(i,j+1) + p(i,j);
        end
    end
    
    % H_MAP 3 : top down
    for i = 2 : image_size(2)
        height_map_UD(1,i) = height_map_UD(1,i-1) + p(1,i);
    end
    for i = 1 : image_size(2)
        for j = 2 : image_size(1)
            height_map_UD(j,i) = height_map_UD(j-1,i) + q(j,i);
        end
    end
    
    % H_MAP 4 : bottom up
    for i = image_size(2)-1 : -1 : 1
        height_map_DU(image_size(1),i) = height_map_DU(image_size(1),i+1)...
            + p(image_size(1),i);
    end
    for i = image_size(2) : -1 : 1
        for j = image_size(1)-1 : -1 : 1
            height_map_DU(j,i) = height_map_DU(j+1,i) + q(j,i);
        end
    end
end

% now we find the height map. (Average of all four maps if all directions
% are taken, otherwise only 1 (left to right) direction

if height_map_processing
    % Average Height from H_Maps from all 4 directions
    height_map = ((height_map_LR +...
        (-1*height_map_RL) + ...
        height_map_UD + ...
        (-1*height_map_DU))...
        /4);
else
    % Only on 1 direction
    height_map = height_map_LR;
end

end
