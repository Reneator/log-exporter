extends RefCounted
class_name Log_Entry

var raw_log_line

var date_string
var log_entry_type
var entity_id
var task_step
var task_id
var content

func set_data(file_line):
	pass

func initialize(log_line : String):
	raw_log_line = log_line
	var split_data = log_line.split(" ")
	date_string = split_data[0].replace("[","")

	




static func create(log_line : String) -> Log_Entry:
	var log_entry =  Log_Entry.new()
	log_entry.initialize(log_line)
	return log_entry
