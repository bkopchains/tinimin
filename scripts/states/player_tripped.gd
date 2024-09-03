class_name PlayerTripped
extends State

var stun_time = 3;

func enter():
	stun_time = 3;
	parent.invulnerable = true;
	parent.daze.visible = true;
	parent.ap.play("tripped");
	
func exit():
	parent.daze.visible = false;
	parent.start_cooldown(2);

func update(_delta):
	if(stun_time > 0):
		stun_time -= _delta;
	else:
		Transitioned.emit(self, "idle");

func physics_update(_delta):
	parent.line_undraw();

