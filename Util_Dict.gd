extends RefCounted
class_name Util_Dict

static func add_value_to_dict(dict, key, value):
	if not key in dict:
		dict[key] = 0
	dict[key] += value

static func add_dict_to_dict(target_dict, source_dict):
	for key in source_dict:
		var value = source_dict[key]
		add_value_to_dict(target_dict, key, value)
