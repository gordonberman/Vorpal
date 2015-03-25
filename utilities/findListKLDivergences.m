function [D,entropies] = findListKLDivergences(data,data2)

    %N = length(data(:,1));
    %M = length(data2(:,1));
    logData = log2(data);
    logData(isnan(logData) | isinf(logData)) = 0;
    
    entropies = -sum(data.*logData,2);
    clear logData;  

    logData2 = log2(data2);  
    logData2(isnan(logData2) | isinf(logData2)) = 0;

    D = - data * logData2';
    
    
    D = bsxfun(@minus,D,entropies); 
