function [zValues,zCosts,zGuesses,inConvHull,meanMax,exitFlags] = ...
    findTDistributedProjections_fmin_D(D,yData,perplexity,maxNeighbors,sigmaTolerance)


    readout = 100;
    
    if nargin < 3 || isempty(perplexity)
        perplexity = 24;
    end
    
    if nargin < 5 || isempty(sigmaTolerance)
        sigmaTolerance = 1e-5;
    end
    
    if nargin < 4 || isempty(maxNeighbors)
        maxNeighbors = 200;
    end
    
    
    N = length(D(:,1));
    
    zValues = zeros(N,2);
    zGuesses = zeros(N,2);
    zCosts = zeros(N,1);
    inConvHull = false(N,1);
    meanMax = zeros(N,1);
    exitFlags = zeros(N,1);
    
    options = optimset('Display','off','maxiter',100);
    
    parfor i=1:N
        
        if mod(i,readout) == 0
            fprintf(1,'\t\t Data Point #%6i\n',i);
        end
        
        [~,p] = returnCorrectSigma_sparse(D(i,:),perplexity,sigmaTolerance,maxNeighbors);
        idx = p>0;
        z = yData(idx,:);
        [~,maxIdx] = max(p);
        a = sum(bsxfun(@times,z,p(idx)'));
        
        guesses = [a;yData(maxIdx,:)];
        
        b = zeros(2,2);
        c = zeros(2,1)
        flags = zeros(2,1);
        
        q = convhull(z);
        q = z(q,:);
        
        [b(1,:),c(1),flags(1)] = fminsearch(@(x)calculateKLCost(x,z,p(idx)),guesses(1,:),options);
        [b(2,:),c(2),flags(2)] = fminsearch(@(x)calculateKLCost(x,z,p(idx)),guesses(2,:),options);
        polyIn = inpolygon(b(:,1),b(:,2),q(:,1),q(:,2));
        
        if sum(polyIn) > 0
            pp = find(polyIn);
            [~,mI] = min(c(polyIn));
            mI = pp(mI);
            inConvHull(i) = true;
        else
            [~,mI] = min(c);
            inConvHull(i) = false;
        end
        
        exitFlags(i) = flags(mI);
        zGuesses(i,:) = guesses(mI,:);
        zValues(i,:) = b(mI,:);
        zCosts(i) = c(mI);
        meanMax(i) = mI;
        
        
    end
    
    
    
    
    
    
    