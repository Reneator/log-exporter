extends Node
class_name Analysis_Results

var average_laxity : float
var task_step_counts
var avergae_laxity_per_entity
var task_steps_count_per_entity = {}
var total_clients : int

func write_to_file(file: FileAccess):
	file.store_line("Thanks for using Ronny Analysis")
	file.store_line("You are using an evaluation license!")
	file.store_line("After your trial-period each analysis will cost 1 Million Monopoly Dollars")
	file.store_line("--------------------------------------")
	file.store_line("Results:")
	file.store_line("--------------------------------------")
	print(average_laxity)
	file.store_line("Average Laxity Total: %s" % average_laxity)
	file.store_line("--------------------------------------")
	file.store_line("Total Clients: %d" % total_clients )

	file.store_line("--------------------------------------")
	
	file.store_line("Task Step Count Total:")
	for key in task_step_counts:
		file.store_line("%s: %d" % [key, task_step_counts[key]])
	file.store_line("--------------------------------------")
	print_task_step_count_per_entity(file)
	file.store_line("--------------------------------------")
	
	#file.store_line("Average Laxity per Client:")
	#file.store_line("--------------------------------------")
	#for key in avergae_laxity_per_entity:
		#var value = avergae_laxity_per_entity[key]
		#file.store_line("%s: %f" % [key, value])
	#file.store_line("--------------------------------------")
	file.store_line("Thanks for flying with Ronny Airlines!")

func add_entity_task_steps(entity_id, entity_task_steps):
	task_steps_count_per_entity[entity_id] =  entity_task_steps
	
func print_task_step_count_per_entity(file):
	file.store_line("Details per Client:")
	file.store_line("--------------------------------------")

	for entity_id in task_steps_count_per_entity:
		var value : Dictionary = task_steps_count_per_entity[entity_id]
		file.store_line("%s:"% entity_id)
		if has_tasks_received_within_deadline(entity_id):
			file.store_line("Average Laxity for Client: %s" % get_laxity_for_id(entity_id))
		else:
			file.store_line("No Laxity possible, no task results received within Deadline!")

		for task_name in value:
			var count = value[task_name]
			file.store_line("%s:%d" %[task_name, count])
		file.store_line("--------------------------------------")

func get_laxity_for_id(entity_id):
	for id in avergae_laxity_per_entity:
		if not id == entity_id:
			continue
		var value = avergae_laxity_per_entity[id]
		return value

func get_task_steps_for_id(entity_id):
	for id in task_steps_count_per_entity:
		if id == entity_id:
			var dict = task_steps_count_per_entity[id]
			return dict
	
func has_tasks_received_within_deadline(entity_id):
	var count = get_tasks_step_count_for_type(entity_id, "ClientTaskResultReceivedWithinDeadline")
	return count > 0

func get_tasks_step_count_for_type(entity_id, type):
	var sum = 0.0
	var dict = get_task_steps_for_id(entity_id)
	for task_step_type in dict:
		if not task_step_type == type:
			continue
		var task_step_count = dict[task_step_type]
		sum += task_step_count
	return sum

func generate_entity_task_steps(entities):
	for entity : Entity in entities:
		if not entity is Client:
			continue
		var entity_task_steps = entity.get_task_steps_count()
		add_entity_task_steps(entity.entity_id, entity_task_steps)
		
