class_name Utils extends Node

static func find_node_by_name(root_node: Node, name_to_find: String) -> Node:
	if root_node.name == name_to_find:
		return root_node

	for i in range(root_node.get_child_count()):
		var child = root_node.get_child(i)
		var result = find_node_by_name(child, name_to_find)
		if result:
			return result

	return null
