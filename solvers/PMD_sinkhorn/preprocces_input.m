function [ W,Winf,Z ] = preprocces_input( params )
%PREPROCCES_INPUT Summary of this function goes here
%   Detailed explanation goes here
%% extract variables
flagA = isfield(params,'A');
flagB = isfield(params,'B');
flagW = isfield(params,'W');
flagZ = isfield(params,'Z');

switch params.type
    case 'permutation' %ds ++ zeros enforcing two sided
        if flagW
            W = params.W;
            n = round(sqrt(size(W,1)));
            m = n;
        elseif flagA && flagB
            W = kron(params.A,params.B);
            [n,m] = size(params.A);
        else
            error('bad input, missing input W or A,B');
        end
        W = (W + W')./2; %projecting W to symetric space
        Z = zeros(n,m);
        
    case 'labelling'  %ds ++ zeros enforcing one sided
        if flagW && flagZ
            W = params.W;
            Z = params.Z;
            [n,m] = size(Z);
            
        else
            error('bad input, missing input W or Z');
        end            
end


%% W precook
if ~issparse(W)
Winf = reshape(W,[n,m,n,m]);                   %turning Wi in to a 4D tenzor (like it should be
Winf = Winf./max(abs(Winf(:)));                        %normelaizing Wi
[idx1 ,idx2 ,idx3 ,idx4]=ndgrid(1:n,1:m,1:n,1:m); %indeces for 4d tenzor
switch params.type
    case 'permutation'                            %ds ++ zeros enforcing, two sided
         Winf(idx1 == idx3 & idx2 ~= idx4) = inf;    
         Winf(idx1 ~= idx3 & idx2 == idx4) = inf;    
    case 'labelling'                              %ds ++ zeros enforcing, one sided
         Winf(idx1 == idx3 & idx2 ~= idx4) = inf;    
         if params.sparse
            Winf = reshape(Winf,n*m,n*m);
            Winf = sparse(Winf);
         end
end
else
    Winf = W;
end
end

