extends Node


var editor_dir_path = "res://Logs"

var analyis_file_name = "Analysis_Result.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var entities = import_files()
	var analysis = analyse_entities(entities)
	save_analysis_to_file(analysis)

func analyse_entities(entities : Array):
	var task_steps_count = {}
	var average_laxity_per_client = {}
	
	for entity : Entity in entities:
		if not entity is Client:
			continue
		for log_entry in entity.log_entries:
			add_value_to_dict(task_steps_count, log_entry.task_step, 1)
		average_laxity_per_client[entity.entity_id] = entity.get_average_laxity()
	
	var average_laxity = calculate_average_laxity(average_laxity_per_client)
	var analysis = Analysis_Results.new()
	analysis.average_laxity = average_laxity
	analysis.task_step_counts = task_steps_count
	return analysis

func calculate_average_laxity(dict : Dictionary):
	var sum = 0.0
	var count = 0.0
	for laxity in dict.values():
		count += 1.0
		sum += laxity
	var average_laxity = sum/count
	return average_laxity

func save_analysis_to_file(analysis_results : Analysis_Results):
	var file_path = get_dir_path() + "/" + analyis_file_name
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	analysis_results.write_to_file(file)
	file.close()

		
func add_value_to_dict(dict, key, value):
	if not key in dict:
		dict[key] = 0
	dict[key] += value

func import_files():
	var dir = get_dir_path()
	var file_paths : Array = Util_Dir.load_directory_as_array(dir,".log")
	print(file_paths)
	
	var entities = []
	for file_path in file_paths:
		var entity = load_entity(file_path)
		if not entity:
			continue
		entities.append(entity)
	return entities

func load_entity(file_path):
	var entity = create_entity(file_path)
	if not entity:
		return
	var file = FileAccess.open(file_path, FileAccess.READ)
	print("Loading File %s" % file_path)
	var error = FileAccess.get_open_error()
	if error != 0:
		print("Error loading file: %s" % error)
		return
	var file_data = []
	while not file.eof_reached():
		var file_line = file.get_line()
		file_data.append(file_line)
	entity.initialize(file_data)
	return entity

func create_entity(file_path):
	if "client" in file_path:
		return Client.new()
	if "distributed_node" in file_path:
		return Distributed_Node.new()
		
	print("No Entity found for file: %s" % file_path)
	assert(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_dir_path():
	if OS.is_debug_build():
		return editor_dir_path
	return OS.get_executable_path().get_base_dir()
