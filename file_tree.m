%Matlab file tree recursion - Joshua Chiu

clear all 
close all
clc
global lf tp;
bd = input(['What directory tree do you want to list? Copy the', ...
    'path in C:\\\Directory format: '], 's');
lf = input('Do you want to list folders in addition to files? Default is no. (y/n): ','s');
tp = input(['Do you want to print the list to console as we go along?', ...
    ' This can take a long time for long directory trees! Default is no. (y/n): '], 's');
data = struct('folder', {bd}, 'text_out', {{}}, 'den_fold', {{}}, ...
'fold_ct', {0}, 'file_ct', {0}, 'den_ct', {0})

fprintf('%s\n',bd)
output = recursive_tree(data); 

fprintf('There were %d files and %d folders.', output.file_ct, output.fold_ct)
fprintf('There were %d permission denials.', output.den_ct)

function return_data = recursive_tree(data)
global lf tp;
try
    cd(data.folder) %base_directory
    d_c = dir; %directory contents
    f_i = [d_c(:).isdir];
    files = {d_c(~f_i).name}';
    data.file_ct = data.file_ct + length(files);
    data.text_out = vertcat(data.text_out, cellstr(files)); %add files to storage

    if tp == 'y' %if user wants to print to console
        if lf == 'y'
            fprintf('       %s\n', files{:}) %add spaces to distinguish files
        else
            fprintf('%s\n', files{:})
        end 
    end

    folders = {d_c(f_i).name}';
    folders =  folders(~ismember(folders,{'.','..'}),:); %filters . and .. entries

    for i = 1:size(folders)

        target = fullfile(pwd, string(folders(i,:)));
        if lf == 'y'
            data.fold_ct = data.fold_ct + 1;
            if tp == 'y'
                fprintf('%s\n', target{:})
            end
        end
        data.folder = target{:}; %update directory before calling
        data = recursive_tree(data);
    end 
   cd .. %only need to cd .. if try worked 
   
   catch exception
       if strcmp(exception.identifier, 'MATLAB:cd:PermissionDenied')
           disp(data.folder)
           fprintf('Permission denied for the following folder: %s\n', ...
               data.folder)
           data.den_ct = data.den_ct + 1;     
       end
end
return_data = data;
end