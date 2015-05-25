function out = combineCells_toCell(x,dim,d)

    lengths = returnCellLengths(x);
    x = x(lengths > 0);
    lengths = lengths(lengths > 0);
    
    if isempty(x)
        
        out = {};
        
    else
        
        L = length(x);
        [~,maxIdx] = max(lengths);
        s = size(x{maxIdx});
        
        if nargin < 2 || isempty(dim)
            dim = argmax(s);
        end
        
        if dim == 1
            
            if nargin  < 3 || isempty(d)
                d = s(2);
            end
            lengths = lengths ./ d;
            s2 = size(lengths);
            if s2(2) > s2(1)
                lengths = lengths';
            end
            cVals = [0; cumsum(lengths)];
            
            out = cell(cVals(end),d);
            
            for i=1:L
                if ~isempty(x{i})
                    out(cVals(i)+1:cVals(i+1),:) = x{i};
                end
            end
            
        else
            
            if nargin  < 3 || isempty(d)
                d = s(1);
            end
            lengths = lengths ./ d;
            s2 = size(lengths);
            if s2(1) > s2(2)
                lengths = lengths';
            end
            cVals = [0 cumsum(lengths)];
            
            
            out = cell(d,cVals(end));
            
            for i=1:L;
                if ~isempty(x{i})
                    out(:,cVals(i)+1:cVals(i+1)) = x{i};
                end
            end
            
        end
        
    end