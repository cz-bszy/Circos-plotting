rm(list=ls()) 
library(ggraph)
library(igraph)
library(tidyverse)
library(RColorBrewer)

# Read the data
nodes_df <- read.csv("C:/Users/bszyc/Desktop/OBJ_REST_nodes.csv")
connective_df <- read.csv("C:/Users/bszyc/Desktop/connective.csv")

hierarchy <- select(connective_df,source_node,target_node) %>%
  rename(from = source_node,to=target_node)

vertices <- 
  vertices  <-  data.frame(
    name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to))) , 
    value = runif(length(unique(c(as.character(hierarchy$from), as.character(hierarchy$to)))))
  )

nodes_df$node <- as.character(nodes_df$node)

vertices <- vertices %>%
  left_join(nodes_df, by = c("name" = "node")) %>%
  mutate(group = network) %>%
  select(-network) 

new_vertices <- nodes_df %>%
  anti_join(vertices, by = c("node" = "name")) %>%
  rename(name = node,group=network) %>%
  mutate(value = runif(n()))  

vertices <- bind_rows(vertices, new_vertices)

if (!"group" %in% colnames(vertices)) {
  vertices <- vertices %>%
    left_join(nodes_df, by = c("name" = "node")) %>%
    mutate(group = network) %>%
    select(-network)
}

connect <- connective_df %>%
  filter(source_node %in% nodes_df$node & target_node %in% nodes_df$node) %>%
  transmute(from = source_node, to = target_node)


mygraph <- graph_from_data_frame(hierarchy, vertices = vertices)

from <- match(connect$from, vertices$name)
to <- match(connect$to, vertices$name)

# Define custom colors for networks
network_colors <- setNames(brewer.pal(length(unique(nodes_df$network)), "Set1"), unique(nodes_df$network))

p <- ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_node_point(aes(alpha = 1) + 
  geom_conn_bundle(data = get_con(from = from, to = to), alpha = 0.8, colour = "black", tension = 0.8) + 
  scale_colour_manual(values = network_colors) +
  theme_void() +
  theme(plot.background = element_rect(fill = "white", colour = "white"),
        legend.position = "none")


ggsave("C:/Users/bszyc/Desktop/my_graph.png",p, width = 10, height = 10, dpi = 300, bg = "white")







