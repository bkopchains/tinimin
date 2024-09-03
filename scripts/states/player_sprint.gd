class_name PlayerSprint
extends State

var direction: Vector2;

func enter():
	parent.dust.emitting = true;
	parent.detached = true;
	
func exit():
	parent.dust.emitting = false;
	#parent.detached = false;

func input_update(_event):
	if(Input.is_action_just_pressed("action")):
		Transitioned.emit(self, "detached")

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
		
		parent.velocity = direction * parent.DETACHED_SPEED;
			
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.DETACHED_SPEED/20)
		parent.velocity.y = move_toward(parent.velocity.y, 0, parent.DETACHED_SPEED/20)
	
	parent.move_and_slide();
	
	if(parent.velocity.x == 0 and parent.velocity.y == 0 and 
		direction.x == 0 and direction.y == 0):
		Transitioned.emit(self, "idle");
		
	if(parent.line_undraw()):
		Transitioned.emit(self, "move");
