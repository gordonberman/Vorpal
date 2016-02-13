function [yData,betas,P,errors] = run_tSne(D,parameters)
%run_tSne runs the t-SNE algorithm on an NxN distance matrix
%
%   Input variables:
%
%       D -> NxN matrix of distances
%       parameters -> struct containing non-default choices for parameters
%
%
%   Output variables:
%
%       yData -> N x parameters.num_tsne_dim array of embedding results
%       betas -> Nx1 array of local region size parameters
%       P -> full space transition matrix
%       errors -> P.*log2(P./Q) as a function of t-SNE iteration
%
%
% (C) Gordon J. Berman, 2016
%     Emory University



    addpath(genpath('./utilities/'));
    addpath(genpath('./t_sne/'));
    
    if nargin < 2
        parameters = [];
    end
    
    parameters = setRunParameters(parameters);

    
    
    fprintf(1,'Computing t-SNE\n');
    [yData,betas,P,errors] = tsne_d(D,parameters);