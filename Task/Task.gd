extends RefCounted
class_name Task

var task_id
var is_created = false
var is_submitted = false
var is_accepted = false
var is_rceived_within_deadline = false
var is_rejected = false
var is_received_after_deadline = false

var content = {}

var initial_slack_time
var time_to_deadline
var worst_case_execution_time
var actual_exec_time

var laxity


func calculate_laxity():
	actual_exec_time = get_actual_exec_time()
	worst_case_execution_time = Global.worst_case_execution_time_secs
	
	
	var numbers = content["ClientTaskResultReceivedWithinDeadline"]
	initial_slack_time = float(numbers["initial_slack_time_secs"])
	time_to_deadline = float(numbers["time_to_deadline_secs"])
	
	laxity = (initial_slack_time + (worst_case_execution_time - actual_exec_time)) - time_to_deadline
	pass
#(slack_time + (wc_exec_time - actual_exec_time)) - ttd

func get_actual_exec_time():
	for step_type in content:
		if not step_type == "ClientTaskCreated":
			continue
		var dict = content[step_type]
		return float(dict["exec_time_secs"])
	assert(false)

func is_complete():
	return is_rceived_within_deadline or is_received_after_deadline or is_rejected

func get_task_steps_count():
	var task_step_count = {}
	if is_created:
		task_step_count["ClientTaskCreated"] = 1
	if is_submitted:
		task_step_count["ClientTaskSubmitted"] = 1
	if is_accepted:
		task_step_count["ClientTaskAccepted"] = 1
	if is_rceived_within_deadline:
		task_step_count["ClientTaskReceivedWithinDeadline"] = 1
	if is_rejected:
		task_step_count["ClientTaskRejected"] = 1
	if is_received_after_deadline:
		task_step_count["ClientTaskReceivedAfterDeadline"] = 1
	return task_step_count
