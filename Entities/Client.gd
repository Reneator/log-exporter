extends Entity
class_name Client


func get_task_steps_count():
	var task_steps_count = {}
	for log_entry in log_entries:
		Util_Dict.add_value_to_dict(task_steps_count, log_entry.task_step, 1)
	return task_steps_count
