class_name Player
extends CharacterBody2D
@onready var sprite = $Sprite2D
@onready var ap = $Sprite2D/AnimationPlayer
@onready var dust: CPUParticles2D = $dust
@onready var daze: AnimatedSprite2D = $Sprite2D/daze
@onready var game: Node2D = $".."

const SPEED = 50.0
const DETACHED_SPEED = 60.0
const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2(0,0);
var booty_sliding = false;
var vulnerable = true;

var detached = false;

@export var line: Line2D;
@onready var booty_timer: Timer = $"Booty Timer"
@onready var booty_cooldown: Timer = $"Booty Timer/Booty Cooldown"

func _unhandled_input(event):
	direction = Input.get_vector("left", "right", "up", "down");
	
	if(Input.is_action_just_pressed("space")):
		#line.clear_points();
		booty_sliding = true;
	if(Input.is_action_just_pressed("action") and !booty_sliding):
		detatch();

func _physics_process(delta):
	if(direction and !booty_sliding):
		if(direction.x < 0):
			sprite.flip_h = 1;
		elif(direction.x > 0):
			sprite.flip_h = 0;
		if(!booty_sliding):
			velocity = direction * (DETACHED_SPEED if detached else SPEED);
			
		if(detached):
			dust.emitting = true;
			dust.look_at(direction);
		else:
			dust.emitting = false;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/20)
		velocity.y = move_toward(velocity.y, 0, SPEED/20)
		
	if(direction.abs() != Vector2(0,0) and !booty_sliding):
		if(direction.y < 0):
			ap.play("run_up");		
		else:
			ap.play("run");
		
		

	if((velocity.x or velocity.y) and !booty_sliding):
		if(!detached):
			line_draw(global_position);
		else:
			line_undraw();
		move_and_slide();
		daze.visible = false;
	else:
		line_undraw();
		if(!detached and vulnerable):
			ap.play("idle");
			daze.visible = false;
		else:
			daze.visible = true;

func line_draw(pos: Vector2) -> void:
	line.add_point(pos);
	if(line.get_point_count() > 60 + (game.score*20)):
		line.remove_point(0);

func line_undraw() -> void:
	if(line.get_point_count() > 0):
		var idx = line.get_point_count()-1;
		var pointPos = line.get_point_position(idx);
		line.remove_point(idx);
		line.remove_point(0);
		if(!detached):
			position = pointPos;
			ap.play("slide");
	if(vulnerable and line.get_point_count() <= 0):
		detached = false;
	

func detatch():
	detached = true;

func _on_booty_timeout() -> void:
	booty_sliding = false;
	if(detached):
		booty_cooldown.start(3);
	else:
		booty_cooldown.start(2);


func _on_booty_cooldown() -> void:
	vulnerable = true;


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(vulnerable):
		if(detached):
			booty_timer.start(3);
			booty_sliding = true;
			vulnerable = false;
			ap.play("tripped")
		else:
			booty_timer.start(2);
			booty_sliding = true;
			vulnerable = false;
