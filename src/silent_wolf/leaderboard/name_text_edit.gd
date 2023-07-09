extends TextEdit


@export var max_char_length = 10


func _on_text_changed():
	var caret = get_caret_column(0)
	
	text = text.replace("\n", "")
	
	if text.length() > max_char_length:
		text = text.substr(0, max_char_length)
	
	set_caret_column(caret)
