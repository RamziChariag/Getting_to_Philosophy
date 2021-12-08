
function fhat=kdensest(x, x_e, h, kerntype, s, tau, LeaveOneOut)

%INPUTS:

% x: n x d data matrix, where d=number of variables and n=number of
% observations

% x_e: R x d matrix of points at which the density estimator is to be
% evaluated

%h: bandwidth; scalar or 1 x d vector

%kerntype: kernel type -- string variable. Must be 'norm' or 'Epa'
%(Epanechnikov)

%s: kernel order (just set to 2)

%tau: trimming parameter. If density estimate is less than tau, then it's
%reset to tau (set to zero for no trimming), i.e., one forces \hat{f}(x)>tau.

%LeaveOneOut:   =0 each sample observation is used to estimate f(x) at x;
%               =1 leave-one-out version of the estimator; uses
%               X_1,...,X_{i-1},X_{i+1},...,X_n to estimate
%               f(X_i). In this case the code sets x_e=x regardless of
%               what the user specifies for x_e.

%OUTPUT:

%fhat: R x 1 vector of density estimates (evaluated at the points in x_e)

n=size(x,1);   %number of observations
d=size(x,2);   %number of covariates

if LeaveOneOut==1, x_e=x; end %for leave-one-out version, eval points=data points 
R=size(x_e,1);      %number of evaluation points
d_eval=size(x_e,2); %number of covariates in eval data set

fhat=zeros(R,1);

%Error control
%**************************************************************************

if d~=d_eval
    error('Evaluation points must have same number of components as there are variables')
end

if (length(h)~=1 && length(h)~=d )
    error('Bandwidth must be scalar or a vector having the same number of components as there are variables')
end

% if rem(s,2)~=0
%     error('Kernel order must be even')
% end

if length(h)==1
    
    h=ones(1,d)*h; %convert bandwidth to vector for technical reasons 
    
end

% %Data transformation
% %**************************************************************************
% 
% %If d>1 and h is NOT a (1 x d) vector, i.e. there is only one bandwidth for each 
% %component of x, then the x's are standardized to avoid problems emanating 
% %from (big) differences in scale. 
% 
% if (length(h)==1) & (d>1)
% 
%     mx=mean(x); sx=std(x);
% 
%     u=ones(n,1);
%     x=(x - u*mx)./( u*sx ); %transform variables
%     
%     u=ones(R,1);   
%     x_e=(x_e - u*mx)./( u*sx ); %transform grid
% 
%     h=ones(1,d)*h; %convert bandwidth to vector for unified treatment of cases below
% 
% end

switch LeaveOneOut
    
    case 0 %keep all observations
        
        u=ones(n,1);
        H=u*h; %n x d matrix of bandwidth values; each row is the same
        
        for j=1:R
            
            z=(x-u*x_e(j,:))./H;
            kern=prod(  feval( str2func([kerntype num2str(s)]), z)  ,  2);  %n x 1
            
            fhat(j,1)=(1/(n*prod(h)))*sum( kern );
            fhat(j,1)=fhat(j,1)*(fhat(j,1)>tau) + tau*(fhat(j,1)<=tau); %getting rid of density estimates below threshold
            
        end
        
    case 1 %leave one out
        
        u=ones(n-1,1);
        H=u*h; %(n-1) x d matrix of bandwidth values; each row is the same
        
        for j=1:R
            
            x_1=x([1:(j-1) (j+1):n],:); %drop jth data point
                      
            z=( x_1-u*x_e(j,:) )./H;
            kern=prod(  feval( str2func([kerntype num2str(s)]), z)  ,  2);  %n-1 x 1
            
            fhat(j,1)=(1/(n*prod(h)))*sum( kern );
            fhat(j,1)=fhat(j,1)*(fhat(j,1)>tau) + tau*(fhat(j,1)<=tau); %getting rid of density estimates below threshold
            
        end
        
        
end
