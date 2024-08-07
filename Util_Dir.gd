extends Node
class_name Util_Dir

enum ID_TYPE{FILE_NAME, ID_CONVERSION}

static func load_files_from_directory_as_array(directory_path, file_ending : String = "", search_sub_folders = true):
	var file_paths = load_directory_as_array(directory_path, file_ending, search_sub_folders)
	var files = []
	for file_path in file_paths:
		var loaded_file = load(file_path) #maybe i could change this to an asynchronous loading?
		if not loaded_file:
			continue
		files.append(loaded_file)
	return files

static func load_directory_as_array(directory_path, file_ending : String = "", search_sub_folders = true) -> Array:
	if not directory_path.ends_with("/"):
		directory_path += "/"
	
	var file_paths = []
	var directory : DirAccess = DirAccess.open(directory_path)
	var error_open = DirAccess.get_open_error()
	var error_begin = directory.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547

	while true: 
		var file_path = directory.get_next()
		if file_path == "":
			break
		if(directory.current_is_dir()):
			if not search_sub_folders:
				continue
			var sub_folder_path = directory_path + file_path
			if(!sub_folder_path.ends_with("/")):
				sub_folder_path += "/"
			file_paths += load_directory_as_array(sub_folder_path, file_ending, search_sub_folders)
		else:
			if file_ending and not file_ending.is_empty():
				if not file_path.ends_with(file_ending):
					continue
			file_paths.append(directory_path + file_path)
	directory.list_dir_end()
	return file_paths


static func load_directory_as_dict(directory_path, id_type) -> Dictionary:
	var file_dict = {}
	var file_paths = load_directory_as_array(directory_path)
	
	for file_path in file_paths:
		convert_to_dict_entry_and_add_to_dict(file_path, file_dict, id_type)
		
	return file_dict



static func convert_to_dict_entry_and_add_to_dict(file_path:String, dict:Dictionary, id_type):
	var file_parts = file_path.split("/")
	var file_name = file_parts[file_parts.size() - 1]
	if(id_type == ID_TYPE.ID_CONVERSION):
		var splits = file_name.split("_")
		var id = splits[0]
		dict[id] = file_path
		
	elif id_type == ID_TYPE.FILE_NAME:
		var id = file_name.split(".")[0]
		dict[id] = file_path
		
	else:
		print("Error creating entry for dictionary @DictionaryLoader, no proper id_type was given: " + str(id_type))

static func dir_exists(dir_path):
	var dir_exists = DirAccess.dir_exists_absolute(dir_path)
	return dir_exists

static func make_dir(dir_path):
	var error = DirAccess.make_dir_recursive_absolute(dir_path)
	if error:
		print(error)
		assert(false)


static func clear_dir(directory_path):
	var dir = DirAccess.open(directory_path)
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	while(true):
		var path = dir.get_next()
		var full_path = directory_path + "/" + path
		if not path:
			break
		if dir.current_is_dir():
			clear_dir(full_path)
			dir.remove(full_path)
		else:
			dir.remove(path)
	print("Successfully cleared the DirAccess: %s"%directory_path)


static func initialize_folder(folder_name, path):
	var folder_path = path + "/" + folder_name
	var error = DirAccess.make_dir_absolute(folder_path)
	if error:
		print("Error %s creating directory: %s" % [error,folder_path])
		assert(false)
	return folder_path
