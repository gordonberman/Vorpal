function plotTemplateHistograms(vocData,watershedRegions,bins,yrange,numPerFig)
    %makes template histogram plot
 
    
    %Inputs:
    
    %yData -> L x 2 array of embedding positions
    %watershedRegions -> Lx1 array of watershed assignments
    %bins -> number of bins in each column (default = 50)
    %yrange -> y-axis range for histogram (default = [-20 20])
    %numPerFig -> number of histograms per figure (default = 25)

    
    addpath('../utilities/');
    
    N = max(watershedRegions);
    templates = cell(N,1);
    for i=1:N
        templates{i} = vocData(watershedRegions == i,:);
    end
    

    if nargin < 3 || isempty(bins)
        bins = 50;
    end

    if nargin < 4 || isempty(yrange)
        yrange = [-20 20];
    end
    
    
    idx = find(returnCellLengths(templates) > 0,1,'first');
    numPoints = length(templates{idx}(1,:));
        
    
    if nargin < 5 || isempty(numPerFig)
        numPerFig = 25;
    end
    
    
    numFigs = ceil(N/numPerFig);
    for i=1:numFigs
        
        num = min(numPerFig,N-numPerFig*(i-1));
        M = ceil(sqrt(num));
        L = ceil(num/M);
        
        figure(i)
        clf
        
        for j=1:num
            
            currentIdx = (i-1)*numPerFig + j;
            
            if ~isempty(templates{currentIdx})
                if max(M,L) > 1
                    subplot(M,L,j)
                end
                
                xx = linspace(yrange(1),yrange(2),bins);
                Z = zeros(numPoints,bins);
                for k=1:numPoints
                    Z(k,:) = hist(templates{currentIdx}(:,k),xx);
                    Z(k,:) = [0 Z(k,2:end-1) ./ sum(Z(k,2:end-1)) 0];
                end
                
                hold off
                
                yy = linspace(0,1,numPoints);
                
                pcolor(yy,xx,Z');
                caxis([0 .1])
                shading flat
                hold on
                
                if length(templates{currentIdx}(:,1)) > 1
                    title(['Template #' num2str(currentIdx) ', N = ' ...
                        num2str(length(templates{currentIdx}(:,1)))],...
                        'fontweight','bold','fontsize',12);
                else
                    title(['Template #' num2str(currentIdx) ', N = 1'],...
                        'fontweight','bold','fontsize',12);
                end
                
                axis off
                qq = axis;
                plot([qq(1) qq(1) qq(2) qq(2) qq(1)],[qq(3) qq(4) qq(4) qq(3) qq(3)],'k-','linewidth',2)
                axis([qq(1)-.005 qq(2)+.005 qq(3)-.1 qq(4)+.1])
                
            end
            
        end
        
        
    end
    
   