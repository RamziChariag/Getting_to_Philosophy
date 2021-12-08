

function y=Epa2(u);

%Univariate Epanechnikov kernel

y=0.75*(1-u.^2).*(u>-1).*(u<1);






