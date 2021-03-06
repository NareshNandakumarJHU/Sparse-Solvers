% Generates data for controlled L^p norm example when:
% M constant, P constant, N varies, for random dictionaries 
% drawn from the partial Fourier ensemble. 

P = 0.5:0.25:1;
M = [1024 2048];
Nfrac = 0.05:0.05:0.75;
numTrials = 20;
errArray = zeros(length(P), length(M), length(Nfrac), numTrials);
Pnorm = zeros(length(P), length(M), length(Nfrac), numTrials);

for mm = 1:length(M)
    H = RSTMat(M(mm));
    N = floor(Nfrac .* M(mm));
    for pp = 1:length(P)
        for nn = 1:length(N)
            for jj = 1:numTrials
                % Generate Random Dictionary
                p = randperm(M(mm));
                Phi = H(p(1:N(nn)), :);
                
                % Normalize the columns of Phi
                for ii = 1:size(Phi,2)
                    Phi(:,ii) = Phi(:,ii) ./ twonorm(Phi(:,ii));
                end

                % Generate sparse signal
                alpha0 = GenRandVec(M(mm),P(pp));

                % generate the vector S
                S = Phi * alpha0;

                % Solve the BP problem
                alpha = SolveBP(Phi, S);

                errArray(pp,mm,nn,jj) = twonorm(alpha - alpha0);
                Pnorm(pp,mm,nn,jj) = pnorm(alpha0,P(pp));
            end
        end
    end
end

save BoundDataFourier.mat M P Nfrac numTrials errArray Pnorm

%
% Copyright (c) 2006. Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
