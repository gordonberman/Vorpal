function D = find_distance_matrix(vocalizations,parameters)
%finds distance matrix for an N x d matrix of vocalizations using dynamic
%time warping
%
% (C) Gordon J. Berman, 2016
%     Emory University


    if nargin < 2
        parameters = [];
    end
    parameters = setRunParameters(parameters);

    dtw_window = parameters.dtw_window;
    
    N = length(vocalizations(:,1));
    
    cellData = iscell(vocalizations);
    D = zeros(N);
    for i=1:N
        
        if mod(i,100) == 0
            fprintf(1,'Data Point #%5i out of %5i\n',i,N);
        end
        
        temp = zeros(1,N);
        if ~cellData
            a = vocalizations(i,:);
        else
            a = vocalizations{i};
        end
        
        parfor j=(i+1):N
            if ~cellData
                b = vocalizations(j,:);
            else
                b = vocalizations{j};
            end
            if ~isempty(dtw_window)
                temp(j) = dtw_c(a,b,dtw_window);
            else
                temp(j) = dtw_c(a,b);
            end
        end
        
        D(i,i+1:N) = temp(i+1:N);
        D(i+1:N,i) = temp(i+1:N);
        
    end
    

    