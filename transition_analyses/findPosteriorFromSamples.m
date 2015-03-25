function posteriors = findPosteriorFromSamples(samples,xVals,yVals,densities)

    N = length(samples(:,1));
    L = length(densities);
    s = size(densities{1});
    
    fs = cell(L,1);
    ps = zeros(N,L);
    for i=1:L
        fs{i} = @(x,y) interp2(xVals,yVals,densities{i},x,y);
        ps(:,i) = fs{i}(samples(:,1),samples(:,2));
    end
    ps(ps<1e-323) = 1e-323;
    
    likelihoods = cumsum(log(ps));
    maxVal = max(likelihoods,[],2);
    probs = exp(bsxfun(@minus,likelihoods,maxVal));
    partition = sum(probs,2);
    
    posteriors = bsxfun(@rdivide,probs,partition);
    
    
    
    