%% Getting to Philosophy
clear;
clc;
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 38);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38"], "EmptyFieldRule", "auto");

% Import the data
beta = readtable("data\beta_all.csv", opts);

%% Convert to output type
beta = table2cell(beta);
numIdx = cellfun(@(x) ~isnan(str2double(x)), beta);
beta(numIdx) = cellfun(@(x) {str2double(x)}, beta(numIdx));

%% Clear temporary variables
clear opts

%% Transpose, drop initial cells, remove brackets and quotes and identify broken & duplicate paths

data = beta'; % transpose data
dimensions = size(data); 
number_of_paths = dimensions(2);
longest_path = dimensions(1);
path = 0;
node = 0;
path_dist = zeros(number_of_paths,1);   % length of each path
no_phil = ones(number_of_paths,1);   % indicator: if==1 the path does not lead to philosophy
broken = zeros(number_of_paths,1);   % indicator if==1 path is broken
duplicate = zeros(number_of_paths,1); %indicator: if==1 the path was generated before
duplicate_trigger = zeros(number_of_paths,1); %used to keep a unique copy of duplicates

for path = 1:number_of_paths
    p{path} = data(:,path);
    p{path} = p{path}(2:length(p{path}));   % remove initial cell

    for node = 1:longest_path-1     %because we removed one cell from the top
        
        % remove brackets, quotes, and spaces
        if (strlength(p{path}(node)) > 0)
        p{path}(node) = erase(p{path}(node),"[");
        p{path}(node) = erase(p{path}(node),"]");
        p{path}(node) = erase(p{path}(node),"'");
        p{path}(node) = erase(p{path}(node)," ");
        path_dist(path) = node;
        end
    end  
    
    % Identify broken links (pages that contain only lists: these paths will
    % abruptly end, but unlike loop paths, no nodes repeat
    
    
    % Identify paths that do not lead in Philosophy    
     if (p{path}(path_dist(path))== "Philosophy")          
        no_phil(path) = 0;
     end
            
    % identify broken paths
    if (no_phil(path) == 1)
        
    broken(path) = 1;
        
        for node = 1:path_dist(path)-1    % we do not use to last one to not compare the last cell to itself
            ((p{path}(node)) == string(p{path}(path_dist(path))));
            if ((p{path}(node)) == string(p{path}(path_dist(path))))
                
                broken(path) = 0;
                
            end
        end
    end 
end

% Identify duplicates 

for path = 1:number_of_paths
   for testing_path = 1:number_of_paths
       if (testing_path ~= path) && (duplicate(path) == 0)
           if ((p{testing_path}(1)) == string(p{path}(1)))
               duplicate(testing_path) = 1;
           end
       end
   end
end

% generate path_dist for phil and no phil separately
phil_paths = 0;
no_phil_paths = 0;
for path = 1:number_of_paths
    if (no_phil(path)==0)&&(broken(path)==0)&&(duplicate(path)==0)
        phil_paths = phil_paths+1;
        phil_path_dist(phil_paths,1) = path_dist(path);
    end
        if (no_phil(path)==1)&&(broken(path)==0)&&(duplicate(path)==0)
        no_phil_paths = no_phil_paths+1;
        no_phil_path_dist(no_phil_paths,1) = path_dist(path);
    end
end

%% Generate Links

% generate clean data
clean_path = 0;
for path = 1:number_of_paths
    if (broken(path)==0)&&(duplicate(path)==0)
        clean_path = clean_path+1;
        network{clean_path} = p{path};
        network_path_dist(clean_path,1) = path_dist(path); % lengths of all paths in the final network
    end
end

network_number_of_paths = clean_path;
links = strings(sum(network_path_dist)-1,1);
% generate links
link_counter = 1;
for path = 1:network_number_of_paths
    for node = 1:network_path_dist(path)-1
        links(link_counter) = strcat(string(network{path}(node)),";",string(network{path}(node+1)));
        link_counter = link_counter+1;
    end
end


writematrix(links,'output\links.csv');
writematrix(network_path_dist,'output\path_distribution.csv');
writematrix(phil_path_dist,'output\phil_path_distribution.csv');
writematrix(no_phil_path_dist,'output\no_phil_path_distribution.csv');
