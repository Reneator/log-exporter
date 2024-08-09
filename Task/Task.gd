extends RefCounted
class_name Task

var task_id
var is_created = false
var is_submitted = false
var is_accepted = false
var is_rceived_within_deadline = false

var content = {}

var initial_slack_time
var time_to_deadline
var laxity


func calculate_laxity():
	var numbers = content["ClientTaskResultReceivedWithinDeadline"]
	initial_slack_time = float(numbers["initial_slack_time_secs"])
	time_to_deadline = float(numbers["time_to_deadline_secs"])
	laxity = initial_slack_time - time_to_deadline
	
