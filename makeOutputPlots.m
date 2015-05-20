function outputStats = makeOutputPlots(vocData,parameters)
%Makes output plots from vocData structure
%
%
% (C) Gordon J. Berman, 2015
%     Princeton University


    addpath('utilities');
    addpath('analysis');
    
    load('saved_colormaps.mat');
    
    if nargin < 2 || isempty(parameters)
        parameters = setRunParameters([]);
    else
        %         p = vocData.parameters;
        %         a = fieldnames(parameters);
        %         for i=1:length(a)
        %             p.(a{i}) = parameters.(a{i});
        %         end
        parameters = setRunParameters(parameters);
    end
    
    
    outputStats.parameters = parameters;
    
    fprintf(1,'Calculating Densities\n');
    yData = vocData.yData;
    sigma = parameters.sigma;
    numPoints = parameters.numPoints;
    maxVal = ceil(3*sigma + max(abs(yData(:)))/5)*5;
    [xx,density] = findPointDensity(yData,sigma,numPoints,[-maxVal maxVal]);
    
    outputStats.xx = xx;
    outputStats.density = density;
    outputStats.numPoints = numPoints;
    outputStats.sigma = sigma;
    outputStats.maxVal = maxVal;
    
    %     figure
    %     imagesc(xx,xx,density)
    %     maxDensity = round(max(density(:))*.8/5e-5)*5e-5;
    %     axis equal tight off xy
    %     colormap(cc)
    %     caxis([0 maxDensity]);
    %     colorbar
    %     set(gca,'fontsize',14,'fontweight','bold')
    %     title('Overall Density','fontsize',18,'fontweight','bold')
    %     drawnow
    
    
    isSolo = vocData.isSolo;
    numIndividuals = max(vocData.individualNumbers);
    outputStats.numIndividuals = numIndividuals;
    
    individualUrineDensities = zeros(numPoints,numPoints,numIndividuals);
    individualFemaleDensities = zeros(numPoints,numPoints,numIndividuals);
    numUrineCalls = zeros(numIndividuals,1);
    numFemaleCalls = zeros(numIndividuals,1);
    for i=1:numIndividuals
        
        temp = yData(isSolo & vocData.individualNumbers == i,:);
        numUrineCalls(i) = length(temp(:,1));
        if ~isempty(temp)
            [~,individualUrineDensities(:,:,i)] = ...
                findPointDensity(temp,sigma,numPoints,[-maxVal maxVal]);
        end
        
        temp = yData(~isSolo & vocData.individualNumbers == i,:);
        numFemaleCalls(i) = length(temp(:,1));
        if ~isempty(temp)
            [~,individualFemaleDensities(:,:,i)] = ...
                findPointDensity(temp,sigma,numPoints,[-maxVal maxVal]);
        end
        
    end
    
    outputStats.individualUrineDensities = individualUrineDensities;
    outputStats.individualFemaleDensities = individualFemaleDensities;
    outputStats.numUrineCalls = numUrineCalls;
    outputStats.numFemaleCalls = numFemaleCalls;
    
    
    outputStats.median_female_density = median(individualFemaleDensities,3);
    outputStats.median_urine_density = median(individualUrineDensities,3);
    outputStats.mean_female_density = mean(individualFemaleDensities,3);
    outputStats.mean_urine_density = mean(individualUrineDensities,3);
    
    
    fprintf(1,'Finding Significant Regions\n');
    A = -density.*log2(density);
    entropy = sum(A(~isnan(A) & ~isinf(A)))*(xx(2)-xx(1))^2;
    numComparisons = round(2^entropy);
    alpha = 1 - (1-parameters.sigAlpha)^(1/numComparisons);
    
    outputStats.alpha = alpha;
    outputStats.entropy = entropy;
    outputStats.numComparisons = numComparisons;
    outputStats.sigAlpha = parameters.sigAlpha;
    outputStats.minDensity = parameters.minDensity;
    
    [ii,jj] = find(density > outputStats.minDensity);
    rankSumPValues = zeros(numPoints,numPoints);
    rankSumPValues(~(density > outputStats.minDensity)) = 1;
    temp = zeros(size(ii));
    for i=1:length(ii)
        temp(i) = ranksum(squeeze(individualUrineDensities(ii(i),jj(i),:)),...
            squeeze(individualFemaleDensities(ii(i),jj(i),:)));
    end
    rankSumPValues(density > outputStats.minDensity) = temp;
    clear temp
    
    outputStats.rankSumPValues = rankSumPValues;
    outputStats.significanceMap = rankSumPValues < alpha;
    
    regions = bwlabel(outputStats.significanceMap);
    outputStats.region = regions;
    
    B = bwboundaries(density > parameters.minDensity);
    
    a = max(max(outputStats.median_female_density(:)),max(outputStats.median_male_density(:)));
    maxDensity = round(a*.8/5e-5)*5e-5;
    
    figure
    subplot(1,3,1)
    imagesc(xx,xx,outputStats.median_urine_density)
    axis equal tight off xy
    colormap(cc)
    caxis([0 maxDensity]);
    colorbar
    hold on
    plot(xx(B{1}(:,2)),xx(B{1}(:,1)),'k-','linewidth',3)
    set(gca,'fontsize',14,'fontweight','bold')
    title('Urine-Elicited','fontsize',16,'fontweight','bold')
    freezeColors
    
    subplot(1,3,2)
    imagesc(xx,xx, outputStats.median_female_density)
    axis equal tight off xy
    colormap(cc)
    caxis([0 maxDensity]);
    colorbar
    hold on
    plot(xx(B{1}(:,2)),xx(B{1}(:,1)),'k-','linewidth',3)
    set(gca,'fontsize',14,'fontweight','bold')
    title('Female-Elicited','fontsize',16,'fontweight','bold')
    freezeColors
    
    subplot(1,3,3)
    imagesc(xx,xx, outputStats.median_female_density - outputStats.median_urine_density)
    axis equal tight off xy
    colormap(cc2)
    caxis([-maxDensity maxDensity]);
    colorbar
    hold on
    plot(xx(B{1}(:,2)),xx(B{1}(:,1)),'k-','linewidth',3)
    if sum(regions(:)) > 0
        for i=1:max(regions(:))
            BB = bwboundaries(regions == i);
            if ~isempty(BB)
               plot(xx(BB{1}(:,2)),xx(BB{1}(:,1)),'k--','linewidth',2) 
            end
        end
    end
    set(gca,'fontsize',14,'fontweight','bold')
    title('Difference','fontsize',16,'fontweight','bold')
    freezeColors
    drawnow
   
    
    fprintf('Finding Watershed Regions\n');
    
    L = watershed(-density,8);
    LL = L;
    LL(density < parameters.minDensity) = 0;
    a = setdiff(unique(LL),0);
    for i=1:length(a)
        LL(LL == a(i)) = i;
    end
    
    outputStats.watershedMap = LL;
    outputStats.numRegions = max(LL(:));
    
    figure
    subplot(1,2,1)
    imagesc(xx,xx,density)
    axis equal tight off xy
    maxDensity = round(max(density(:))*.8/5e-5)*5e-5;
    caxis([0 maxDensity]);
    
    subplot(1,2,2)
    imagesc(xx,xx,LL)
    hold on
    axis equal tight off xy
    colormap(cc)
    title('Watershed Region Map','fontsize',16,'fontweight','bold')
    
    peakPoints = findPeakPoints(LL,density,xx);
    
    for i=1:outputStats.numRegions      
        idx = LL == i;
        BB = bwboundaries(idx);
        for j=1:2
            subplot(1,2,j)
            hold on
            plot(xx(BB{1}(:,2)),xx(BB{1}(:,1)),'k-','linewidth',2)
        end
        
        y = peakPoints(i,1);
        x = peakPoints(i,2);
        text(x,y,num2str(i),...
            'backgroundcolor','k','fontweight','bold','color','w');
    end
    drawnow

        
    watershedRegions = findWatershedRegions(yData,LL,xx);
    
    bins = parameters.template_bins;
    yrange = parameters.template_yaxis;
    templatePlotDimensions = parameters.templatePlotDimensions;
    colorAxis = parameters.template_caxis;
      
    plotTemplateHistograms(vocData,watershedRegions,bins,...
        yrange,templatePlotDimensions,colorAxis);
    
    
    outputStats.watershedRegions = watershedRegions;
    
    
    
    
    
    
    
    
    
    