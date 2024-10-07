extends Area2D
@onready
var sprite=$Icon

var direction=Vector2(0,0);
func _ready() -> void:
	if direction.x>0:
		sprite.flip_h=false
	elif direction.x<0:
		sprite.flip_h=true

func _physics_process(delta: float) -> void:
	global_position+=direction*1400*delta

func set_direction(direction: Vector2):
	self.direction=direction

func _on_body_entered(body):
	if body.has_method("damage"):
		body.damage(20)
	queue_free()
