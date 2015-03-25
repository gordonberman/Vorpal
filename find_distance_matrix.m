function D = find_distance_matrix(vocalizations,parameters)

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
        
        for j=(i+1):N
            if ~isempty(dtw_window)
                temp(j) = dtw_c(a,vocalizations(j,:),dtw_window);
            else
                temp(j) = dtw_c(a,vocalizations(j,:));
            end
        end
        
        D(i,:) = temp;
        
    end
    