extends Area2D

signal baby_hit;
@onready var ap: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	ap.play("spawn");

func _on_body_entered(body: Node2D) -> void:
	var saved = false;
	if(body.name.to_lower() == "player"):
		saved = true;
	baby_hit.emit(self, saved);
	queue_free();
