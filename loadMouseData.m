function vocData = loadMouseData(files,isSoloFile,parameters)

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
                       
            for k=1:length(data{i}(j).vocs);
                times{count} = data{i}(j).vocs{k}(1,:);
                vocs{count} = data{i}(j).vocs{k}(2,:);
                amps{count} = data{i}(j).vocs{k}(3,:);
                
                exptNames{count} = experimentNames{i}{j};
                indNames{count} = individualNames{i}{j};
                
                durations(count) = max(times{count}) - min(times{count});
                bandwidths(count) = max(vocs{count}) - min(vocs{count});
                meanValues(count) = trapz(times{count},vocs{count})/durations(count);
                isSolo(count) = isSoloFile(i);
                
                idx = find([1 diff(times{count})]~=0);
                x = vocs{count}(idx) - meanValues(count);
                t = times{count}(idx);
                a = fit(t',x','linearinterp');
                normalizedVocs{count} = a(linspace(t(1),t(end),numPoints))';
                
                count = count + 1;
            end
            
        end
        
    end
    

    
    [vocData.experimentNames,~,vocData.experimentNumbers] = unique(exptNames);
    [vocData.individualNames,~,vocData.individualNumbers] = unique(indNames);
    vocData.times = times;
    vocData.vocs = vocs;
    vocData.amps = amps;
    vocData.durations = durations;
    vocData.bandwidths = bandwidths;
    vocData.meanValues = meanValues;
    vocData.normalizedVocs = cell2mat(normalizedVocs);
    vocData.numPoints = numPoints;
    vocData.isSolo = isSolo;
    
    
    
    
    
    
    
    
    
    