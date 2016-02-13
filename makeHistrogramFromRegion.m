function [Z,x,y,points] = makeHistrogramFromRegion(vocData,plotOutputData,mapData)
% (C) Gordon J. Berman, 2016
%     Emory University


    maxX = 1000;
    x = zeros(maxX,1);
    y = zeros(maxX,1);

    if nargin < 3 || isempty(mapData)
        mapData = plotOutputData.density;
    end
    
    addpath('utilities/');
    load('saved_colormaps','cc','cc2');
    if min(mapData(:)) >= 0
        cm = cc;
        ca = [0 .8*max(mapData(:))];
    else
        cm = cc2;
        q = max(abs(mapData(:)))*.8;
        ca = [-q q];
    end
    
    xx = plotOutputData.xx;
    
    figure
    imagesc(xx,xx,mapData)
    axis equal tight off xy
    hold on
    title('Select Bounding Points (press enter if finished)',...
        'fontsize',16,'fontweight','bold')
    colormap(cm)
    caxis(ca);
    
    
    [x(1),y(1),button] = ginput(1);
    plot(x(1),y(1),'ko','markerfacecolor','m')
    count = 2;
    while ~isempty(button)   
        
        [a,b,button] = ginput(1);
        while ~isempty(button) && button ~= 1
            [a,b,button] = ginput(1);
        end
        
        if ~isempty(button)
            x(count) = a;
            y(count) = b;
            count = count + 1;
            
            clf
            imagesc(xx,xx,mapData)
            axis equal tight off xy
            hold on
            title('Select Bounding Points (press enter if finished)',...
                'fontsize',16,'fontweight','bold')
            plot(x(1:count-1),y(1:count-1),'ko-',...
                'markerfacecolor','m','linewidth',1)
            colormap(cm)
            caxis(ca)
            
        end
        
    end
    
    x = [x(1:count-1); x(1)];
    y = [y(1:count-1); y(1)];
    
    clf
    imagesc(xx,xx,mapData)
    axis equal tight off xy
    hold on
    plot(x,y,'ko-','markerfacecolor','m','linewidth',1)
    fill(x,y,'g','facealpha',.5,'edgealpha',0)
    colormap(cm)
    caxis(ca)
    
    
    inPoly = inpolygon(vocData.yData(:,1),vocData.yData(:,2),x,y);
    points = vocData.normalizedVocs(inPoly,:);
    
    bins = plotOutputData.parameters.template_bins;
    yrange = plotOutputData.parameters.template_yaxis;
    colorAxis = plotOutputData.parameters.template_caxis;
    numPoints = vocData.numPoints;
    
    figure
    xx = linspace(yrange(1),yrange(2),bins);
    Z = zeros(numPoints,bins);
    for k=1:numPoints
        Z(k,:) = hist(points(:,k),xx);
        Z(k,:) = [0 Z(k,2:end-1) ./ sum(Z(k,2:end-1)) 0];
    end
    
    hold off
    
    yy = linspace(0,1,numPoints);
    pcolor(yy,xx,Z');
    caxis(colorAxis)
    shading flat
    colormap(cc);
    
    set(gca,'fontsize',14,'fontweight','bold')
    xlabel('Normalized Time Within Call','fontsize',16,'fontweight','bold')
    ylabel('Normalized Frequency (kHz)','fontsize',16,'fontweight','bold')
    colorbar
    
    