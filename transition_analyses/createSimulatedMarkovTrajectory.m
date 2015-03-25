function states = createSimulatedMarkovTrajectory(T,densities,N)

    %T_ij is P(x_{t+1} = j | x_t = i)

    states = zeros(N,1);
    cumDensity = cumsum(densities) / sum(densities);
    cumTs = bsxfun(@rdivide,cumsum(T,2),sum(T,2));
    
    randNums = rand(N,1);
    
    states(1) = find(cumDensity > randNums(1),1,'first');
    
    for i=2:N
        if mod(i,1e6) == 0
            i
        end
        states(i) = find(cumTs(states(i-1),:) > randNums(i),1,'first');
        
    end