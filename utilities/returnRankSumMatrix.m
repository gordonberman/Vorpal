function rankSums = returnRankSumMatrix(densities1,densities2,idxToCheck,tail)

    s = size(densities1);
    if nargin < 3 || isempty(idxToCheck)
        idxToCheck = true(s(1:2));
    end

    if nargin < 4 || isempty(tail)
        tail = 'both';
    end
    
    rankSums = zeros(s(1:2));
    [ii, jj] = find(idxToCheck);
    rankSumVals = zeros(size(ii));
    parfor i=1:length(ii)
        a = squeeze(densities1(ii(i),jj(i),:));
        b = squeeze(densities2(ii(i),jj(i),:));
        rankSumVals(i) = ranksum(a,b,'tail',tail);
    end
    
    rankSums(idxToCheck) = rankSumVals;
    
    