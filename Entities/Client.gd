extends Entity
class_name Client

var worst_case_execution_time

func on_log_line_process(log_line):
	if  not "Running `" in log_line:
		return
	var parts = log_line.split(" ")
	worst_case_execution_time = float(parts[9])
	Global.worst_case_execution_time_msecs = worst_case_execution_time
	Global.worst_case_execution_time_secs = worst_case_execution_time / 1000
		

func get_task_steps_count():
	var task_steps_count = {}
	for log_entry in log_entries:
		Util_Dict.add_value_to_dict(task_steps_count, log_entry.task_step, 1)
	return task_steps_count
