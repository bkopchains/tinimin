class_name Enemy
extends CharacterBody2D
@onready var sprite = $Sprite2D
@onready var ap = $Sprite2D/AnimationPlayer


const SPEED = 42.0
const JUMP_VELOCITY = -400.0
var direction: Vector2 = Vector2(0,0);
var drawing = true;
var to_chase: Dictionary = {"player": null}
var chasing: Node2D = null;

var offset_x: float = 0;
var offset_y: float = 0;

var drunkenness = 0;

@export var player: Player;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	to_chase["player"] = player;
	drunkenness = randf_range(0.5,1.5)
	pass

func _physics_process(delta):
	offset_x = move_toward(offset_x, 0, 0.05*drunkenness);
	offset_y = move_toward(offset_y, 0, 0.05*drunkenness);
	
	if(offset_x == 0 and offset_y == 0):
		offset_x = randf_range(-1,1)*drunkenness;
		offset_y = randf_range(-1,1)*drunkenness;
	
	# this is also ass
	var closest: Node2D = to_chase["player"];
	var dist = 9999999;
	for key in to_chase.keys():
		if(to_chase[key]):
			var currDist = global_position.distance_to(to_chase[key].global_position);
			if(key == "player" and player.invulnerable):
				continue; #too lazy to clean this up
			elif(currDist < dist):
				closest = to_chase[key];
				dist = currDist;
				#direction = global_position.direction_to(closest.global_position);
	
	chasing = closest;
	var updateChance = randi_range(0,20);
	if(chasing != null and (updateChance < 1 or player.invulnerable)):
		direction = global_position.direction_to(chasing.global_position);
	
	if(direction):
		if(direction.x < 0):
			sprite.flip_h = 1;
		elif(direction.x > 0):
			sprite.flip_h = 0;
			
		velocity = (direction + Vector2(offset_x,offset_y)).normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/20)
		velocity.y = move_toward(velocity.y, 0, SPEED/20)
		
	if(direction.abs() != Vector2(0,0)):
		if(direction.y < 0):
			ap.play("run_up");		
		else:
			ap.play("run");
	else:
		ap.play("idle");
		
	move_and_slide();

func baby_alert(name, baby) -> void:
	#if(randi_range(0,4) == 2):
	to_chase[name] = baby;
	chasing = baby;

func baby_deleted(name) -> void:
	if(chasing == null):
		chasing = player;
	to_chase.erase(name);
