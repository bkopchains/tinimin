class_name PlayerMove
extends State
var direction: Vector2;


func input_update(_event):
	if(Input.is_action_just_pressed("action")):
		Transitioned.emit(self, "sprint")

func physics_update(_delta):
	direction = Input.get_vector("left", "right", "up", "down");
	
	if(direction):
		if(direction.x < 0):
			parent.sprite.flip_h = 1;
		elif(direction.x > 0):
			parent.sprite.flip_h = 0;
		if(direction.y < 0):
			parent.ap.play("run_up");		
		else:
			parent.ap.play("run");	
		
		parent.velocity = direction * parent.SPEED;
			
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.SPEED/20)
		parent.velocity.y = move_toward(parent.velocity.y, 0, parent.SPEED/20)
	
	parent.line_draw();
	parent.move_and_slide();
	
	if(parent.velocity.x == 0 and parent.velocity.y == 0 and 
		direction.x == 0 and direction.y == 0):
		Transitioned.emit(self, "idle");
