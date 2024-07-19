extends Node2D
@onready var baby_timer = $BabyTimer
var gestation_period = 2.5;
var baby: Area2D = null;
var baby_scene: Resource = null;
@onready var label: Label = $Label
@onready var score_label: Label = $Node2D/Score
@onready var score_ap: AnimationPlayer = $Node2D/Score/ScoreAnimator

var score = 0;

func _ready() -> void:
	baby_scene = preload("res://scenes/baby.tscn")
	baby_timer.start(gestation_period);
	
func make_baby() -> void:
	
	baby = baby_scene.instantiate();
	baby.connect("baby_hit", kill_baby);
	print(baby.get_instance_id());
	get_tree().call_group("enemies", "baby_alert", str(baby.get_instance_id()), baby);
	
	var visible: Vector2 = get_viewport().get_visible_rect().size/2.25;
	baby.global_position = Vector2(randf_range(-visible.x, visible.x),randf_range(-visible.y, visible.y))
	add_child(baby);

func kill_baby(ded, saved) -> void:
	get_tree().call_group("enemies", "baby_deleted", str(ded.get_instance_id()));
	if(saved):
		score += 1;
		score_ap.play("add");
	elif(score > 0):
		score -= 1; 
		score_ap.play("remove");
	score_label.text = var_to_str(score);

func _on_baby_timer_timeout():
	#if(baby == null):
	#if(label):
		#label.queue_free();
		#label = null;
	make_baby();
	baby_timer.start(gestation_period);
