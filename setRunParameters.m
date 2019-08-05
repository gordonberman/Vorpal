function parameters = setRunParameters(parameters)
%setRunParameters sets all parameters for the algorithms used here.
%       Any parameters not explicitly set will revert to their listed
%       default values.
%
%
% (C) Gordon J. Berman, 2016
%     Emory University



    if nargin < 1
        parameters = [];
    end

    
    
    %%%%%%%% General Parameters %%%%%%%%
    
    %number of processors to use in parallel code
    numProcessors = 12;
    
    %whether or not to close the matlabpool after running a routine
    closeMatPool = false;
    
    %number of points in normalized vocalizations
    numPoints = 100;
    
    %window parameter for dtw
    dtw_window = [];
    
    %minimum length for vocalization
    min_voc_length = 5;
    
    
    
    
    %%%%%%%% t-SNE Parameters %%%%%%%%
    
    
    %2^H (H is the transition entropy)
    perplexity = 32;
    
    %relative convergence criterium for t-SNE
    relTol = 1e-4;
    
    %number of dimensions for use in t-SNE
    num_tsne_dim = 2;
    
    %binary search tolerance for finding pointwise transition region
    sigmaTolerance = 1e-5;
    
    %maximum number of non-zero neighbors in P
    maxNeighbors = 200;
    
    %initial momentum
    momentum = .5;
    
    %value to which momentum is changed
    final_momentum = 0.8;    
    
    %iteration at which momentum is changed
    mom_switch_iter = 250;      
    
    %iteration at which lying about P-values is stopped
    stop_lying_iter = 125;      
    
    %degree of P-value expansion at early iterations
    lie_multiplier = 4;
    
    %maximum number of iterations
    max_iter = 1000;  
    
    %initial learning rate
    epsilon = 500;  
    
    %minimum gain for delta-bar-delta
    min_gain = .01;   

    %readout variable for t-SNE
    tsne_readout = 1;
    
    %embedding batchsize
    embedding_batchSize = 20000;
    
    %maximum number of iterations for the Nelder-Mead algorithm
    maxOptimIter = 100;
    
    %number of points in the training set
    trainingSetSize = 35000;
    
    %local neighborhood definition in training set creation
    kdNeighbors = 5;
    
    %t-SNE training set stopping critereon
    training_relTol = 2e-3;
    
    %t-SNE training set perplexity
    training_perplexity = 20;
    
    %number of points to evaluate in each training set file
    training_numPoints = 10000;
    
    %minimum training set template length
    minTemplateLength = 1;
    
    
    
    
    
    
     %%%%%%%% Analysis Parameters %%%%%%%%
     
     %smoothing window for t-SNE plots
     sigma = 4;
     
     %template plot dimensions (i.e. subplot(x1,x2,..))
     templatePlotDimensions = [5 5];
     
     %minimum allowed density in plots
     minDensity = 1e-7;
     
     %template plot caxis
     template_caxis = [0 .1];
     
     %template bins
     template_bins = 50;
     
     %template plot y axis
     template_yaxis = [-20 20];
    
     %number of points in each dimension of density matrix
     numPoints_density = 201;
    
     %statistical significance p-Value threshold
     sigAlpha = .05;
    
    
     
      %%%%%%%% Bootstrap Parameters %%%%%%%%
     
     %smoothing window for t-SNE plots
     maxGMM = 3;
     
     %template plot dimensions (i.e. subplot(x1,x2,..))
     numReplicates = 3;
     
     %minimum allowed density in plots
     maxNumSamples = 10000;
     
     %template plot caxis
     numDensityPoints = 1000;
     
     %template bins
     rangeExtension = .1;
     
     %number of bootstrap samples
     numBootstrap = 1000;
    
     %number of points in the bootstrapped space
     numPoints_boot = 101;
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if ~isfield(parameters,'numProcessors') || isempty(parameters.numProcessors)
        parameters.numProcessors = numProcessors;
    end    
    
    if ~isfield(parameters,'closeMatPool') || isempty(parameters.closeMatPool)
        parameters.closeMatPool = closeMatPool;
    end
    
    if ~isfield(parameters,'numPoints') || isempty(parameters.numPoints)
        parameters.numPoints = numPoints;
    end
    
    if ~isfield(parameters,'dtw_window') || isempty(parameters.dtw_window)
        parameters.dtw_window = dtw_window;
    end
    
    if ~isfield(parameters,'min_voc_length') || isempty(parameters.min_voc_length)
        parameters.min_voc_length = min_voc_length;
    end
    
    if ~isfield(parameters,'perplexity') || isempty(parameters.perplexity)
        parameters.perplexity = perplexity;
    end
    
    
    if ~isfield(parameters,'relTol') || isempty(parameters.relTol)
        parameters.relTol = relTol;
    end
    
    
    if ~isfield(parameters,'num_tsne_dim') || isempty(parameters.num_tsne_dim)
        parameters.num_tsne_dim = num_tsne_dim;
    end
    
    
    if ~isfield(parameters,'sigmaTolerance') || isempty(parameters.sigmaTolerance)
        parameters.sigmaTolerance = sigmaTolerance;
    end
    
    
    if ~isfield(parameters,'maxNeighbors') || isempty(parameters.maxNeighbors)
        parameters.maxNeighbors = maxNeighbors;
    end
    
    
    if ~isfield(parameters,'momentum') || isempty(parameters.momentum)
        parameters.momentum = momentum;
    end
    
    
    if ~isfield(parameters,'final_momentum') || isempty(parameters.final_momentum)
        parameters.final_momentum = final_momentum;
    end
    
    
    if ~isfield(parameters,'mom_switch_iter') || isempty(parameters.mom_switch_iter)
        parameters.mom_switch_iter = mom_switch_iter;
    end
    
    
    if ~isfield(parameters,'stop_lying_iter') || isempty(parameters.stop_lying_iter)
        parameters.stop_lying_iter = stop_lying_iter;
    end
    
    
    if ~isfield(parameters,'lie_multiplier') || isempty(parameters.lie_multiplier)
        parameters.lie_multiplier = lie_multiplier;
    end
    
    
    if ~isfield(parameters,'max_iter') || isempty(parameters.max_iter)
        parameters.max_iter = max_iter;
    end
    
    
    if ~isfield(parameters,'epsilon') || isempty(parameters.epsilon)
        parameters.epsilon = epsilon;
    end
    
    
    if ~isfield(parameters,'min_gain') || isempty(parameters.min_gain)
        parameters.min_gain = min_gain;
    end
    
    
    if ~isfield(parameters,'tsne_readout') || isempty(parameters.tsne_readout)
        parameters.tsne_readout = tsne_readout;
    end
    
    
    if ~isfield(parameters,'embedding_batchSize') || isempty(parameters.embedding_batchSize)
        parameters.embedding_batchSize = embedding_batchSize;
    end
    
    
    if ~isfield(parameters,'maxOptimIter') || isempty(parameters.maxOptimIter)
        parameters.maxOptimIter = maxOptimIter;
    end
    
    
    if ~isfield(parameters,'trainingSetSize') || isempty(parameters.trainingSetSize)
        parameters.trainingSetSize = trainingSetSize;
    end
    
    
    if ~isfield(parameters,'kdNeighbors') || isempty(parameters.kdNeighbors)
        parameters.kdNeighbors = kdNeighbors;
    end
    
    
    if ~isfield(parameters,'training_relTol') || isempty(parameters.training_relTol)
        parameters.training_relTol = training_relTol;
    end
    
    
    if ~isfield(parameters,'training_perplexity') || isempty(parameters.training_perplexity)
        parameters.training_perplexity = training_perplexity;
    end
    
    
    if ~isfield(parameters,'training_numPoints') || isempty(parameters.training_numPoints)
        parameters.training_numPoints = training_numPoints;
    end
    
    
    if ~isfield(parameters,'minTemplateLength') || isempty(parameters.minTemplateLength)
        parameters.minTemplateLength = minTemplateLength;
    end

    
    
    
    
    
    if ~isfield(parameters,'numPoints_density') || isempty(parameters.numPoints_density)
        parameters.numPoints_density = numPoints_density;
    end
    
    if ~isfield(parameters,'sigma') || isempty(parameters.sigma)
        parameters.sigma = sigma;
    end
    
    
    if ~isfield(parameters,'templatePlotDimensions') || isempty(parameters.templatePlotDimensions)
        parameters.templatePlotDimensions = templatePlotDimensions;
    end
    
    
    if ~isfield(parameters,'minDensity') || isempty(parameters.minDensity)
        parameters.minDensity = minDensity;
    end
    
    
    if ~isfield(parameters,'template_caxis') || isempty(parameters.template_caxis)
        parameters.template_caxis = template_caxis;
    end
    
    
    if ~isfield(parameters,'template_yaxis') || isempty(parameters.template_yaxis)
        parameters.template_yaxis = template_yaxis;
    end
    
    
    if ~isfield(parameters,'numPoints') || isempty(parameters.numPoints)
        parameters.numPoints = numPoints;
    end
    
    
    if ~isfield(parameters,'sigAlpha') || isempty(parameters.sigAlpha)
        parameters.sigAlpha = sigAlpha;
    end
    
    
    if ~isfield(parameters,'template_bins') || isempty(parameters.template_bins)
        parameters.template_bins = template_bins;
    end
    
    
    
    if ~isfield(parameters,'maxGMM') || isempty(parameters.maxGMM)
        parameters.maxGMM = maxGMM;
    end
    
    if ~isfield(parameters,'numReplicates') || isempty(parameters.numReplicates)
        parameters.numReplicates = numReplicates;
    end
    
    if ~isfield(parameters,'maxNumSamples') || isempty(parameters.maxNumSamples)
        parameters.maxNumSamples = maxNumSamples;
    end
    
    if ~isfield(parameters,'numDensityPoints') || isempty(parameters.numDensityPoints)
        parameters.numDensityPoints = numDensityPoints;
    end
    
    if ~isfield(parameters,'rangeExtension') || isempty(parameters.rangeExtension)
        parameters.rangeExtension = rangeExtension;
    end
    
    if ~isfield(parameters,'numBootstrap') || isempty(parameters.numBootstrap)
        parameters.numBootstrap = numBootstrap;
    end
    
    if ~isfield(parameters,'numPoints_boot') || isempty(parameters.numPoints_boot)
        parameters.numPoints_boot = numPoints_boot;
    end
    
    