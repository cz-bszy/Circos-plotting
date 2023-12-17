clc;clear;close all
[Subj]=xlsread('G:\creativity\creativity_data.xlsx','fixation','b2:b167');
s=[13,17:31,109,110,111,124,125,126];
Subj(s)=[];
N_sub=length(Subj);N=100;
threshold = 0.01;
output= 'D:\Sharefold\circos\';

load('G:\creativity\ROI.mat');
Core=intersect(ROI12,ROI23);
OBJ=setdiff(ROI12,Core);
CRE=setdiff(ROI23,Core);
[label,name]=xlsread('G:\ThomasYeo\Thomas_7networks.xlsx','100','b1:d100');


%%%%%===========calculate  regions============%%%%%%
networks = {'Core', 'OBJ', 'CRE'};
regions = {name(Core), name(OBJ), name(CRE)};
labels = {label(Core),label(OBJ),label(CRE)};
networkList = {};
nodeList = {};
labelList={};
for i = 1:length(networks)
    for j = 1:length(regions{i})
        networkList{end+1,1} = networks{i};
        nodeList{end+1,1} = regions{i}{j};
        labelList{end+1,1} = labels{i}(j);
    end
end

sortedData = sortrows(table(networkList, nodeList, labelList), [1, 3]);
networkList = sortedData.networkList;
nodeList = sortedData.nodeList;
labelList = sortedData.labelList;
T = table(networkList, nodeList, labelList, 'VariableNames', {'network', 'node', 'label'});


network_chr_map = containers.Map({'Core', 'OBJ', 'CRE'}, {'47,85,151', '244,177,131', '192,0,0'});

% Initialize variables to keep track of positions for each network
network_positions = containers.Map({'Core', 'OBJ', 'CRE'}, {0, 0, 0});
start_positions = containers.Map({'Core', 'OBJ', 'CRE'}, {inf, inf, inf});
end_positions = containers.Map({'Core', 'OBJ', 'CRE'}, {0, 0, 0});

% Process each row to update start and end positions
for index = 1:height(T)
    network = T.network{index};
    start_pos = index;
    end_pos = index +1;
    network_positions(network) = network_positions(network) + 1;
    start_positions(network) = min(start_positions(network), start_pos);
    end_positions(network) = max(end_positions(network), end_pos);
end

fileID = fopen(char(strcat(output,'region_100.txt')),'w');

% Create and save the summary rows
networks = {'Core', 'OBJ', 'CRE'};
for i = 1:length(networks)
    network = networks{i};
    start = start_positions(network);
    end_pos = end_positions(network);
    fprintf(fileID, 'chr -\t%s\t%s\t%d\t%d\t%s\n', network,network,start,end_pos, network_chr_map(network));
end

network_colors = containers.Map({1, 2, 3, 4, 5, 6, 7}, {'0,0,148', '0,63,255', '0,228,255',...
    '144,255,111', '255,201,0', '255,37,0','101,0,0'});  

for index = 1:height(T)
    network = T.network{index};
    node = T.node{index};
    label = T.label{index};
    start_pos = index;
    end_pos = index +1;
    color = network_colors(label); 
    fprintf(fileID, 'band\t%s\t%s\t%s\t%d\t%d\t%s\t \n', network, node, node, start_pos, end_pos, color);
end
fclose(fileID);

%%%%%===========calculate  links============%%%%%%
Z=zeros(N);X=zeros(N);
for sub=1:N_sub
    path=strcat('G:\creativity\fMRI\globalretained\',num2str(Subj(sub)),'_Schaefer2018_100_BOLD.mat');
    MRI=load(char(path));
    BOLD=MRI.object_BOLD(1:141,:);
    FC1=corr(BOLD);
    FC1(FC1<0)=0;
    Z=Z+FC1;
    path=strcat('G:\creativity\fMRI\globalretained\',num2str(Subj(sub)),'_Schaefer2018_100_BOLD.mat');
    MRI=load(char(path));
    BOLD=MRI.BOLD(1:141,:);
    FC2=corr(BOLD);
    FC2(FC2<0)=0;
    X=X+FC2;
end
FC =(Z/N_sub-X/N_sub);

sortedValues = sort(FC(:), 'descend');
thresholdValue = sortedValues(round(threshold * numel(sortedValues)));
FC(FC < thresholdValue) = 0;

[sourceNetwork, sourceNode, targetNetwork, targetNode] = identifyConnections(FC, Core, OBJ, CRE, name);

region = char(strcat(output,'region_100.txt'));
S = table(sourceNetwork, sourceNode, targetNetwork, targetNode, 'VariableNames', {'source_network', 'source_node', 'target_network', 'target_node'});
transform_connections_script(S,threshold,region,'OCT_REST_100');
