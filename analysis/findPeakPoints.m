function peakPoints = findPeakPoints(L,density,xx)

    q = setdiff(unique(L(:)),0);
    N = length(q);
    s = size(density);
    
    hasScale = nargin > 2;
    
    peakPoints = zeros(N,2);
    for i=1:N
       
        Q = zeros(s);
        idx = L == q(i);
        Q(idx) = density(idx);
        
        [ii,jj] = find(Q == max(Q(:)));
        if length(ii) > 1
            w = randi(length(ii));
            ii = ii(w);
            jj = jj(w);
        end
        
        if hasScale
            peakPoints(i,:) = xx([jj ii]);
        else
            peakPoints(i,:) = [jj ii];
        end
        
    end