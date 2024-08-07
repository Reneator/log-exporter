extends Node


var editor_dir_path = "res://Logs"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	import_files()


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
	pass

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
	entity.data = file_data
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
