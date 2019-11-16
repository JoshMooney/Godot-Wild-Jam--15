extends Node2D
class_name DialogAction

export (String, FILE, "*.json") var dialog_file_path : String

func interact():
	var dialog = load_dialog(dialog_file_path)
	#yield(local_map.play_dialog(dialog), "complete")
	emit_signal("Finished")
	
func load_dialog(path) -> Dictionary:
	var file = File.new()
	assert file.file_exists(path)
	
	file.open(path, file.READ)
	var dialog = parse_json(file.get_as_text())
	assert dialog.size() >0
	
	return dialog
	