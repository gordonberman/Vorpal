function images = plotTemplateHistograms(templates,bins,yrange,numPoints,means,logGrams,addToTitles)
    %makes template histogram plot
    
    
    if nargin < 7 || isempty(addToTitles)
        addToTitles = 0;
    end
    
    %Inputs:
    
    %templates -> L x 1 cell array of templates (or groupings)
    %bins -> number of bins in each column (default = 50)
    %means -> lines to be plotted on top of histograms (the template mean
    %           if unspecified)

    N = length(templates);
    

    if nargin < 2 || isempty(bins)
        bins = 50;
    end

    if nargin < 3 || isempty(yrange) || length(yrange) < 2
        maxVal = -1e99;
        minVal = 1e99;
        for i=1:N
            a = max(templates{i}(:));
            b = min(templates{i}(:));
            if a > maxVal
                maxVal = a;
            end
            if b < minVal
                minVal = b;
            end
        end
        yrange = [minVal maxVal];
    end
    
    
    if nargin < 4 || isempty(numPoints)
        for i=1:N
            if ~isempty(templates{i})
                numPoints = length(templates{i}(1,:));
                break;
            end
        end
    end
    
    
    if nargin < 5 || isempty(means) || length(means) ~= N
        means = cell(N,1);
        for i = 1:N
            means{i} = mean(templates{i});
        end
    end
    
    
    if nargin < 6 || isempty(logGrams)
        logGrams = false;
    end
    
    
    
    L = ceil(sqrt(N));
    M = ceil(N/L);
    q = L;
    L = M;
    M = q;
    clear q
    images = cell(N,1);
    for i=1:N
        
        if ~isempty(templates{i})
            if max(M,L) > 1
                subplot(M,L,i)
            end
            
            xx = linspace(yrange(1),yrange(2),bins);
            Z = zeros(numPoints,bins);
            for j=1:numPoints
                Z(j,:) = hist(templates{i}(:,j),xx);
                Z(j,:) = [0 Z(j,2:end-1) ./ sum(Z(j,2:end-1)) 0];
            end
            
            hold off
            
            %yy = 1:numPoints;
            yy = linspace(0,1,numPoints);
            
            if logGrams
                pcolor(yy,xx,log(Z')./log(10));
            else
                pcolor(yy,xx,Z');caxis([0 .1])
            end
            shading flat
            hold on
            
            if length(templates{i}(:,1)) > 1
                plot(1:numPoints,means{i}(1:numPoints),'k-','linewidth',2)
                title(['Template #' num2str(i+addToTitles) ', N = ' num2str(length(templates{i}(:,1)))],'fontweight','bold','fontsize',12);
            else
                title(['Template #' num2str(i+addToTitles) ', N = 1'],'fontweight','bold','fontsize',12);
            end
            
            axis off
            qq = axis;
            plot([qq(1) qq(1) qq(2) qq(2) qq(1)],[qq(3) qq(4) qq(4) qq(3) qq(3)],'k-','linewidth',2)
            axis([qq(1)-.005 qq(2)+.005 qq(3)-.1 qq(4)+.1])
            
            images{i} = Z;
        end
        
    end
    
    
    
    