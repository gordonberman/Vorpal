function densities = findBootstrappedDensities(zValues,xx,sigma,numBootstraps)
%generates a set of bootstrap densities for statistical significance testing 
%
%Inputs:
%   zValues -> N x 2 array of embedding values from a particular experimental condition
%   x -> L x 1 array of point values 
%   sigma -> smoothing window for kernel density estimation
%   numBootstraps -> number of sample distributions to create
%
%Output:
%   densities -> L x L x numBootstraps array of density values   
%
%
% (C) Gordon J. Berman, 2016
%     Emory University
    

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