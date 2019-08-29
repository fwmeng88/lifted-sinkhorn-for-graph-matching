function [X_proj_new,Efinal] = frankWolfeSolverRape2(A,B,params)
%% locally minimize tr(AXBX^T) s.t. X \in DS

tic
params.null = [];
boundThresh = getoptions(params,'boundThresh',10^-6);
numShifts = getoptions(params,'numShifts',100);
n = size(A,1);
% find optimal tranlation
% find spectrum of functional reduced to working subspace
F = null(ones(1,n));
eA = eig(F'*A*F);
eB = eig(F'*B*F);
colstack = real(eA)*real(eB)';
e = colstack(:);
figure,plot(sort(e)),title('functional spectrum')
% if there is a positive e.v.
% find minimal translation with good chernoff bound
if sum(e>0)>0
    translations = linspace(0,max(e),200);
    mins = [];
    ii = 0;
    while(true)
        ii = ii+1;
        t = linspace(0,1/(2*max(abs(e))),20000);
        chernoffBounds = 1./prod(sqrt(1-2*(e-translations(ii))*t),1);
        mins = [mins min(chernoffBounds)];
        if mins(end)<boundThresh
            break
        end
    end
    optimalTranslation = translations(ii);
    
    fprintf('found optimal translation %.6f\n',translations(ii));
    figure, plot(translations(1:ii),mins);
end


% run with many shifts and take best
shifts = linspace(0,optimalTranslation,numShifts);
X_proj_new = {};
params.step = shifts;
[X_proj_new,Efinal] = frankWolfeSolver2(A,B,params);

fprintf('Frank-Wolfe RAPE solver: Optimization has finished. Energy is %.6f \n',full(Efinal))

end