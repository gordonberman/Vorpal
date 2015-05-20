function watershedRegions = findWatershedRegions(yData,watershedMap,xx)

    addpath('../utilities/');
    
    %     if nargin < 2 || isempty(sigma)
    %         sigma = 1;
    %     end
    %
    %     if nargin < 3 || isempty(xRange)
    %         q = ceil(max(abs(yData(:))));
    %         xRange = [-q q];
    %     end
    %
    %     if nargin < 4 || isempty(numPoints)
    %         numPoints = 501;
    %     end
    %
    %     if nargin < 5 || isempty(minDensity)
    %         minDensity = 1e-7;
    %     end
    %
    %     if nargin < 6 || isempty(plotOn)
    %         plotOn = false;
    %     end

    N = length(yData(:,1));
    
    %find density
    %[xx,density] = findPointDensity(yData,sigma,numPoints,xRange);
    
    %assign points to watershed regions
    %     L = watershed(-density,8);
    %     watershedMap = L;
    %     watershedMap(density < minDensity) = 0;
    %     a = setdiff(unique(watershedMap),0);
    %     for i=1:length(a)
    %         watershedMap(watershedMap == a(i)) = i;
    %     end
    
    vals = round((yData + max(xx))*length(xx)/(2*max(xx)));
    vals(vals<1) = 1;
    vals(vals>length(xx)) = length(xx);
    
    watershedRegions = zeros(N,1);
    for i=1:N
        watershedRegions(i) = diag(watershedMap(vals(i,2),vals(i,1)));
    end
    
    %disambiguate points on the boundary
    idx = watershedRegions == 0;
    peakPoints = findPeakPoints(watershedMap,density,xx);
    
    D = findListDistances(yData(idx,:),peakPoints);
    [~,maxIdx] = max(D,[],2);
    watershedRegions(idx) = maxIdx;
    
  
    %make region plot (if toggled on)
    %     if plotOn
    %
    %         figure
    %         imagesc(xx,xx,watershedMap)
    %         axis equal tight off xy
    %         hold on
    %         for i=1:max(watershedMap(:))
    %             B = bwboundaries(watershedMap == i);
    %             plot(xx(B{1}(:,2)),xx(B{1}(:,1)),'k-','linewidth',2)
    %             [ii,jj] = find(watershedMap == i);
    %             meanX = xx(round(median(jj)));
    %             meanY = xx(round(median(ii)));
    %             text(meanX,meanY,num2str(i),'backgroundcolor','k','fontweight','bold','color','w')
    %         end
    %
    %     end
    
    
    
    
    
    
    