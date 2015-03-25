function outStates = doTheShannonShuffle(states,N)

    L = length(states);

    if nargin < 2 || isempty(N)
        N = L;
    end
    
    vals = unique(states);
    M = length(vals);
    positions = cell(M,1);
    numTimes = zeros(M,1);
    parfor i=1:M
        positions{i} = setdiff(find(states == vals(i)),L);
        numTimes(i) = length(positions{i});
    end
    
    outStates = zeros(N,1);
    outStates(1) = states(randi(L-1));
    for i=2:N
        a = find(vals==outStates(i-1));
        idx = positions{a}(randi(numTimes(a)));
        outStates(i) = states(idx+1);
    end