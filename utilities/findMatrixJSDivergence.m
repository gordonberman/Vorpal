function JS = findMatrixJSDivergence(A,B,isSigned)

    if nargin < 3 || isempty(isSigned)
        isSigned = false;
    end

           
    m = .5*(A + B);
    d1 = A.*log(A./m)./log(2);
    d2 = B.*log(B./m)./log(2);
    
    %d1(isinf(d1) | isnan(d1)) = 0;
    %d2(isinf(d2) | isnan(d2)) = 0;
    idx = A <= 0 | B <= 0;
    d1(idx | isnan(d1)) = 0;
    d2(idx | isnan(d2)) = 0;
    
    JS = .5*(d1 + d2);
    
    
    if isSigned
        JS = JS .* sign(A - B);
    end