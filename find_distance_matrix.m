function D = find_distance_matrix(vocalizations,parameters)
%finds distance matrix for an N x d matrix of vocalizations using dynamic
%time warping
%
% (C) Gordon J. Berman, 2015
%     Princeton University

    if nargin < 2
        parameters = [];
    end
    parameters = setRunParameters(parameters);

    dtw_window = parameters.dtw_window;
    
    N = length(vocalizations(:,1));
    
    D = zeros(N);
    for i=1:N
        
        temp = zeros(1,N);
        a = vocalizations(i,:);
        
        parfor j=(i+1):N
            if ~isempty(dtw_window)
                temp(j) = dtw_c(a,vocalizations(j,:),dtw_window);
            else
                temp(j) = dtw_c(a,vocalizations(j,:));
            end
        end
        
        D(i,:) = temp;
        
    end
    