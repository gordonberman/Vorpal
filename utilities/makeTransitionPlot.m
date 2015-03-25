function makeTransitionPlot(dataPoints,markerSizes,T,hideTValue,...
            maxMarkerSize,maxLineWidth,curveSize,maxTransition,...
            allConnected,rescale,linecolor,markercolor)


    if nargin < 5 || isempty(maxMarkerSize)
        maxMarkerSize = 40;
    end
    
    if nargin < 6 || isempty(maxLineWidth)
        maxLineWidth = 10;
    end

    if nargin < 7 || isempty(curveSize)
        curveSize = .2;
    end
    
    if nargin < 8 || isempty(maxTransition)
        maxTransition = max(T(:));
    end
    
    if nargin < 9 || isempty(allConnected)
        allConnected = false;
    end
    
    if nargin < 10 || isempty(rescale)
        rescale = false;
    end
    
    if nargin < 11 || isempty(linecolor)
        linecolor = [0 0 0];
    end
    
     if nargin < 12 || isempty(markercolor)
        markercolor = [1 0 0];
    end

    
    
    N = length(dataPoints(:,1));
    
    hold on
    
    %maxTransition = max(T(:));
    if nargin < 4 || isempty(hideTValue)
        hideTValue = .05*maxTransition;
    end
        
    showVals = T >= hideTValue;
    if allConnected
        ss = sum(showVals);
        idx = find(ss == 0);
        if ~isempty(idx)
            for j=1:length(idx)
                [~,a] = max(T(:,idx(j)));
                showVals(a,idx(j)) = true;
            end
        end
        
        ss = sum(showVals,2);
        idx = find(ss == 0);
        if ~isempty(idx)
            for j=1:length(idx)
                [~,a] = max(T(idx(j),:));
                showVals(idx(j),a) = true;
            end
        end
    end
    
    for i=1:N
        for j=setdiff(1:N,i)
            if showVals(i,j) && T(i,j) > 0
                outPoints = drawCurvedArrow(dataPoints(i,:),dataPoints(j,:),curveSize,false);
                if rescale
                    plot(outPoints(:,1),outPoints(:,2),'-','linewidth',min(T(i,j)*maxLineWidth/maxTransition,maxLineWidth),'color',linecolor)
                else
                    plot(outPoints(:,1),outPoints(:,2),'-','linewidth',T(i,j)*maxLineWidth,'color',linecolor)
                end
            end
        end
    end
    
    
    for i=1:N
        if rescale
            q = markerSizes(i)/max(markerSizes);
        else
            q = markerSizes(i);
        end
        %c = 'r';%c = [q 0 1-q];
        if q*maxMarkerSize > 0
            plot(dataPoints(i,1),dataPoints(i,2),'o','markersize',q*maxMarkerSize,'markerfacecolor',markercolor,'markeredgecolor',markercolor)
        end
    end
    
    
    