function out = transitionProbDists(data,D,numStates)


    L = numStates;
    M = max(D(:));
    out = zeros(M+1,1);  
    
    F = zeros(L);
    for i=1:L
        a = data(:,1) == i;
        F(i,:) = hist(data(a,2),1:L);
    end
    F = F ./ sum(F(:));
    
    for i=1:(M+1)
        out(i) = sum(F(D==i-1));
    end
    
    out = cumsum(out);