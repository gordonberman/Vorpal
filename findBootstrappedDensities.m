function densities = findBootstrappedDensities(zValues,xx,sigma,numBootstraps)

    L = length(xx);
    numPoints = length(xx);
    rangeVals = [xx(1) xx(end)];
    N = length(zValues(:,1));
    
    densities = zeros(L,L,numBootstraps);
    
    parfor i=1:numBootstraps
        
        a = zValues;
        b = a(randi(N,[N 1]),:);

        [~,densities(:,:,i)] = findPointDensity(b,sigma,numPoints,rangeVals);
                
    end