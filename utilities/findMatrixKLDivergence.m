function [KL,KLsum] = findMatrixKLDivergence(A,B,symmetric,isSigned)

    if nargin < 3 || isempty(symmetric)
        symmetric = false;
    end
    
    if nargin < 4 || isempty(isSigned)
        isSigned = false;
    end
    
    
    KL = A.*log(A./B)./log(2);
    
    if symmetric
        KL = KL + B.*log(B./A)./log(2);
        KL = KL./2;
    end
    
    KL( A<=0 | B<=0) = 0;
        
    if nargout > 1
        KLsum = sum(KL(:));
    end
    
    if isSigned
        KL = KL .* sign(A-B);
    end
    
    