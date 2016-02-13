function [probs,densities1,densities2] = ...
    runPairwiseBootstrap(zValues,indicator,numBootstraps,xx,sigma,minDensity)


    fprintf(1,'\t Calculating Bootstrap Densities #1\n');
    densities1 = findBootstrappedDensities(zValues(indicator,:),xx,sigma,numBootstraps);
    fprintf(1,'\t Calculating Bootstrap Densities #2\n');
    densities2 = findBootstrappedDensities(zValues(~indicator,:),xx,sigma,numBootstraps);
    
    useDensity = .5*mean(densities1,3) + .5*mean(densities2) > minDensity;
    
    fprintf(1,'\t Calculating Bootstrap Probabilities\n');
    probs = findBootstrapDataProbabilities(densities1,densities2,useDensity);