clear all

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 1);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = "path_dist";
opts.VariableTypes = "double";

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("output\no_phil_path_distribution.csv", opts);

% Convert to output type
path_dist = tbl.path_dist;

% Clear temporary variables
clear opts tbl

%Number of data points 
n=500;

%Number of variables (k=1 or k=2)
k=1;
%Generate observations
x=path_dist;
%x=chi2rnd(2,n,1);
%x=3*rand(n,k);
%x=randn(n,k);

%mu=[0 0];
%Sigma=[1 0; 0 1];
%x=mvnrnd(mu, Sigma, n);

%Kernel type
%kerntype='norm';
kerntype='Epa';

%Bandwidth

%h=0.3;

h=2.34*std(x)*n^(-1/5);
%h=[0.08 0.8];
%h=[0.1 .8];

%h=lscv_kdensest(x, kerntype, .5, 2) 

%Points of evaluation
switch k
    
    case 1 %Scalar x
        
        %x_e=[0.5:.05:2.5]';
        %x_e=[-3:.05:3]';
        x_e=[0:.05:50]';
        %x_e=x;
        
    case 2 %Two dimensional x
       
        %Specify grid in both dimensions separately
        x1_e=[-2.5:.05:2.5]';
        x2_e=[-2.5:.05:2.5]';
        
        n1=length(x1_e); %grid size in x1 direction 
        n2=length(x2_e); %grid size in x2 direction 
          
        %Creating rectangular grid (Cartesian product)
        [x1_m, x2_m]=meshgrid(x1_e,x2_e);
        
        x_e=[];
        for j=1:n1
            
           x_e=[x_e; x1_m(:,j) x2_m(:,j)];
                        
        end
        
end

%Estimation
fhat=kdensest(x, x_e, h, kerntype, 2, 0, 0);

%Arguments:
%1. Data
%2. Evaluation points
%3. Bandwidth
%4. kernel type ('norm' or 'Epa')
%5. kernel order (set to 2 for regular)
%6. Bounding away from zero: if set to tau, then forces estimated density
%to be >= tau
%7. 0/1 flag; =1 implements leave-one-out version of estimator evaluated at
%   the sample points

%Plotting

switch k
    
    case 1
        
        d=sortrows([x_e fhat]);
        
        plot(d(:,1),d(:,2),'b')
        hold on
        
        %plot(d(:,1),chi2pdf(d(:,1),2),'r')
        %plot(d(:,1),normpdf(d(:,1),0,1),'r')
        hold off
        
    case 2
        
        %Transforming fhat into matrix format to match meshgrid
        
        fhat_m=[];
        
        for j=1:n1
            
            fhat_m=[fhat_m fhat((j-1)*n2+1:(j-1)*n2+n2)];
            
        end
        
        figure
        meshc(x1_m, x2_m, fhat_m)
        
end
