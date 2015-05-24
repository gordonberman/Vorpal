function makeMapFromArray(plotOutputData,toPlotArray)
%makes a region-labelled plot of the variable of one's choice.  
%Inputs:
%   plotOutputData -> output data structure from makeOutputPlots.m
%   toPlotArray -> N x 1 or numRegions x 1 array containing region
%                  colorings.  If an N x 1 array is inputted, the mean
%                  value within region is used
%
%
% (C) Gordon J. Berman, 2015
%     Princeton University



    addpath('utilities/');

    L = plotOutputData.watershedMap;
    M = plotOutputData.numRegions;

    A = zeros(size(L));
    for i=1:M
        if length(toPlotArray) == M
            A(L == i) = toPlotArray(i);
        else
            A(L == i) = mean(toPlotArray(plotOutputData.watershedRegions == i));
        end
    end
    
    
    xx = plotOutputData.xx;
    imagesc(xx,xx,A);
    axis equal tight off xy
    hold on
    for i=1:M
        B = bwboundaries(L == i);
        plot(xx(B{1}(:,2)),xx(B{1}(:,1)),'k-','linewidth',2)
    end
    
    colorbar
    set(gca,'fontsize',14,'fontweight','bold')
    load('saved_colormaps');
    colormap(cc)
    
    hold off
    