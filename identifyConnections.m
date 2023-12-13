function [sourceNetwork, sourceNode, targetNetwork, targetNode] = identifyConnections(FC, Core, OBJ, CRE, name)
    sourceNetwork = {};
    sourceNode = {};
    targetNetwork = {};
    targetNode = {};

    for i = 1:size(FC, 1)
        for j = i+1:size(FC, 2) % Start from i+1 to avoid duplicates
            if FC(i, j) ~= 0
                % Check if both nodes are in the networks of interest
                if ismember(i, [Core; OBJ; CRE]) && ismember(j, [Core; OBJ; CRE])
                    % Determine source network
                    if ismember(i, Core)
                        sourceNetwork{end+1,1} = 'Core';
                    elseif ismember(i, OBJ)
                        sourceNetwork{end+1,1} = 'OBJ';
                    elseif ismember(i, CRE)
                        sourceNetwork{end+1,1} = 'CRE';
                    end

                    % Determine target network
                    if ismember(j, Core)
                        targetNetwork{end+1,1} = 'Core';
                    elseif ismember(j, OBJ)
                        targetNetwork{end+1,1} = 'OBJ';
                    elseif ismember(j, CRE)
                        targetNetwork{end+1,1} = 'CRE';
                    end

                    % Add node names
                    sourceNode{end+1,1} = name{i};
                    targetNode{end+1,1} = name{j};
                end
            end
        end
    end
end
