function outStates = doTheShannonShuffle_twoState(states,N)

    L = length(states);

    if nargin < 2 || isempty(N)
        N = L;
    end
    
    vals = unique(states);
    M = length(vals);
    positions = cell(M,M);
    numTimes = zeros(M,M);
    parfor i=1:M
        a = setdiff(find(states == vals(i)),[L-1 L]);
        b = cell(1,M);
        c = zeros(1,M);
        for j=1:M
            q = states(a+1) == vals(j);
            b{j} = a(q);
            c(j) = length(b{j});
        end
        positions(i,:) = b;
        numTimes(i,:) = c;
    end
    
    outStates = zeros(N,1);
    idx = randi(L-2);
    outStates(1) = states(idx);
    outStates(2) = states(idx+1);
    for i=3:N
        a = find(vals==outStates(i-2));
        b = find(vals==outStates(i-1));
        idx = positions{a,b}(randi(numTimes(a,b)));
        outStates(i) = states(idx+2);
    end