# Circos-plotting
## Scripts Description

### 1. main.m
This script is involved in analyzing creativity data and creates the `node.txt` and `connectivity.txt` for Circos plotting. In this script, you will need to calculate FC (Functional Connectivity), and you should have files describing regions and subnetworks as input.

### 2. identifyConnections.m
The `identifyConnections` function analyzes functional connectivity data, identifying connections between different nodes within specified networks.

### 3. transform_connections_script.m
This script focuses on transforming and filtering connection data from a `node.txt` file, applying thresholds to the connections. It's used for data visualization or further analysis in research.

### 4. circos.conf
This is a configuration file for Circos plotting. You must install the [Circos](http://circos.ca/) software.
Tips: Ubuntu may easier to install the software.

finally,below plotting will be obtain.

![Circos](https://github.com/cz-bszy/Circos-plotting/blob/main/plotting.png)
