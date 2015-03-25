function posteriors = findPosteriorFromSamples_transitions(samples,transitionMatrices)

    N = length(samples);
    L = length(transitionMatrices);
    M = length(transitionMatrices{1}(:,1));
    
    initialPs = zeros(M,L);
    for i=1:L
        [vecs,vals] = eig(transitionMatrices{i}');
        idx = argmax(diag(vals));
        initialPs(:,i) = vecs(:,idx) ./ sum(vecs(:,idx));
    end
    

    ps = zeros(N,L);
    ps(1,:) = initialPs(samples(1),:);
    for i=2:N
        for j=1:L
            ps(i,j) = transitionMatrices{j}(samples(i-1),samples(i));
        end
    end
    ps(ps<1e-323) = 1e-323;
    
    likelihoods = cumsum(log(ps));
    maxVal = max(likelihoods,[],2);
    probs = exp(bsxfun(@minus,likelihoods,maxVal));
    partition = sum(probs,2);
    
    posteriors = bsxfun(@rdivide,probs,partition);
    
    
    
    