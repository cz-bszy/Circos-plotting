function transform_connections_script(links,threshold,path,link_name,link_color)

    fileID = fopen(char(strcat(path,'region_100.txt')),'r');
    txtData = textscan(fileID, '%s', 'Delimiter', '\n');
    fclose(fileID);
    combinedRows = txtData{1};

    % Initialize output array
    output = {};

    % Loop through each row in connections
    for i = 1:height(links)
        sourceNode = links.source_node{i};
        targetNode = links.target_node{i};
        
        % Find corresponding start and end numbers for source and target nodes
        sourceIndices = find_indices(combinedRows, sourceNode);
        targetIndices = find_indices(combinedRows, targetNode);

        % Assign color and value based on source network
        [color, value] = assign_color_value(links.source_network{i},link_color);

        % Format and store the output
        outputRow = sprintf('%s\t%d\t%d\t%s\t%d\t%d\tcolor=%s,value=%d',...
                    links.source_network{i},...
                    sourceIndices(1), sourceIndices(2),...
                    links.target_network{i},...
                    targetIndices(1), targetIndices(2),...
                    color, value);
        output{end+1} = outputRow;
    end

    fileID = fopen(char(strcat(path,link_name,'_',num2str(threshold),'.txt')), 'w');
    fprintf(fileID, '%s\n', output{:});
    fclose(fileID);
end

function indices = find_indices(rows, nodeName)
    % Finds the start and end indices for a given node name in the rows data
    for j = 1:length(rows)
        splitRow = strsplit(rows{j}, '\t');
        for k = 1:length(splitRow)
            if strcmp(splitRow{k}, nodeName)
                indices = [str2double(splitRow{5}), str2double(splitRow{6})];
                return;
            end
        end
    end
    indices = [NaN, NaN]; % Return NaN if not found
end

function [color, value] = assign_color_value(network,link_color)
    r=link_color(1); g=link_color(2); b=link_color(3);
    color_tem = sprintf('%d,%d,%d', r, g, b);
    % Assigns color and value based on network name (customize as needed)
    switch network
        case 'Core'
            color = color_tem;
            value = 1;
        case 'OBJ'
            color = color_tem;
            value = 1;
        % Add more cases as needed
        otherwise
            color = color_tem;
            value = 1;
    end
end
