extends RefCounted
class_name Tasks_Holder

var tasks : Array[Task] = [] #Task


func extract_data_from_log_entry(log_entry : Log_Entry):
	var task_id = log_entry.task_id
	var task : Task = get_task_by_id(task_id)
	if not task:
		task = create_task(task_id)
		tasks.append(task)
	
	match log_entry.task_step:
		"ClientTaskCreated":
			task.is_created = true
		"ClientTaskAccepted":
			task.is_accepted = true
		"ClientTaskSubmitted":
			task.is_submitted = true
		"ClientTaskResultReceivedWithinDeadline":
			task.is_rceived_within_deadline = true
		"ClientTaskRejected":
			task.is_rejected = true
		"ClientTaskResultReceivedAfterDeadline":
			task.is_received_after_deadline = true
		_:
			assert(false)
	
	var content = log_entry.content
	if not content:
		return
	task.content[log_entry.task_step] = content
	
	if task.is_rceived_within_deadline:
		task.calculate_laxity()

func get_task_by_id(task_id):
	for task in tasks:
		if task.task_id == task_id:
			return task

func create_task(task_id):
	var task = Task.new()
	task.task_id = task_id
	return task

func get_average_laxity():
	var sum = 0.0
	var count = 0.0
	for task in tasks:
		if not task.is_rceived_within_deadline:
			continue
		sum += task.laxity
		count += 1.0
	if count <= 0.0:
		return 0.0
	var average_laxity = sum/count
	return average_laxity

func get_tasks():
	return tasks
