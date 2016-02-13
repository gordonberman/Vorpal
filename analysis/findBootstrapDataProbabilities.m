function probs = findBootstrapDataProbabilities(densities1,densities2,useDensity,parameters)
%determines bootstrap probabilities that densities1 > densities2 at each position in the space
%
%Inputs:
%   densities1 -> L x L x numBootstraps array of density values from
%                   condition 1
%   densities2 -> L x L x numBootstraps array of density values from
%                   condition 2
%   useDensity -> L x L logical matrix of values to compute probabilities
%                   for (1 -> compute probabilities, 0 -> set to default of .5) 
%
%Output:
%   probs -> L x L array of probability values   
%
%
% (C) Gordon J. Berman, 2016
%     Emory University
    


    s = size(densities1);
    
    if nargin < 4
        parameters = [];
    end
    
    parameters = setRunParameters(parameters);

    maxGMM = parameters.maxGMM;
    numReplicates = parameters.numReplicates;
    maxNum = parameters.maxNumSamples;
    numDensityPoints = parameters.numDensityPoints;
    rangeExtension = parameters.rangeExtension;
    readout = 1;
    
    
    probs = zeros(s(1:2));
    for ii=1:s(1);
        if mod(ii,readout) == 0
            fprintf(1,'Processing Line #%4i out of %4i\n',ii,s(1));
        end
        temp = zeros(1,s(2));
        aa = log10(squeeze(densities1(ii,:,:)));
        bb = log10(squeeze(densities2(ii,:,:)));
        cc = useDensity(ii,:);
        parfor jj=1:s(2)
            if cc(jj)
                a = aa(jj,:);
                b = bb(jj,:);
                obj1 = findBestGMM_AIC(a(~isnan(a) & ~isinf(a))',maxGMM,numReplicates,maxNum);
                obj2 = findBestGMM_AIC(b(~isnan(b) & ~isinf(b))',maxGMM,numReplicates,maxNum);
                minVal = min(min(a),min(b));
                maxVal = max(max(a),max(b));
                minVal1 = minVal - rangeExtension*(maxVal - minVal);
                maxVal1 = maxVal + rangeExtension*(maxVal - minVal);
                xx = linspace(minVal1,maxVal1,numDensityPoints);
                [XX,YY] = meshgrid(xx);
                f = @(x,y) pdf(obj1,x).*pdf(obj2,y);
                q = reshape(f(XX(:),YY(:)),[numDensityPoints numDensityPoints]);
                q = triu(q);
                temp(jj) = sum(q(:))*(xx(2)-xx(1))^2;
            else
                temp(jj) = .5;
            end
        end
        probs(ii,:) = temp;
    end