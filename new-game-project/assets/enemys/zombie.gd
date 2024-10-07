extends CharacterBody2D
@onready
var sprite=$AnimatedSprite2D
@onready
var colision=$CollisionShape2D
const SPEED = 300.0
var hp=50
var in_range=null
var in_atack_range
var dead=false
var direction=0
var atacking=false
func _physics_process(delta: float) -> void:
	if dead:
		return
	if hp<=0:
		die()
	if in_range!=null:
		if global_position<in_range.global_position:
			direction=1
			sprite.flip_h=false
		elif  global_position>in_range.global_position:
			direction=-1
			sprite.flip_h=true
	if not is_on_floor():
		velocity += get_gravity() * delta
	if direction and not atacking:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func damage(dano):
	hp-=dano
	print("levou dano")


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "atack" and sprite.frame>4 and in_atack_range!=null and in_atack_range.has_method("dano"):
		in_atack_range.dano(10)
	

func die():
	colision.disabled=true
	sprite.play("death")
	get_node("AtackLeft").set_monitoring(false)
	get_node("AtackRight").set_monitoring(false)
	get_node("Range").set_monitoring(false)
	dead=true


func _on_atack_body_entered(body: Node2D) -> void:
	if body==self or body.has_method("is_zombie"):
		return
	in_atack_range=body
	atacking=true
	sprite.play("atack")


func _on_atack_body_exited(body: Node2D) -> void:
	if body.has_method("is_zombie"):
		return
	if body==self:
		return
	in_atack_range=null
	atacking=null


func _on_range_body_entered(body: Node2D) -> void:
	if body.has_method("is_zombie"):
		return
	in_range=body

func _on_animated_sprite_2d_animation_finished() -> void:

	if sprite.animation == "atack":
		if in_atack_range== null:
			sprite.play("walk")
		else:
			sprite.play("atack")


func _on_range_body_exited(body: Node2D) -> void:
	if body.has_method("is_zombie"):
		return
	if body==in_range:
		in_range=null

func is_zombie():
	return true
