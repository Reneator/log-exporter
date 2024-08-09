extends Node
class_name Analysis_Results

var average_laxity
var task_step_counts

func write_to_file(file: FileAccess):
	file.store_line("Thanks for using Ronny Analysis")
	file.store_line("You are using an evaluation license!")
	file.store_line("After your trial-period each analysis will cost 1 Million Monopoly Dollars")
	file.store_line("--------------------------------------")
	file.store_line("Results:")
	file.store_line("--------------------------------------")
	file.store_line("Average Laxity: %f" % average_laxity)
	file.store_line("--------------------------------------")
	file.store_line("Task Step Count:")
	for key in task_step_counts:
		file.store_line("%s: %d" % [key, task_step_counts[key]])
