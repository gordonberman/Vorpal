function K = makePartitionPlot(L,partitionIdx,stateDefs,fillSpaces)

    
    if nargin < 4 || isempty(fillSpaces)
        fillSpaces = true;
    end


    q = unique(partitionIdx);
    N = length(q);
    s = size(L);
    
    useStateDefs = nargin > 2 && length(partitionIdx) == length(stateDefs);
    
    K = zeros(s);
    for i=1:N
        idx = partitionIdx == q(i);
        if useStateDefs
            K(ismember(L,stateDefs(idx))) = i;
        else
            K(ismember(L,idx)) = partitionIdx(i);
        end
    end
    
    
    if nargin > 3
        if fillSpaces
            
            mask = false(s);
            a = setdiff(unique(L),0);
            for i=1:length(a)
                B = imdilate(L==a(i),strel('square',2));
                mask = mask | B;
            end
            
            [ii,jj] = find(L == 0 & mask);
            idx = ii > 1 & jj > 1 & ii < s(1) & jj < s(2);
            ii = ii(idx);
            jj = jj(idx);
            
            iAdds = [1;1;1;0;0;-1;-1;-1];
            jAdds = [1;0;-1;1;-1;1;0;-1];
            
            vals = zeros(size(ii));
            for i=1:length(vals)
                q = K(sub2ind(size(K),ii(i)+ iAdds,jj(i) + jAdds));
                vals(i) = mode(q(q>0));
            end
            
            K(sub2ind(size(K),ii,jj)) = vals;
            
        end
    end