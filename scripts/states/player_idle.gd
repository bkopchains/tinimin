class_name PlayerIdle
extends State

const SPEED = 50.0
var direction: Vector2;

func enter():
	direction = Vector2(0,0);
	parent.ap.play("idle");

func input_update(_event: InputEvent):
	direction = Input.get_vector("left", "right", "up", "down");

func physics_update(_delta):
	parent.line_undraw();
	if(direction.x or direction.y):
		Transitioned.emit(self, "move");

