function score = randomPNWG(k,m,Ck,Cm)
% This function calculates four different scores (Parametric, Nonparametric, Whisper, and TSURFER)
% based on the input data.
%
% INPUTS:
%   k:  vector of k values
%   m:  vector of m values
%   Ck: covariance matrix for k
%   Cm: covariance matrix for m
%
% OUTPUT:
%   score: a 1x4 vector containing the four calculated scores

score = zeros(1,4);

% Randomly select a subset of the data
I = 1:length(k);
I = I(randperm(length(I)));
ri = randi([10 50]);
I = I(1:ri);

k = k(I);
m = m(I);
Ck = Ck(I,I); 
Cm = Cm(I,I);

N = length(k)-1;

% Inverse of the diagonal of the covariance matrix
Ce = Cm(1:N,1:N) + eye(N)*0.0001^2;
inv_sig2 = 1./diag(Ce);

% Weighted means
denom = sum(inv_sig2);
numk = sum(k(1:N).*inv_sig2);
numm = sum(m(1:N).*inv_sig2);

k_bar = numk / denom;
m_bar = numm / denom;

% Beta values
beta = k(1:N) - m(1:N);
beta_p = k_bar - m_bar;
beta_np = min(beta);

% Variance and standard deviation
if N > 1
    s2 = N/(N-1) * sum(((beta - beta_p).*sqrt(inv_sig2)).^2)/ denom;
else
    s2 = 0;
end
sig2 = N / denom;

sig_p = sqrt(s2 + sig2);

% --- Score Calculations ---

% 1. Parametric score
score(1) = (k(end) - beta_p - m(end)) / sig_p;

% 2. Nonparametric score
score(2) = (k(end) - beta_np - m(end)) / sig_p;

% 3. Whisper score
n = 10000;
ck = corrcoef(Ck(1:N,1:N));
ck = ck(1:N, 1);
w_i = ck/max(ck);

Res = mvnrnd(-beta, Ce, n)';

wRes = ones(size(Res))*(-20);
for i = 1 : N
    for j = 1 : round(n*w_i(i))
        wRes(i,j) = Res(i,j);
    end
    wRes(i,:) = wRes(i,randperm(n));
end
mRes = max(wRes);

kW = k(end) + mean(mRes);
score(3) = (kW - m(end)) / std(mRes);

% 4. TSURFER score
Inv = inv(Ck(1:end-1,1:end-1) + Cm(1:end-1,1:end-1));
pk = k(end) - Ck(end,1:end-1)*Inv*(k(1:end-1)-m(1:end-1));
pbias = pk - m(end);
punc = sqrt(Ck(end,end) - Ck(end,1:end-1)*Inv*Ck(1:end-1,end));
score(4) = pbias / punc;

end