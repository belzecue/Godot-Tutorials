class_name Main
extends Node2D

onready var paper : Paper = $Paper

# Bool to store if pen is selected
var pen_selected : bool = false

func _input(event) -> void:
	# Bool to check if the button is just pressed
	var just_pressed : bool = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_A) and just_pressed:
		self.select_pen()

func select_pen() -> void:
	# Function which selectes the pen
	self.pen_selected = not self.pen_selected
	paper.set_pen_selected(self.pen_selected)
	print(self.pen_selected)
