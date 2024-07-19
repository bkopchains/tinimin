extends Line2D
@onready var sb2d = $StaticBody2D

var shapes: Dictionary = {}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#this is ass
	for n in sb2d.get_children():
		sb2d.remove_child(n)
		n.queue_free()

	for i in points.size() - 1:
		#if(i < points.size() - 10):
			var point = points[i];
			var new_shape = CollisionShape2D.new()
			sb2d.add_child(new_shape)
			var segment = SegmentShape2D.new()
			segment.a = points[i]
			segment.b = points[i + 1]
			new_shape.shape = segment
