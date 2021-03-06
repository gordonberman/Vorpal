function vocData = loadMouseData(files,isSoloFile,parameters)
% loadMouseData: loads vocalization data and creates a "vocData" data structure
% 
% form:  vocData = loadMouseData(files,isSoloFile,parameters)
%
% Inputs:
%   files -> cell array (L x 1) of .mat files containing vocalization data
%   isSoloFile -> L x 1 binary array, true if no female present, false
%                   otherwise
%   parameters -> struct containing non-default parameter values
%
% Output:
%  vocData -> vocalization database 
%
% input file format:    a .mat file with a cell array of experiments,
%                       each element has two fields, .exptName, which is a string
%                       and .vocs, which is a cell array, each element of
%                       which is a 3 row, N col matrix, where row 1 is time
%                       in the frequency contour, row 2 is frequency and
%                       row 3 is amplitude.  Frequency contours like this
%                       are produced by Ax (https://github.com/JaneliaSciComp/Ax)
% 
% (C) Gordon J. Berman, 2016
%     Emory University

    addpath('./utilities');

    if nargin < 3
        parameters = [];
    end
    parameters = setRunParameters(parameters);

    numPoints = parameters.numPoints;

    L = length(files);
    
    lengths = zeros(L,1);
    data = cell(L,1);
    experimentNames = cell(L,1);
    individualNames = cell(L,1);
    numVocs = zeros(L,1);
    min_voc_length = parameters.min_voc_length;
    
    fprintf(1,'Initializing\n');
    for i=1:L
        
        a = load(files{i});
        f = fieldnames(a);
        data{i} = a.(f{1});
        lengths(i) = length(data{i});

        experimentNames{i} = cell(lengths(i),1);
        individualNames{i} = cell(lengths(i),1);
        tempVocs = zeros(lengths(i),1);
        
        for j=1:lengths(i)    
            experimentNames{i}{j} = data{i}(j).exptName;
            idx = find(experimentNames{i}{j} == '_');
            individualNames{i}{j} = experimentNames{i}{j}(1:idx(1)-1);        
            tempVocs(j) = length(data{i}(j).vocs);
        end
        
        numVocs(i) = sum(tempVocs);
    
    end
    
    totalNumberVocalizations = sum(numVocs);
    
    vocData.N = totalNumberVocalizations;
    vocData.lengths = lengths;
    vocData.numVocs = numVocs;
    
    
    fprintf(1,'Loading Vocalizations\n');
    times = cell(totalNumberVocalizations,1);
    amps = cell(totalNumberVocalizations,1);
    vocs = cell(totalNumberVocalizations,1);
    exptNames = cell(totalNumberVocalizations,1);
    indNames = cell(totalNumberVocalizations,1);
    meanValues = zeros(totalNumberVocalizations,1);
    bandwidths = zeros(totalNumberVocalizations,1);
    durations = zeros(totalNumberVocalizations,1);
    normalizedVocs = cell(totalNumberVocalizations,1);
    isSolo = false(totalNumberVocalizations,1);
    
    count = 1;   
    for i=1:L
         
        fprintf(1,'Loading Vocalizations from File #%3i out of %3i\n',i,L);
        
        for j=1:lengths(i)
            
            for k=1:length(data{i}(j).vocs)
                
                if length(data{i}(j).vocs{k}(1,:)) >= min_voc_length
                    
                    times{count} = data{i}(j).vocs{k}(1,:);
                    vocs{count} = data{i}(j).vocs{k}(2,:);
                    amps{count} = data{i}(j).vocs{k}(3,:);
                    
                    exptNames{count} = experimentNames{i}{j};
                    indNames{count} = individualNames{i}{j};
                    
                    idx2 = ~isnan(vocs{count}) & ~isinf(vocs{count});
                    durations(count) = max(times{count}) - min(times{count});
                    bandwidths(count) = max(vocs{count}(idx2)) - min(vocs{count}(idx2));
                    meanValues(count) = trapz(times{count}(idx2),vocs{count}(idx2))/durations(count);
                    isSolo(count) = isSoloFile(i);
                    
                    idx = find([1 diff(times{count})]~=0 & idx2);
                    x = vocs{count}(idx) - meanValues(count);
                    t = times{count}(idx);
                    
                    normalizedVocs{count} = interp1(t,x,linspace(t(1),t(end),numPoints));
                    
                    count = count + 1;
                end
            end
            
        end
        
    end
    
    idx = returnCellLengths(vocs) > 0;
    
    [vocData.experimentNames,~,vocData.experimentNumbers] = unique(exptNames(idx));
    [vocData.individualNames,~,vocData.individualNumbers] = unique(indNames(idx));
    vocData.times = times(idx);
    vocData.vocs = vocs(idx);
    vocData.amps = amps(idx);
    vocData.durations = durations(idx);
    vocData.bandwidths = bandwidths(idx);
    vocData.meanValues = meanValues(idx);
    vocData.normalizedVocs = cell2mat(normalizedVocs(idx,:));
    vocData.numPoints = numPoints;
    vocData.isSolo = isSolo(idx);
    vocData.inTrainingSet=true(size(vocData.isSolo)); % added by RE, eventually be able to select a subbset of a large dataset for training
    vocData.numVocs = sum(idx);
    
    
    
    
    
    
    
    
    