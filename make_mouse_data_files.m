function expt_freq_contours=make_mouse_data_files(output_filename,varargin)
% make_mouse_data_files: function to take Ax .fc files and make an input
% file for Vorpal
%
% form: make_mouse_data_files(output_filename,fc_filenames)
%
% output_filename: is the name of the file to save the data to
% 
% optional input: fc_filenames is a cell array with the fc filenames 
% to include in the Vorpal data file, if it is ommitted all the .fc files
% in the current directory will be used.
%
% will use new_freq_contours if it exists (manually corrected file),
% otherwise will use freq_contours
%
% each file should be only one format (isSolo==1 or 0)


if isempty(varargin)==1
    a=dir;
    b=extract_struct_field(a,'name','.fc');
    fc_filenames=cell(length(b),1);
    for i=1:length(b)
        fc_filenames{i}=b(i).name;
    end;
end;  

[expt_freq_contours(1:length(fc_filenames)).exptName]=deal([]);

for i=1:length(fc_filenames)
    
    % load in each fc file
    disp(['loading ' fc_filenames{i}]);
    load(fc_filenames{i},'-mat');
    expt_freq_contours(i).exptName=fc_filenames{i};
    
    if exist('new_freq_contours','var')
        expt_freq_contours(i).vocs=[new_freq_contours{:}];  
    elseif exist('freq_contours','var')
        expt_freq_contours(i).vocs=[freq_contours{:}];  
    else
        disp('this is not an .fc file');
    end;

    for j=1:length(expt_freq_contours(i).vocs)
        expt_freq_contours(i).vocs{j}=expt_freq_contours(i).vocs{j}'/1000; % rotate and switch to kHz from Hz
    end;

    clear freq_contours; clear new_freq_contours;
end;


save(output_filename,'expt_freq_contours');



function out=extract_struct_field(struct_variable,field_name,field_value)
j=1;

for i=1:length(struct_variable)
    tempstring=['cur_field=struct_variable(i).' field_name ';'];
    eval(tempstring);
    if isempty(strfind(cur_field,field_value))==0
        out(j,1).name=cur_field;
        j=j+1;
    end;
end;

if exist('out')==0
    out.name='no values';
end;