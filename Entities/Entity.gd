extends RefCounted
class_name Entity

var entity_id

var data = []

var log_entries = []

var tasks_holder = Tasks_Holder.new()

func initialize(log_lines):
	data = log_lines
	process_log_lines(log_lines)

func process_log_lines(log_lines):
	for log_line : String in log_lines:
		var log_entry = create_log_entry(log_line)
		if not log_entry:
			continue
		tasks_holder.extract_data_from_log_entry(log_entry)
		log_entries.append(log_entry)
	if not log_entries:
		return
	entity_id = log_entries[0].entity_id

func create_log_entry(log_line : String):
	if "METRIC" in log_line:
		return Log_Entry_Metric.create(log_line)
	return
	return Log_Entry.create(log_line)
		
func get_average_laxity():
	var average_laxity = tasks_holder.get_average_laxity()
	if average_laxity < 0 or not typeof(average_laxity) == TYPE_FLOAT:
		pass
	return average_laxity
