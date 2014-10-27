% Indranil Deb 50097062
% CSE 473/573 Programming Assignment 1 : Main Runfile 
% NOTE : the folders part1 and part2 must be present in the same folder where
% this script is present.

% This script runs both parts of the Assignment. Please enter the BGR plate
% name and subject name in line number 14 and 15 respectively.
% Please enter which part of the assignment to run according to instuctions in line 13 
% Also if you want to run everything in a single run, set the flag in line 21 to true

function [] = runfile_hw1(~)

enter_which_part_to_run = 'one'; % values are 'one' for part1, 'two' for part2, 'both' for both parts
enter_part_1_image_name = 'part1_1.jpg';  % enter the image to be processed
enter_part_2_subject_name = 'yaleB01';  % enter the subject name

% if set to true the program will save the outputs
save_flag = false;
% If we want to process all images and subjects in a single run. If this is set to true all images and subjects will be processed
% irrespective of whatever is entered in enter_part_1_image_name and enter_part_2_subject_name
process_all_in_dir = false;

if (process_all_in_dir == false)
    part_1_image_name = enter_part_1_image_name;
    part_2_subject_name = {enter_part_2_subject_name};
else
    % this need not be changed
    part_1_image_name = 'part1_*.jpg';
    part_2_subject_name = {'yaleB01'; 'yaleB02'; 'yaleB05'; 'yaleB07'};
end

% Execute the first part of the assignment
if (strcmp(enter_which_part_to_run,'one') ...
        || strcmp(enter_which_part_to_run,'both'))
    main_folder = cd('part1');
    runfile_hw1_1(save_flag, part_1_image_name);
    cd(main_folder)
end

% Execute the second part of the assignment
if (strcmp(enter_which_part_to_run,'two') ...
        || strcmp(enter_which_part_to_run,'both'))
    main_folder = cd('part2');
    for i = 1 : size(part_2_subject_name)
        runfile_hw1_2(save_flag, part_2_subject_name{i});
    end
    cd(main_folder)
end

end