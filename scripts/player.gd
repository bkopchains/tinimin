class_name Player
extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var ap = $Sprite2D/AnimationPlayer
@onready var dust: CPUParticles2D = $dust
@onready var daze: AnimatedSprite2D = $Sprite2D/daze
@onready var game: Node2D = $".."

@onready var state_machine: StateMachine = $"State Machine"

const SPEED = 50.0
const DETACHED_SPEED = 60.0

var direction: Vector2 = Vector2(0,0);

var invulnerable = false;
var detached = false;

@export var line: Line2D;
@onready var booty_cooldown: Timer = $"Booty Cooldown"

func _ready() -> void:
	state_machine.init(self);

func _unhandled_input(event):
	state_machine.input_update(event);

func _process(delta: float) -> void:
	state_machine.update(delta);

func _physics_process(delta):
	state_machine.physics_update(delta);

func line_draw(pos: Vector2 = global_position) -> void:
	line.add_point(pos);
	if(line.get_point_count() > 60 + (game.score*20)):
		line.remove_point(0);

func line_undraw() -> bool:
	if(line.get_point_count() > 0):
		var idx = line.get_point_count()-1;
		var pointPos = line.get_point_position(idx);
		line.remove_point(idx);
		line.remove_point(0);
		if(!detached):
			position = pointPos;
			ap.play("slide");
		if(!invulnerable and line.get_point_count() <= 0):
			detached = false;
			return true;
		return false;
	else:
		return true;

func start_cooldown(sec: int) -> void:
	booty_cooldown.start(sec);
func _on_booty_cooldown() -> void:
	invulnerable = false;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(!invulnerable):
		if(detached):
			state_machine.force_child_transition("tripped")
		else:
			state_machine.force_child_transition("stunned")
