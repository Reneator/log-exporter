extends Log_Entry
class_name Log_Entry_Metric


static func create(log_line : String) -> Log_Entry:
	if not "METRIC" in log_line:
		return
	var log_entry = Log_Entry_Metric.new()
	log_entry.initialize(log_line)
	return log_entry

func initialize(log_line : String):
	super.initialize(log_line)
	var split_data = log_line.split(" ")
	log_entry_type = split_data[3]
	entity_id = split_data[4]
	task_step = split_data[5]
	task_id = split_data[6]
	if task_step == "ClientTaskRejected":
		return
	content = JSON.parse_string(split_data[7])
	if content == null:
		pass
