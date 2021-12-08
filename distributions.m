clear;

%Read the data file.
edges = importdata('output\Distribution.txt');

Nfrom = edges(:,1); %Will be used to compute out-degree
Nto = edges(:,2);   % "..." in-degree


%%1. Degree Distribution:

% Removing duplicates:
Nfrom = unique(Nfrom); %Will be used to compute the outdegree distribution.
Nto = unique(Nto);     %Will be used to compute the indegree distribution.

%Out-degree: count the number of occurances of each element (node-user id)
%contained into Nfrom to G.data(:,1).
od = histc(edges(:,1), Nfrom);
odedges = hist(od, 1:size(Nfrom));

figure;
plot(odedges)
title('linear-linear scale plot: outdegree distribution');
figure;
loglog(odedges)
title('log-log scale plot: outdegree distribution');

%%In-degree distribution:
id = histc(edges(:,1), Nto);
idG = hist(od, 1:size(Nto));
figure;
plot(idG)
title('linear-linear scale plot: in-degree distribution');
figure;
loglog(idG)
title('log-log scale plot: in-degree distribution');

% Degree distribution:
figure;
loglog(odedges)
loglog(idG)
title('Log-Log scale Plot: Degree distribution');