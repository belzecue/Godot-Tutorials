class_name Paper
extends TextureRect

# Bool to check if pen is selected
var pen_selected : bool

# Color of the pen
const color : Color = Color( 0, 0, 0, 1 ) # Black

# Saves the Position if the Paper is being dragged
var drag_position : Vector2 = Vector2.ZERO

# Save the previouse Mouse position
var previous_mouse_position : Vector2 = Vector2.ZERO

# Create an Node2D for the pen when ready
onready var pen : Node2D = Node2D.new()

func set_pen_selected(is_selected : bool) -> void:
	self.pen_selected = is_selected

func make_signature_possible() -> void:
	# Create Viewport to render the drawing
	var viewport = Viewport.new()
	viewport.name = "Viewport"
	var rect = self.get_rect()
	viewport.size = rect.size
	viewport.usage = Viewport.USAGE_2D # Render Mode
	#viewport.render_target_clear_mode = Viewport.CLEAR_MODE_NEVER # Never Clear
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME # Works better!
	viewport.render_target_v_flip = true # OpenGL flips render target we have to flip it again
	viewport.transparent_bg = true # Set Background transparent so we see the drawing
	self.pen.name = "Node2D"
	viewport.add_child(self.pen) # Add the pen as child to viewport
	self.pen.connect("draw", self, "_on_draw") # Connect _on_draw with the draw method from pen
	self.add_child(viewport) # Add viewport as child
	
	# Use a sprite to display the result texture
	var rt = viewport.get_texture()
	var board = TextureRect.new()
	board.name = "TextureRect"
	board.set_texture(rt)
	self.add_child(board)
	
# Godot Functions
func _ready() -> void:
	self.make_signature_possible()

func _process(_delta) -> void:
	self.pen.update()

# Signals
func _on_draw() -> void:
	if self.pen_selected:
		var mouse_pos = self.get_local_mouse_position()
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			self.pen.draw_line(mouse_pos, self.previous_mouse_position, self.color)
		self.previous_mouse_position = mouse_pos

func _on_Paper_gui_input(event : InputEvent) -> void:
	if not self.pen_selected:
		if event is InputEventMouseButton:
			if event.pressed:
				self.drag_position = self.get_global_mouse_position() - self.rect_global_position
			else:
				self.drag_position = Vector2.ZERO
		if event is InputEventMouseMotion and drag_position != Vector2.ZERO:
			self.rect_global_position = self.get_global_mouse_position() - self.drag_position
