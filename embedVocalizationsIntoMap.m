function [zValues,inConvHull,zGuesses,zCosts] = ...
       embedVocalizationsIntoMap(newVocs,yData,signalData,parameters)
            

    addpath('utilities/');
    addpath('t_sne/');
    readout = 100;
    
    if nargin < 4 
        parameters = [];
    end
    parameters = setRunParameters(parameters);
    
    N = length(newVocs(:,1));
    M = length(yData(:,1));
    sigmaTolerance = parameters.sigmaTolerance;
    maxNeighbors = parameters.maxNeighbors;
    perplexity = parameters.perplexity;
    dtw_window = parameters.dtw_window;
    
    fprintf(1,'Finding Distances\n');
    D = zeros(N,M);
    for i=1:N
        
        if mod(i,readout) == 0
            fprintf(1,'\t Vocalization #%6i out of %6i\n',i,N);
        end
        
        a = newVocs(i,:);
        temp = zeros(1,M);
        parfor j=1:M
            if ~isempty(dtw_window)
                temp(j) = dtw_c(a,signalData(j,:),dtw_window);
            else
                temp(j) = dtw_c(a,signalData(j,:));
            end
        end
        
        D(i,:) = temp;
        
    end
    
    
    fprintf(1,'Finding Embeddings\n');
    [zValues,zCosts,zGuesses,inConvHull,~,~] = ...
        findTDistributedProjections_fmin_D(D,yData,perplexity,...
        maxNeighbors,sigmaTolerance);
    
    
            