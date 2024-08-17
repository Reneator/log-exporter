extends Node


var editor_dir_path = "res://Logs"

var analyis_file_name = "Analysis_Result.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var entities = import_files()
	var analysis = analyse_entities(entities)
	save_analysis_to_file(analysis)
	get_tree().quit()

func analyse_entities(entities : Array):
	var task_steps_count = extract_task_steps_count(entities)
	var average_laxity_per_client = generate_average_laxity_per_client(entities)
	var analysis = Analysis_Results.new()
	analysis.generate_entity_task_steps(entities)
	
	var average_laxity = calculate_average_laxity(average_laxity_per_client)
	analysis.avergae_laxity_per_entity = average_laxity_per_client
	analysis.average_laxity = average_laxity
	analysis.task_step_counts = task_steps_count
	analysis.total_clients = entities.size()
	return analysis

func generate_average_laxity_per_client(entities):
	var average_laxity_per_client = {}
	for entity : Entity in entities:
		if not entity is Client:
			continue
		average_laxity_per_client[entity.entity_id] = entity.get_average_laxity()
	return average_laxity_per_client


func extract_task_steps_count(entities):
	var task_steps_count = {}
	for entity : Entity in entities:
		if not entity is Client:
			continue
		var entity_task_steps = entity.get_task_steps_count_filter_aborted_tasks_from_aborting_program()
		Util_Dict.add_dict_to_dict(task_steps_count, entity_task_steps)
	return task_steps_count
	

func calculate_average_laxity(dict : Dictionary):
	var sum = 0.0
	var count = 0.0
	for key in dict:
		var laxity = dict[key]
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
	entity.file_path = file_path
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
	return null
	if "distributed_node" in file_path:
		return Distributed_Node.new()
		
	print("No Entity found for file: %s" % file_path)
	assert(false)

func get_dir_path():
	if OS.is_debug_build():
		return editor_dir_path
	return OS.get_executable_path().get_base_dir()
