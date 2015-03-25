files23_aso = findImagesInFolder('/Users/gberman/Dropbox/Manuscripts/mouse_vocs_2014/corrected_parkinsons_data/aso_2_3_mo/','fc');
files23_wt = findImagesInFolder('/Users/gberman/Dropbox/Manuscripts/mouse_vocs_2014/corrected_parkinsons_data/wt_2_3_mo/','fc');
files67_aso = findImagesInFolder('/Users/gberman/Dropbox/Manuscripts/mouse_vocs_2014/corrected_parkinsons_data/aso_6_7_mo/','fc');
files67_wt = findImagesInFolder('/Users/gberman/Dropbox/Manuscripts/mouse_vocs_2014/corrected_parkinsons_data/wt_6_7_mo/','fc');

all_files = [files23_aso;files23_wt;files67_aso;files67_wt];



aso_23_vocs = cell(length(files23_aso),1);
for i=1:length(files23_aso)
    
    load(files23_aso{i},'-mat','freq_contours');
    aso_23_vocs{i} = freq_contours';
    
    clear freq_contours
    
end

aso_23_lengths = returnCellLengths(aso_23_vocs);
aso_23_data = combineCells_toCell(aso_23_vocs);

N_23_aso = sum(aso_23_lengths);
aso_23_times = cell(N_23_aso,1);
aso_23_vocs = cell(N_23_aso,1);
aso_23_amps = cell(N_23_aso,1);
for i=1:N_23_aso
    if ~isempty(aso_23_data{i})
        idx = [1; diff(aso_23_data{i}{1}(:,1))] ~= 0;
        idx = idx & ~isnan(aso_23_data{i}{1}(:,2));
        aso_23_times{i} = aso_23_data{i}{1}(idx,1)';
        aso_23_vocs{i} = aso_23_data{i}{1}(idx,2)';
        aso_23_amps{i} = aso_23_data{i}{1}(idx,3)';
    end
end




wt_23_vocs = cell(length(files23_wt),1);
for i=1:length(files23_wt)
    
    load(files23_wt{i},'-mat','freq_contours');
    wt_23_vocs{i} = freq_contours';
    
    clear freq_contours
    
end

wt_23_lengths = returnCellLengths(wt_23_vocs);
wt_23_data = combineCells_toCell(wt_23_vocs);

N_23_wt = sum(wt_23_lengths);
wt_23_times = cell(N_23_wt,1);
wt_23_vocs = cell(N_23_wt,1);
wt_23_amps = cell(N_23_wt,1);
for i=1:N_23_wt
    if ~isempty(wt_23_data)
        idx = [1; diff(wt_23_data{i}{1}(:,1))] ~= 0;
        idx = idx & ~isnan(wt_23_data{i}{1}(:,2));
        wt_23_times{i} = wt_23_data{i}{1}(idx,1)';
        wt_23_vocs{i} = wt_23_data{i}{1}(idx,2)';
        wt_23_amps{i} = wt_23_data{i}{1}(idx,3)';
    end
end





aso_67_vocs = cell(length(files67_aso),1);
for i=1:length(files67_aso)
    
    load(files67_aso{i},'-mat','freq_contours');
    aso_67_vocs{i} = freq_contours';
    
    clear freq_contours
    
end

aso_67_lengths = returnCellLengths(aso_67_vocs);
aso_67_data = combineCells_toCell(aso_67_vocs);


N_67_aso = sum(aso_67_lengths);
aso_67_times = cell(N_67_aso,1);
aso_67_vocs = cell(N_67_aso,1);
aso_67_amps = cell(N_67_aso,1);
for i=1:N_67_aso
    if ~isempty(aso_67_data)
        idx = [1; diff(aso_67_data{i}{1}(:,1))] ~= 0;
        idx = idx & ~isnan(aso_67_data{i}{1}(:,2));
        aso_67_times{i} = aso_67_data{i}{1}(idx,1)';
        aso_67_vocs{i} = aso_67_data{i}{1}(idx,2)';
        aso_67_amps{i} = aso_67_data{i}{1}(idx,3)';
    end
end




wt_67_vocs = cell(length(files67_wt),1);
for i=1:length(files67_wt)
    
    load(files67_wt{i},'-mat','freq_contours');
    wt_67_vocs{i} = freq_contours';
    
    clear freq_contours
    
end

wt_67_lengths = returnCellLengths(wt_67_vocs);
wt_67_data = combineCells_toCell(wt_67_vocs);


N_67_wt = sum(wt_67_lengths);
wt_67_times = cell(N_67_wt,1);
wt_67_vocs = cell(N_67_wt,1);
wt_67_amps = cell(N_67_wt,1);
for i=1:N_67_wt
    if ~isempty(wt_67_data)
        idx = [1; diff(wt_67_data{i}{1}(:,1))] ~= 0;
        idx = idx & ~isnan(wt_67_data{i}{1}(:,2));
        wt_67_times{i} = wt_67_data{i}{1}(idx,1)';
        wt_67_vocs{i} = wt_67_data{i}{1}(idx,2)';
        wt_67_amps{i} = wt_67_data{i}{1}(idx,3)';
    end
end





N = N_23_wt + N_23_aso + N_67_aso + N_67_wt;    
all_vocs = [aso_23_vocs; wt_23_vocs; aso_67_vocs; wt_67_vocs];
all_times = [aso_23_times; wt_23_times; aso_67_times; wt_67_times];
all_amps = [aso_23_amps; wt_23_amps; aso_67_amps; wt_67_amps];
all_lengths = [aso_23_lengths; wt_23_lengths; aso_67_lengths; wt_67_lengths];


isWT = [false(N_23_aso,1);true(N_23_wt,1);false(N_67_aso,1);true(N_67_wt,1)];
is23 = [true(N_23_aso+N_23_wt,1); false(N_67_aso + N_67_wt,1)];

dataSetNumber = zeros(N,1);
count = 1;
for i=1:length(all_files)
    L = all_lengths(i);
    dataSetNumber(count + (1:L) - 1) = i;
    count = count + L;
end


numPoints = 100;
xx = linspace(0,1,numPoints);
normalized_vocs = zeros(N,numPoints);
meanValues = zeros(N,1);
durations = zeros(N,1);


parfor i=1:N
   
    a = all_times{i};
    b = all_vocs{i};
    durations(i) = a(end) - a(1);
    
    f = fit((a'-a(1))/durations(i),b','linearinterp');
    normalized_vocs(i,:) = f(xx);
    meanValues(i) = trapz(xx,normalized_vocs(i,:));
    normalized_vocs(i,:) = normalized_vocs(i,:) - meanValues(i);
    
end


clear i idx aso_23_vocs wt_23_vocs aso_67_vocs wt_67_vocs
clear aso_23_times wt_23_times aso_67_times wt_67_times
clear aso_23_amps wt_23_amps aso_67_amps wt_67_amps
clear aso_23_lengths wt_23_lengths aso_67_lengths wt_67_lengths
clear files23_aso files23_wt files67_aso files67_wt
clear wt_67_data wt_23_data aso_67_data aso_23_data count L
























