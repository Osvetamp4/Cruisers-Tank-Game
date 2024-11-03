extends Node2D

var map = {
	
}


func _ready():
	for i in get_tree().get_nodes_in_group("Nodes"):#instantiate the starting dictionary
		map[i.nodeName] = []
	for i in get_tree().get_nodes_in_group("Roads"):
		map[i.node1].append([i.node2,i.traversable,i.distance])
		map[i.node2].append([i.node1,i.traversable,i.distance])
	for i in map.keys():
		print(i + ": ",map[i])
